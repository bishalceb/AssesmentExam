class UserDetail {
  int responseCode;
  bool responseStatus;
  String responseMessage;
  List<Response> response;

  UserDetail(
      {this.responseCode,
        this.responseStatus,
        this.responseMessage,
        this.response});

  UserDetail.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseStatus = json['ResponseStatus'];
    responseMessage = json['ResponseMessage'];
    if (json['Response'] != null) {
      response = new List<Response>();
      json['Response'].forEach((v) {
        response.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResponseCode'] = this.responseCode;
    data['ResponseStatus'] = this.responseStatus;
    data['ResponseMessage'] = this.responseMessage;
    if (this.response != null) {
      data['Response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String id;
  String username;
  String firstName;
  String lastName;
  String email;
  String userProfilePic;
  String deviceId;
  List<BatchData> batchData;

  Response(
      {this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.email,
        this.userProfilePic,
        this.deviceId,
        this.batchData});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    userProfilePic = json['user_profile_pic'];
    deviceId = json['device_id'];
    if (json['batch_data'] != null) {
      batchData = new List<BatchData>();
      json['batch_data'].forEach((v) {
        batchData.add(new BatchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['user_profile_pic'] = this.userProfilePic;
    data['device_id'] = this.deviceId;
    if (this.batchData != null) {
      data['batch_data'] = this.batchData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BatchData {
  String id;
  String batchNo;
  List<StudentData> studentData;

  BatchData({this.id, this.batchNo, this.studentData});

  BatchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batchNo = json['batch_no'];
    if (json['student_data'] != null) {
      studentData = new List<StudentData>();
      json['student_data'].forEach((v) {
        studentData.add(new StudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['batch_no'] = this.batchNo;
    if (this.studentData != null) {
      data['student_data'] = this.studentData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentData {
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

  StudentData(
      {this.id,
        this.name,
        this.studentCode,
        this.studentRollNo,
        this.fatherName,
        this.email,
        this.password,
        this.phone,
        this.dob,
        this.gender});

  StudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    studentCode = json['student_code'];
    studentRollNo = json['student_roll_no'];
    fatherName = json['father_name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['student_code'] = this.studentCode;
    data['student_roll_no'] = this.studentRollNo;
    data['father_name'] = this.fatherName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    return data;
  }
}