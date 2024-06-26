import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class PickProfilePage extends StatefulWidget {
  @override
  _PickProfilePageState createState() => _PickProfilePageState();
}

class _PickProfilePageState extends State<PickProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _downloadUrl;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user!.uid}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _downloadUrl = downloadUrl;
      });

      // Save the download URL to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePicture': downloadUrl});
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.photos,
      Permission.camera,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 80.0,
                    backgroundImage: FileImage(_image!),
                  )
                : CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 80.0,
                      color: Colors.grey[700],
                    ),
                  ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Pick from Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Take a Photo'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Save Profile Picture'),
              onPressed: _uploadImage,
            ),
            if (_downloadUrl != null)
              Text(
                'Profile Picture Uploaded!',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
