import 'package:assesment/model/student.dart';
import 'package:scoped_model/scoped_model.dart';

class MainScopedModel extends Model {
  List<Student> _firstRoundStudents = [];
  Student _selectedStudent;
  List<Student> _secRoundStudents = [];
  List<Student> _thirdRoundStudents = [];
  //bool _isAdded = false;

  void addStudent() {
    _firstRoundStudents = [
      Student(name: 'Student 1', rollno: 1, isAdded: false),
      Student(name: 'Student 2', rollno: 2, isAdded: false),
      Student(name: 'Student 3', rollno: 3, isAdded: false),
      Student(name: 'Student 4', rollno: 4, isAdded: false),
      Student(name: 'Student 5', rollno: 5, isAdded: false),
      Student(name: 'Student 6', rollno: 6, isAdded: false),
      Student(name: 'Student 7', rollno: 7, isAdded: false),
      Student(name: 'Student 8', rollno: 8, isAdded: false)
    ];
  }

  List<Student> get firstRoundStudent {
    return List.from(_firstRoundStudents);
  }

  selectStudent(Student s) {
    _selectedStudent = s;
  }

  Student get selectedStudent {
    return _selectedStudent;
  }

  void addStudentsToSecRound(Student s) {
    print('selected student: ${s.name} isAdded: ${s.isAdded}');

    _firstRoundStudents[_firstRoundStudents.indexOf(s)].isAdded
        ? _secRoundStudents.remove(s)
        : _secRoundStudents.add(s);

    s.isAdded = !s.isAdded;
    int index = _firstRoundStudents.indexOf(s);
    _firstRoundStudents[index] =
        Student(name: s.name, rollno: s.rollno, isAdded: s.isAdded);

    /*   _firstRoundStudents[_firstRoundStudents.indexOf(s)].isAdded =
        !_firstRoundStudents[_firstRoundStudents.indexOf(s)].isAdded; */

    //_selectedStudent = null;
    notifyListeners();
  }

  List<Student> get secRoundStudents {
    return List.from(_secRoundStudents);
  }

  void addStudentsToThirdRound(Student s) {
    _secRoundStudents[_secRoundStudents.indexOf(s)].isAdded
        ? _thirdRoundStudents.remove(s)
        : _thirdRoundStudents.add(s);
    s.isAdded = !s.isAdded;
    int index = _secRoundStudents.indexOf(s);
    _secRoundStudents[index] =
        Student(name: s.name, rollno: s.rollno, isAdded: s.isAdded);

    //_selectedStudent = null;
    notifyListeners();
  }

  List<Student> get thirdRoundStudents {
    return List.from(_thirdRoundStudents);
  }
}
