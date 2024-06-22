import 'dart:convert';
import 'dart:io';

import 'package:chat_app/components/User.dart';
import 'package:chat_app/components/custom_avatar.dart';
import 'package:chat_app/components/group_avatar.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/firestore_adapter.dart';
import 'package:chat_app/screens/group_profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:uuid/uuid.dart';

import '../UserManager.dart';

class ChatPage extends StatefulWidget {
  static String id = 'chat_page';
  final String avatarName;
  final List<ChatUser> chatUsers;
  final List<types.User> users;
  final String conversationId;
  final String? groupName;
  const ChatPage(
      {super.key,
      required this.users,
      required this.conversationId,
      required this.avatarName,
      this.groupName,
      required this.chatUsers});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late FirestoreAdapter firestore;
  late final types.User _user; // the current owner
  late final List<types.User> _thisUsers; // the person on the other side
  late final String _localFilePath;

  @override
  void initState() {
    super.initState();
    firestore = FirestoreAdapter();
    _thisUsers = widget.users;
    ChatUser myUser = UserManager.instance.currentChatUser!;
    _user = types.User(
        id: myUser.id,
        firstName: myUser.firstName,
        lastName: myUser.lastName,
        lastSeen: myUser.lastSeen.millisecond);
    _initializeMessages();
    subscribeToMessages();
  }

  types.User findAuthor(String id) {
    if (id == _user.id) return _user;
    for (types.User temp in _thisUsers) {
      if (id == temp.id) return temp;
    }
    throw "user not found";
  }

  void subscribeToMessages() {
    firestore.listenForMessageChanges(widget.conversationId).listen((snapshot) {
      if (mounted) {
        setState(() {
          if (snapshot.isNotEmpty) {
            snapshot.forEach((key, value) {
              var temp = types.TextMessage(
                  showStatus: true,
                  status: value["seen"] == true
                      ? types.Status.seen
                      : types.Status.delivered,
                  author: findAuthor(value["userId"]),
                  id: key,
                  text: value['text'],
                  createdAt: value['timestamp'].seconds * 1000);
              print("author ${temp.author} and message ${temp.text}");
              _addMessage(temp);
            });
          }
        });
      }
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
      _saveMessages();
    });
  }

  void _initializeMessages() async {
    final directory = await getApplicationDocumentsDirectory();
    _localFilePath = '${directory.path}/${widget.conversationId}_messages.json';

    if (await File(_localFilePath).exists()) {
      _loadMessages();
    } else {
      _fetchAndSaveMessages();
    }
  }

  void _loadMessages() async {
    final file = File(_localFilePath);
    final response = await file.readAsString();
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    if (mounted) {
      setState(() {
        _messages = messages;
      });
    }
  }

  void _fetchAndSaveMessages() async {
    final messages = await firestore.fetchMessages(widget.conversationId);
    if (messages.isEmpty) return;
    for (var message in messages) {
      var temp = types.TextMessage(
          showStatus: true,
          author: findAuthor(message["userId"]),
          id: const Uuid().v4(),
          text: message['text'],
          createdAt: (message['timestamp'].seconds * 1000));
      _addMessage(temp);
    }
  }

  void _saveMessages() async {
    final file = File(_localFilePath);
    final messagesJson = jsonEncode(_messages.map((e) => e.toJson()).toList());
    await file.writeAsString(messagesJson);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );
          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    firestore.sendMessage(message.text, widget.conversationId, _user.id);
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
  }

  /// sends a message
  /// @param controller, the text field controller to extract the message
  void _sendMessage(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      _handleSendPressed(types.PartialText(text: controller.text));
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    firestore.updateConversationLastRead(widget.conversationId, _user.id);
    final TextEditingController myController = TextEditingController();
    double heightRef = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(heightRef * 0.11),
        child: SafeArea(
          child: widget.groupName == null
              ? CustomAvatar(user: widget.chatUsers[0])
              : GroupAvatar(
                  groupName: widget.groupName!, users: widget.chatUsers),
        ),
      ),
      body: Chat(
          messages: _messages,
          //onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: (text) {},
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
          customBottomWidget: Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: myController,
              maxLines: 1,
              style: const TextStyle(
                  color: Color(0xff9691AA)), // Set the text color to white
              decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 60),
                  filled: true, // Set the background color
                  fillColor: const Color(0xff2D2253), // Use a dark purple color
                  border: OutlineInputBorder(
                    // Use a rounded border
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Type a message', // Add a hint text
                  hintStyle: const TextStyle(
                      color:
                          Colors.white70), // Set the hint text color to white70
                  prefixIcon: GestureDetector(
                      onTap: _handleAttachmentPressed,
                      child: const Icon(Icons.attach_file,
                          color: Color(0xff9691AA))), // Add a paperclip icon
                  suffixIcon: GestureDetector(
                      onTap: () {
                        _sendMessage(myController);
                      },
                      child: const Icon(Icons.send_outlined))),
            ),
          ),
          theme: const DarkChatTheme()),
    );
  }
}
