import 'package:cloud_firestore/cloud_firestore.dart';

// class MyContact {}

class UserData {
  final String? uid;
  final String? email;
  final String? name;
  final String? alias;
  final String? idNumber;
  final String? bloodGroup;
  final String? phoneNumber;
  final String? insurancePolicy;
  final String? insurancePolicyNumber;
  final String? preferredHospital;
  final String? nhifNumber;
  // final Map<int, Map<String,dynamic>>? contact;
  final List<Map<String,dynamic>>? nextOfKin;
  final String? motorCycleModel;
  final String? motorCycleRegistration;
  final String? motorCycleColor;
  final String? motorCycleMake;
  final String? motorCycleKenyaNumber;
  final String? profileImage;

  UserData({
    this.uid,
    this.email,
    this.name,
    this.alias,
    //this.dateOfBirth,
    this.idNumber,
    this.phoneNumber,
    this.bloodGroup,
    this.nextOfKin,
    this.insurancePolicy,
    this.insurancePolicyNumber,
    this.preferredHospital,
    this.nhifNumber,
    this.motorCycleModel,
    this.motorCycleRegistration,
    this.motorCycleColor,
    this.motorCycleMake,
    this.motorCycleKenyaNumber,
    this.profileImage
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'alias': alias,
        'idNumber': idNumber,
        'phoneNumber': phoneNumber,
        'bloodGroup': bloodGroup,
        'nextOfKin': nextOfKin ,
        'insurancePolicy': insurancePolicy,
        'insurancePolicyNumber': insurancePolicyNumber,
        'preferredHospital': preferredHospital,
        'nhifNumber': nhifNumber,
        'motorCycleModel': motorCycleModel,
        'motorCycleRegistration': motorCycleRegistration,
        'motorCycleColor': motorCycleColor,
        'motorCycleMake':motorCycleMake,
        'motorCycleKenyaNumber': motorCycleKenyaNumber,
        'profileImage': profileImage
      };

  static UserData? userdataFromSnapShot(DocumentSnapshot snap) {
    if (snap.exists) {
      var snapshot = snap.data() as Map<String, dynamic>;

      // Convert the 'nextOfKin' field from Firestore into a list of maps
      List<dynamic>? nextOfKinListDynamic = snapshot['nextOfKin'];
      List<Map<String, dynamic>> nextOfKinList = [];
      if (nextOfKinListDynamic != null) {
        nextOfKinListDynamic.forEach((kin) {
          if (kin is Map<String, dynamic>) {
            nextOfKinList.add(kin);
          }
        });
      }

      return UserData(
        uid: snapshot['uid'] ?? '',
        email: snapshot['email'] ?? '',
        name: snapshot['name'] ?? '',
        alias: snapshot['alias'] ?? '',
        idNumber: snapshot['idNumber'] ?? '',
        bloodGroup: snapshot['bloodGroup'] ?? '',
        phoneNumber: snapshot['phoneNumber'] ?? '',
        insurancePolicy: snapshot['insurancePolicy'] ?? '',
        insurancePolicyNumber: snapshot['insurancePolicyNumber'] ?? '',
        preferredHospital: snapshot['preferredHospital'] ?? '',
        nhifNumber: snapshot['nhifNumber'] ?? '',
        nextOfKin: nextOfKinList,
        motorCycleModel: snapshot['motorCycleModel'] ?? '',
        motorCycleRegistration: snapshot['motorCycleRegistration'] ?? '',
        motorCycleColor: snapshot['motorCycleColor'] ?? '',
        motorCycleMake:snapshot['motorCycleMake'] ?? '',
        motorCycleKenyaNumber: snapshot['motorCycleKenyaNumber'] ?? '',
        profileImage: snapshot['profileImage'] ?? '',
      );
    } else {
      return null;
    }
  }
}

class NextOfKin {
  final String name;
  final String phoneNumber;
  final String principal;

  NextOfKin({
    required this.name,
    required this.phoneNumber,
    required this.principal
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'principal':principal
    };
  }
}