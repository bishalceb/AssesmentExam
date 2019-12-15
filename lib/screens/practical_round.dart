import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart';

class Practical extends StatefulWidget {
  @override
  _PracticalState createState() => _PracticalState();
}

class _PracticalState extends State<Practical> {
  List<StudentData> students = List<StudentData>();

  @override
  void initState() {
    int selected_batch = UserDetailApi.response[0].selected_batch;
    List<StudentData> student_data =
        UserDetailApi.response[0].batcheData[selected_batch].studentData;
    student_data.forEach((student) {
      if (student.is_present) {
        students.add(student);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Practical Round'),
      ),
      body: ListView.builder(
        padding:
            EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
        itemCount: students.length,
        itemBuilder: (context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      students[index].name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Roll No. ' + students[index].studentRollNo.toString(),
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text('Practical'),
                onPressed: () {},
              ),
              SizedBox(
                width: 5.0,
              ),
              FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text('Viva'),
                onPressed: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
