class AssessmentDb {
  String fileName;
  String batchId;
  int priority;
  int syncstatus;
  String type;
  String studentCode;

  AssessmentDb(
      {this.fileName,
      this.batchId,
      this.priority,
      this.syncstatus,
      this.type,
      this.studentCode});

  set setfilename(String filename) => this.fileName = filename;
  set setbatchid(String batchid) => this.batchId = batchid;
  set setpriority(int priority) => this.priority = priority;
  set setsyncstatus(int syncstatus) => this.syncstatus = syncstatus;
  set settype(String type) => this.type = type;
  set setstudentcode(String code) => this.studentCode = code;

  String get getFilename => fileName;
  String get getBatchId => batchId;
  int get getPriority => priority;
  int get getSyncStatus => syncstatus;
  String get getType => type;
  String get getStudentCode => studentCode;

  AssessmentDb.fromMap(Map<String, dynamic> map) {
    this.fileName = map['fileName'];
    this.batchId = map['batchId'];
    this.priority = map['priority'];
    this.syncstatus = map['syncstatus'];
    this.type = map['type'];
    this.studentCode = map['studentCode'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['fileName'] = fileName;
    map['batchId'] = batchId;
    map['priority'] = priority;
    map['syncstatus'] = syncstatus;
    map['type'] = type;
    map['studentCode'] = studentCode;
    return map;
  }
}
