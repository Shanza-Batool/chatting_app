import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<User?> signUp(String email, String password, String name, File? image) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String? imageUrl;
      if (image != null) {
        imageUrl = await _uploadImage(image, userCredential.user!.uid);
      }
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      });
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> _uploadImage(File image, String uid) async {
    final ref = _storage.ref().child('user_images').child('$uid.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}

