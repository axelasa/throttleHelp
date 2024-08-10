import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trnk_ice/features/presentation/pages/auth/models/user_data.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String name,
    required String password,
    required String alias,
    required String idNumber,
    required String bloodGroup,
    required String phoneNumber,
    required String insurancePolicy,
    required String insurancePolicyNumber,
    required String preferredHospital,
    required String nhifNumber,
    required List<Map<String,dynamic>> nextOfKin,
    required String motorCycleModel,
    required String motorCycleRegistration,
    required String motorCycleColor,
    required String motorCycleMake,
    required String motorCycleKenyaNumber,
  }) async {
    String resp = 'Please  try again later.';

    try {
      if (name.isNotEmpty || email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserData userData = UserData(
          uid: cred.user!.uid,
          email: email,
          name: name,
          alias: alias,
          idNumber: idNumber,
          bloodGroup: bloodGroup,
          phoneNumber: phoneNumber,
          insurancePolicy: insurancePolicy,
          insurancePolicyNumber: insurancePolicyNumber,
          preferredHospital: preferredHospital,
          nhifNumber: nhifNumber,
          nextOfKin: nextOfKin,
          motorCycleModel: motorCycleModel,
          motorCycleRegistration: motorCycleRegistration,
          motorCycleColor: motorCycleColor,
          motorCycleMake:motorCycleMake,
          motorCycleKenyaNumber: motorCycleKenyaNumber,
        );
        await _fireStore.collection('users').doc(cred.user!.uid).set(userData.toJson(),);
        resp = "Successfully registered";
      }
    } on FirebaseAuthException catch (e) {
      resp = e.message.toString();
    }

    return resp;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String resp = "provide correct credentials";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        resp = 'Success';
      } else {
        resp = 'provide correct credentials';
      }
    } on FirebaseAuthException catch (e) {
      resp = e.message.toString();
    }
    return resp;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint('DEBUG MESSAGE ${e.message.toString()}');
      return null;
    }
  }

  Future<UserData?> getUserData() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot snap =
            await _fireStore.collection('users').doc(currentUser.uid).get();
        return UserData.userdataFromSnapShot(snap);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user data: ${e.toString()}');
      return null;
    }
  }
}
