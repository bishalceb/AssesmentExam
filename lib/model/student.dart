class Student {
  String id;
  String name;
  String studentCode;
  String studentRollNo;
  String fatherName;
  String email;
  String password;
  String phone;
  String dob;
  String gender;
  bool is_present;
  bool absent;
  bool present;
  bool isAdded;

  Student(
      {this.id,
      this.name,
      this.studentCode,
      this.studentRollNo,
      this.fatherName,
      this.email,
      this.password,
      this.phone,
      this.dob,
      this.gender,
      this.is_present,
      this.absent,
      this.present,
      this.isAdded});

  set setName(String name) => this.name = name;

  get getName => name;
}
