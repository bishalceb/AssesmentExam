import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:flutter/material.dart' as prefix0;
import 'package:assesment/model/FeedbackFormjson.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'login_page.dart';


class FeedbackForm extends StatefulWidget {
  final Directory batchFolder;
  const FeedbackForm({Key key, this.batchFolder}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState(this.batchFolder);
}

class _FeedbackFormState extends State<FeedbackForm> {
  List<FeedbackformJson> feedback_form_json;
  List final_json=new List();
  String first_name="";
  String last_name="";
  String phone="";
  String feedback="";
  String latitude="";
  String longitude="";
  String deviceid="";
  String intimestamp="";
  String outtimestamp="";
  final Directory batchFolder;
  final _formKey = GlobalKey<FormState>();
  FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://assessment-exam.appspot.com');
  _FeedbackFormState(this.batchFolder);

  @override
  void initState() {
    // TODO: implement initState
    feedback_form_json=new List();
    feedback_form_json.add(FeedbackformJson());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: new AppBar(title: Text("FeedBack")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                heightFactor: 3,
                child: Text("Resource's Feedback",style: TextStyle(fontSize: 30,color: Colors.black26)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Column(children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "First Name",
                        labelText: "First Name"
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Please enter some text';
                      }else{
                       first_name=value;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Last Name",
                        labelText: "Last Name"
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Please enter some text';
                      }
                      else{
                        last_name=value;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        labelText: "Phone Number"
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Please enter some text';
                      }
                      else if(!isNumeric(value))
                      {
                        return 'Please enter a valid Phone number';
                      }
                      else{
                        phone=value;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Feedback",
                        labelText: "Feedback"
                    ),
                    maxLines: 4,

                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Please enter some text';
                      }
                      else{
                        feedback=value;
                      }
                    },
                  ),
                  Padding(padding: EdgeInsets.all(2.0),
                    child: Center(
                        child:Container(
                          margin: EdgeInsets.only(top: 70.0),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: MaterialButton(
                              color: Color(0xFF2f4050),
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 40.0),
                                child: Text(
                                  "End Assesment",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                            onPressed: () async {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, we want to show a Snackbar
                               /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    LoginPage()), (Route<dynamic> route) => false);*/
                                /*FeedbackformJson(first_name:first_name,
                                                  last_name: last_name,
                                                   phone: phone,
                                                    feedback: feedback,
                                                    latitude: "",
                                                    longitude: "",
                                                    deviceid: "",
                                                    intimestamp: "",
                                                     outtimestamp: ""
                                                    );*/
                                int selectbatch=UserDetailApi.response[0].selected_batch;
                               String _OutcurrentTime = DateFormat.jms().format(DateTime.now()).toString();
                                feedback_form_json[0].first_name=first_name;
                                feedback_form_json[0].last_name=last_name;
                                feedback_form_json[0].phone=phone;
                                feedback_form_json[0].feedback=feedback;
                                feedback_form_json[0].latitude=UserDetailApi.response[0].batchData[selectbatch].lat.toString();
                                feedback_form_json[0].longitude=UserDetailApi.response[0].batchData[selectbatch].long.toString();
                                feedback_form_json[0].deviceid=UserDetailApi.response[0].deviceId;
                                feedback_form_json[0].intimestamp=UserDetailApi.response[0].batchData[selectbatch].current_timestamp;
                                feedback_form_json[0].outtimestamp=_OutcurrentTime;
                                print("feedback json=="+feedback_form_json.toString());
                                String finaljson = jsonEncode(feedback_form_json);
                                print("final encode json---" + finaljson);
                                final file = File('${widget.batchFolder.path}/proctor.txt');
                                await file.writeAsString(finaljson);
                                var outputAsUint8List = new Uint8List.fromList(finaljson.codeUnits);
                                  Navigator.pop(context);
                                Scaffold
                                    .of(context)
                                    .showSnackBar(
                                    SnackBar(content: Text('Processing Data'),
                                    )
                                ).closed.then((SnackBarClosedReason reason) {
                                  _opennewpage(context);
                                });
                              }
                            },
                          ),
                        )
                    ),
                  )
                ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
void _opennewpage(BuildContext context) {
  Navigator.of(context).push(
    new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Success'),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 19.0),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 19.0),
                      child:  FlutterLogo( size: 70.0,),
                    ),
                    Text('You have Successfully Signed with Flutter',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(fontWeight: FontWeight.w300),
                    ),

                  ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

bool isNumeric(String s) {
  try
  {
    return double.parse(s) != null;
  }
  catch (e)
  {
    return false;
  }
}
