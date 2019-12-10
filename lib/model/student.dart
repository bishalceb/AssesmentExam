class Student {
  String name;
  int rollno;
  bool isAdded;
  Student({this.name, this.rollno, this.isAdded});

  set setName(String name) => this.name = name;

  set setRollno(int roll) => this.rollno = roll;
  set setIsAdded(bool add) => this.isAdded = add;

  get getName => name;

  get getRollno => rollno;
  get getIsAdded => isAdded;
}
