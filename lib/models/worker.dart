import 'package:cloud_firestore/cloud_firestore.dart';

class Worker {
  String firstNameField;
  String lastNameField;
  String displayNameField;
  int ageField = 18;
  List<dynamic> academicQualificationField = ['SPM', 'Degree'];
  List<dynamic> otherQualificationField = ['N/A'];
  List<dynamic> jobPositionField = ['Waiter', 'Clerk'];
  bool availabilityField = true;
  int ratingField = 5;
  GeoPoint currentLocationField;
  String profileImageField;
  String referenceField;
  String categoryField = 'restaurant / cafe';
  String addressField;
  String mobileField;
  String emailField;

  Worker(this.firstNameField, this.lastNameField, this.emailField,
      this.referenceField,
      {this.ageField,
      this.academicQualificationField,
      this.otherQualificationField,
      this.jobPositionField,
      this.availabilityField,
      this.ratingField,
      this.currentLocationField,
      this.profileImageField,
      this.categoryField,
      this.addressField,
      this.mobileField,
      this.displayNameField});

  Worker.fromMap(Map<String, dynamic> map) {
    this.firstNameField = map['firstName'];
    this.lastNameField = map['lastName'];
    this.ageField = map['age'];
    this.academicQualificationField = map['academicQualification'];
    this.otherQualificationField = map['otherQualification'];
    this.jobPositionField = map['jobPositions'];
    this.availabilityField = map['availability'];
    this.ratingField = map['rating'];
    this.currentLocationField = map['currentLocation'];
    this.profileImageField = map['profileImage'];
    this.referenceField = map['reference'];
    this.categoryField = map['category'];
    this.addressField = map['address'];
    this.mobileField = map['mobileNo'];
    this.emailField = map['email'];
    this.displayNameField = map['firstName'] + ' ' + map['lastName'];
  }

  Worker.map(dynamic json) {
    this.firstNameField = json['firstName'];
    this.lastNameField = json['lastName'];
    this.ageField = json['age'];
    this.academicQualificationField = json['academicQualification'];
    this.otherQualificationField = json['otherQualification'];
    this.jobPositionField = json['jobPositions'];
    this.availabilityField = json['availability'];
    this.ratingField = json['rating'];
    this.currentLocationField = json['currentLocation'];
    this.profileImageField = json['profileImage'];
    this.referenceField = json['reference'];
    this.categoryField = json['category'];
    this.addressField = json['address'];
    this.mobileField = json['mobileNo'];
    this.emailField = json['email'];
    this.displayNameField = json['firstName'] + ' ' + json['lastName'];
  }
  List<dynamic> get academicQualification => academicQualificationField;
  String get address => addressField;
  int get age => ageField;
  bool get availability => availabilityField;
  String get category => categoryField;
  GeoPoint get currentLocation => currentLocationField;
  String get firstName => firstNameField;
  List<dynamic> get jobPosition => jobPositionField;
  String get lastName => lastNameField;
  List<dynamic> get otherQualification => otherQualificationField;
  String get profileImage => profileImageField;
  int get rating => ratingField;
  String get mobileNo => mobileField;
  String get reference => referenceField;
  String get email => emailField;
  String get displayName => displayNameField;

  setProfileImage(url) {
    profileImageField = url;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['firstName'] = firstNameField;
    map['lastName'] = lastNameField;
    map['age'] = ageField;
    map['academicQualification'] = academicQualificationField;
    map['otherQualification'] = otherQualificationField;
    map['jobPositions'] = jobPositionField;
    map['availability'] = availabilityField;
    map['rating'] = ratingField;
    map['currentLocation'] = currentLocationField;
    map['profileImage'] = profileImageField;
    map['reference'] = referenceField;
    map['category'] = categoryField;
    map['address'] = addressField;
    map['mobileNo'] = mobileField;
    map['email'] = emailField;
    return map;
  }

  Worker.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}
