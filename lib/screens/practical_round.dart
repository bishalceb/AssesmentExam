import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

class Practical extends StatefulWidget {
  @override
  _PracticalState createState() => _PracticalState();
}

class _PracticalState extends State<Practical> {
  List<StudentData> students = [];
  List<StudentData> student_data;

  @override
  void initState() {
    int selected_batch = UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batcheData[selected_batch].studentData;
    student_data.forEach((student) {
      if (student.is_present) {
        students.add(student);
      }
    });
    print('practical round init state called');

    super.initState();
  }

  Widget _buildNextButton() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
          child: Container(
        margin: EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: new LinearGradient(
              colors: [
                Theme.Colors.loginGradientEnd,
                Theme.Colors.loginGradientStart
              ],
              begin: const FractionalOffset(0.2, 0.2),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Theme.Colors.loginGradientEnd,
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              child: Text(
                "NEXT",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontFamily: "WorkSansBold"),
              ),
            ),
            onPressed: () {
              for (int i = 0; i < student_data.length; i++) {
                print("ispresent value==" +
                    student_data[i].is_present.toString());
              }
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessAllSectionRound()));
            }),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practical Round'),
      ),
      body: Column(
        children: <Widget>[
          students.length <= 0
              ? Center(
                  child: Text('No any present student'),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                    itemCount: students.length,
                    itemBuilder: (context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      students[index].name,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Roll No. ' +
                                          students[index].studentRollNo,
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
          _buildNextButton()
        ],
      ),
    );
  }
}
