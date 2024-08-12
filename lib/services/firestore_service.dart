library flutter_template;
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_template/objects/app_user.dart';
import 'package:flutter_template/objects/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  User authUser = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<AppUser?> getUser(String uid) async {
    try {
      var snapshot = await firestore.collection('users').doc(uid).get();
      AppUser user = AppUser.fromFirestore(snapshot);
      if (authUser.uid == uid){
        globals.user = user;
      }
      return user;
    } catch (e) {
      debugPrint('Error getUser: $e');
      return null;
    }
  }

  Future<String?> getUID(String username) async {
    try{
      QuerySnapshot usersSnapshot = await firestore
      .collection('users')
      .where('username', isEqualTo: username)
      .get();

      if (usersSnapshot.docs.isNotEmpty){
        return usersSnapshot.docs.first.id;
      }
    }catch(e){
      debugPrint('Error getUID: $e');
    }
    return null;
  }

  Future<void> setUsername(String username) async {
    try{
      DocumentReference userDocRef = firestore.collection('users').doc(authUser.uid);
      String? someUid = await getUID(username);
      if (someUid == null){
        await userDocRef.set({
          'username': username
        }, SetOptions(merge: true));
      }
    }catch(e){
      debugPrint('Error setUsername: $e');
    }
  }

  Future<void> setProfilePicture(String path) async {
    try{
      String url = '';
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref = storage.ref().child("${authUser.uid}/profile/${DateTime.now()}");
      UploadTask uploadTask = ref.putFile(File(path));

      final snapshot = await uploadTask.whenComplete(() {});
      url = await snapshot.ref.getDownloadURL();

      DocumentReference userDocRef = firestore.collection('users').doc(authUser.uid);
      if (url.isNotEmpty){
        await userDocRef.set({
          'image': url
        }, SetOptions(merge: true));
      }
    }catch(e){
      debugPrint('Error setProfilePicture: $e');
    }
  }

  Future<AppUser?> initializeUser() async {
    try{
      if (globals.user == null){
        DocumentReference userDocRef = firestore.collection('users').doc(authUser.uid);
        DocumentSnapshot userDoc = await userDocRef.get();
        if (!userDoc.exists){
          String username = authUser.displayName!.replaceAll(' ', '').toLowerCase();
          if (username.length > 8){
            username = username.substring(0,8);
          }

          int counter = 0;
          String? someUid = await getUID(username);
          while (someUid != null) {
            counter++;
            username = '$username$counter';
            someUid = await getUID(username);
          }

          await userDocRef.set({
            'username': username,
            'email': authUser.email,
            'joined' : FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        await FirestoreService().getUser(authUser.uid);
      }
    }catch(e){
      debugPrint('Error initializeUser: $e');
    }
    return globals.user;
  }

  void signOut() async {
    globals.user = null;
    FirebaseAuth.instance.signOut();
  }

  void deleteAccount() async {
    DocumentReference userDocRef = firestore.collection('users').doc(authUser.uid);
    await userDocRef.delete();

    signOut();
  }
}
