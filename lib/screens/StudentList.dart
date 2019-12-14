import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart' as prefix0;

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  double height;
  double actual_height;
  BuildContext _scaffoldContext;
  List<StudentData> student_data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int selected_batch=UserDetailApi.response[0].selected_batch;
    student_data=UserDetailApi.response[0].batcheData[selected_batch].studentData;
  }
  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
              "Student List"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: getStdListBody(context)),
            Container(
              padding: EdgeInsets.all(10),
              child: Center(
                  child:Container(
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "NEXT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: "WorkSansBold"),
                          ),
                        ),
                        onPressed: (){
                          for(int i=0;i<student_data.length;i++){
                            print("ispresent value=="+student_data[i].is_present.toString());
                          }
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessAllSectionRound()));
                        }
                    ),
                  )
              ),
            ),

          ],
        )
    );
  }

  getStdListBody(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double percentage_height=0.33*height;
    actual_height=height-percentage_height;
    return Container(
      height: actual_height,
      child:  ListView.builder(
        itemCount: 10,
        itemBuilder: _studentPageDesign,
        padding: EdgeInsets.all(0.0),
      ),
    );
  }

  Widget _studentPageDesign(BuildContext context, int index) {
    return Card(
        shape:RoundedRectangleBorder(

        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 150,
            child: Text(student_data[index].name,style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          Padding(padding: EdgeInsets.all(2),
            child:  ToggleButtons(
              borderColor: Colors.black26,
              fillColor: Colors.pink,
              borderWidth: 2,
              selectedBorderColor: Colors.black26,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Absent',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Present',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              onPressed: (int toggle_index) {
                setState(() {
                  for (int i = 0; i < 2; i++) {
                    if (i == toggle_index) {
                      student_data[index].absent=false;
                      student_data[index].present=true;
                      student_data[index].is_present=true;
                    } else {
                      student_data[index].absent=true;
                      student_data[index].present=false;
                      student_data[index].is_present=false;
                    }
                  }
                });
              },
              isSelected: [student_data[index].absent,student_data[index].present],
            ),
          )
        ],
      ),
    );
  }
}
