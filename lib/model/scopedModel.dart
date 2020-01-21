import 'dart:async';

import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:scoped_model/scoped_model.dart';

class MainScopedModel extends Model {
  List<StudentData> _firstRoundStudents = [];
  List<StudentData> _secRoundStudents = [];
  List<StudentData> _thirdRoundStudents = [];
  bool _isLoading = false;

  bool get getLoading {
    return _isLoading;
  }

  void setisLoading(bool isLoading) {
    this._isLoading = isLoading;
    notifyListeners();
  }

  void addFirstRoundStudent() {
    List<StudentData> students = [];

    int _selectedBatch = UserDetailApi.response[0].selected_batch;
    List<StudentData> _studentData =
        UserDetailApi.response[0].batcheData[_selectedBatch].studentData;
    _studentData.forEach((student) {
      if (student.is_present) {
        students.add(student);
      }
    });
    _firstRoundStudents.addAll(students);
  }

  List<StudentData> get firstRoundStudents {
    print('first round student length: ${_firstRoundStudents.length}');
    return List.from(_firstRoundStudents);
  }

  void addStudentsToSecRound(StudentData s) {
    print('selected student: ${s.name} isAdded: ${s.isAdded}');
    int index = _firstRoundStudents.indexOf(s);
    print('selected student index: $index');
    _firstRoundStudents[index].isAdded
        ? _secRoundStudents.removeWhere((student) =>
            student.studentRollNo == _firstRoundStudents[index].studentRollNo)
        : _secRoundStudents.add(s);
    _firstRoundStudents[index] = StudentData(
        name: s.name,
        studentRollNo: s.studentRollNo,
        isAdded: !s.isAdded,
        absent: s.absent,
        dob: s.dob,
        email: s.email,
        fatherName: s.fatherName,
        gender: s.gender,
        id: s.id,
        is_present: s.is_present,
        password: s.password,
        phone: s.phone,
        present: s.present,
        studentCode: s.studentCode);

    notifyListeners();
  }

  List<StudentData> get secRoundStudents {
/*     _firstRoundStudents.forEach((student) {
      if (student.is_present && student.isAdded) {
        _secRoundStudents.add(student);
      }
    }); */
    return List.from(_secRoundStudents);
  }

  void addStudentsToThirdRound(StudentData s) {
    int index = _secRoundStudents.indexOf(s);
    _secRoundStudents[index].isAdded
        ? _thirdRoundStudents.removeWhere((student) =>
            student.studentRollNo == _secRoundStudents[index].studentRollNo)
        : _thirdRoundStudents.add(s);
    s.isAdded = !s.isAdded;
    _secRoundStudents[index] = StudentData(
        name: s.name,
        studentRollNo: s.studentRollNo,
        isAdded: s.isAdded,
        absent: s.absent,
        dob: s.dob,
        email: s.email,
        fatherName: s.fatherName,
        gender: s.gender,
        id: s.id,
        is_present: s.is_present,
        password: s.password,
        phone: s.phone,
        present: s.present,
        studentCode: s.studentCode);

    //_selectedStudent = null;
    notifyListeners();
  }

  List<StudentData> get thirdRoundStudents {
    return List.from(_thirdRoundStudents);
  }

  Future<List<AssessmentDb>> fetchData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return await databaseHelper.fetchData();
  }

  int eaCounter = 0;
  int afCounter;
  int cfCounter;
  int taCounter;
  int vtpCounter;
  int cocCounter;
  int pdCounter;
  int gpCounter;
  updateEACounter() {
    eaCounter++;
  }

  int get getEACounter {
    return eaCounter;
  }

  bool _isPresent = false;

  bool get isPresent {
    return _isPresent;
  }

  void setIsPresent(bool isPresent) {
    _isPresent = isPresent;
    notifyListeners();
  }
}
