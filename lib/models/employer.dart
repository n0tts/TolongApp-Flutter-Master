import 'package:cloud_firestore/cloud_firestore.dart';

class Employer {
  String firstName;
  String lastName;
  int age;
  List<dynamic> academicQualification;
  List<dynamic> otherQualification;
  List<dynamic> jobPosition;
  bool availability;
  int rating;
  GeoPoint currentLocation;
  String profileImage;
  String reference;
  String category;
  String address;
  String email;

  Employer(this.firstName, this.lastName, this.email, this.reference,
      {this.age,
      this.academicQualification,
      this.otherQualification,
      this.jobPosition,
      this.availability,
      this.rating,
      this.currentLocation,
      this.profileImage,
      this.category,
      this.address});

  Employer.fromMap(Map<String, dynamic> map) {
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.age = map['age'];
    this.academicQualification = map['academicQualification'];
    this.otherQualification = map['otherQualification'];
    this.jobPosition = map['jobPositions'];
    this.availability = map['availability'];
    this.rating = map['rating'];
    this.currentLocation = map['currentLocation'];
    this.profileImage = map['profileImage'];
    this.reference = map['reference'];
    this.category = map['category'];
    this.address = map['address'];
    this.email = map['email'];
  }

  Employer.map(dynamic json) {
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.age = json['age'];
    this.academicQualification = json['academicQualification'];
    this.otherQualification = json['otherQualification'];
    this.jobPosition = json['jobPositions'];
    this.availability = json['availability'];
    this.rating = json['rating'];
    this.currentLocation = json['currentLocation'];
    this.profileImage = json['profileImage'];
    this.reference = json['reference'];
    this.category = json['category'];
    this.address = json['address'];
    this.email = json['email'];
  }
  List<dynamic> get academicQualificationField => academicQualification;
  String get addressField => address;
  int get ageField => age;
  bool get availabilityField => availability;
  String get categoryField => category;
  GeoPoint get currentLocationField => currentLocation;
  String get firstNameField => firstName;
  List<dynamic> get jobPositionField => jobPosition;
  String get lastNameField => lastName;
  List<dynamic> get otherQualificationField => otherQualification;
  String get profileImageField => profileImage;
  int get ratingField => rating;
  String get emailField => email;
  String get referenceField => reference;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['age'] = age;
    map['academicQualification'] = academicQualification;
    map['otherQualification'] = otherQualification;
    map['jobPositions'] = jobPosition;
    map['availability'] = availability;
    map['rating'] = rating;
    map['currentLocation'] = currentLocation;
    map['profileImage'] = profileImage;
    map['reference'] = reference;
    map['category'] = category;
    map['address'] = address;
    map['email'] = email;

    return map;
  }

  Employer.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}
