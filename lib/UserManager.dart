import 'package:chat_app/components/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  UserManager._privateConstructor();

  static final UserManager _instance = UserManager._privateConstructor();
  static UserManager get instance => _instance;

  User? _currentUser;
  ChatUser? _currentChatUser;

  User? get currentUser => _currentUser;
  ChatUser? get currentChatUser => _currentChatUser;

  void initializeUser(User? user, ChatUser? chatUser) {
    _currentUser = user;
    _currentChatUser = chatUser;
  }
}
