class Helper {
  String firstName;
  String lastName;
  int age;
  List<String> academicQualification;
  List<String> otherQualification;
  List<String> jobPosition;
  bool availability;
  int rating;
  String currentLocation;
  String profileImage;
  String category;

  Helper(
      {this.firstName,
      this.lastName,
      this.age,
      this.academicQualification,
      this.otherQualification,
      this.jobPosition,
      this.availability,
      this.rating,
      this.currentLocation,
      this.profileImage,
      this.category});

  factory Helper.fromJson(Map<String, dynamic> json) {
    var academicQualifications = json['academicQualification'];
    var otherQualifications = json['otherQualification'];
    var jobPositions = json['jobPositions'];

    return Helper(
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        academicQualification: academicQualifications.cast<String>(),
        otherQualification: otherQualifications.cast<String>(),
        jobPosition: jobPositions.cast<String>(),
        availability: json['availability'],
        rating: json['rating'],
        currentLocation: json['currentLocation'],
        profileImage: json['profileImage'],
        category: json['category']);
  }

  toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "academicQualification": academicQualification,
      "otherQualification": otherQualification,
      "jobPosition": jobPosition,
      "availability": availability,
      "rating": rating,
      "currentLocation": currentLocation,
      "profileImage": profileImage,
      "category": category
    };
  }
}
