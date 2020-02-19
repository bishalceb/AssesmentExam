import 'dart:async';
import 'dart:convert';
import 'package:assesment/api/ApiUtils.dart';
import 'package:assesment/utils/Constants.dart';

Future<UserDetailApi> userDetailApi(
    Map<String, String> params, Map<String, String> body) async {
  print("body" + body.toString());
  print("params" + params.toString());
  try {
    return UserDetailApi.fromJson(await request_POST_header(
        parameters: params, body: body, url: BASE_URL));
  } catch (e) {
    print(e);
  }
  return null;
}

class UserDetailApi {
  static int responseCode;
  static bool responseStatus;
  static String responseMessage;
  static List<Response> response;

  UserDetailApi({responseCode, responseStatus, responseMessage, response});

  UserDetailApi.fromJson(String json1) {
    Map<String, dynamic> json = (jsonDecode(json1) as Map);
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
    data['ResponseCode'] = responseCode;
    data['ResponseStatus'] = responseStatus;
    data['ResponseMessage'] = responseMessage;
    if (response != null) {
      data['Response'] = response.map((v) => v.toJson()).toList();
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
  int selected_batch;
  int selected_round_no;
  List<BatchData> batchData;

  Response(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.userProfilePic,
      this.deviceId,
      this.selected_batch,
      this.batchData,
      this.selected_round_no});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    userProfilePic = json['user_profile_pic'];
    deviceId = json['device_id'];
    selected_batch = 0;
    selected_round_no=1;
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
    data['selected_batch'] = this.selected_batch;
    data['selected_round_no'] = this.selected_round_no;
    if (this.batchData != null) {
      data['batch_data'] = this.batchData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BatchData {
  String id;
  String batchNo;
  String current_timestamp;
  String out_current_timestamp;
  var lat;
  var long;
  List<StudentData> studentData;

  BatchData({this.id, this.batchNo, this.studentData,this.current_timestamp});

  BatchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batchNo = json['batch_no'];
    current_timestamp=json['current_timestamp'];
    long=json['long'];
    lat=json['lat'];
    out_current_timestamp=json['out_current_timestamp'];
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
    data['current_timestamp'] = this.current_timestamp;
    data['batch_no'] = this.batchNo;
    data['out_current_timestamp'] = this.out_current_timestamp;
    data['long'] = this.long;
    data['lat'] = this.lat;
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
  bool is_present;
  bool absent;
  bool present;
  bool is_take_viva;
  bool is_take_candidate_pic;
  bool isAdded;
  bool isRemoved;
  int addedInRound;
  bool practical_isAdded;
  bool practical_isRemoved;
  int practical_addedInRound;


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
      this.gender,
      this.is_present,
      this.is_take_viva,
      this.is_take_candidate_pic,
      this.absent,
      this.present,
      this.isAdded,
      this.isRemoved,
      this.addedInRound,
      this.practical_isAdded,
      this.practical_isRemoved,
      this.practical_addedInRound});

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
    is_present = false;
    absent = true;
    present = false;
    is_take_viva=false;
    is_take_candidate_pic=false;
    isAdded = false;
    isRemoved=true;
    addedInRound=0;
    practical_isAdded = false;
    practical_isRemoved=true;
    practical_addedInRound=0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? "";
    data['name'] = this.name ?? "";
    data['student_code'] = this.studentCode ?? "";
    data['student_roll_no'] = this.studentRollNo ?? "";
    data['father_name'] = this.fatherName ?? "";
    data['email'] = this.email ?? "";
    data['password'] = this.password ?? "";
    data['phone'] = this.phone ?? "";
    data['dob'] = this.dob ?? "";
    data['gender'] = this.gender ?? "";
    data['is_present'] = this.is_present;
    data['absent'] = this.is_present;
    data['present'] = this.is_present;
    data['is_take_viva'] = this.is_take_viva;
    data['is_take_candidate_pic'] = this.is_take_candidate_pic;
    data['isAdded'] = this.isAdded;
    data['isRemoved'] = this.isRemoved;
    data['addedInRound'] = this.addedInRound;
    data['practical_isAdded'] = this.practical_isAdded;
    data['practical_isRemoved'] = this.practical_isRemoved;
    data['practical_addedInRound'] = this.practical_addedInRound;
    return data;
  }
}
