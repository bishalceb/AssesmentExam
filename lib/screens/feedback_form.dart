import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:flutter/material.dart' as prefix0;

import 'login_page.dart';


class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
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
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, we want to show a Snackbar
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    LoginPage()), (Route<dynamic> route) => false);
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
