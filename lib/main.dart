import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:assesment/screens/SplashScreen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return new MaterialApp(
      title: 'Assesment Exam',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );*/
    final MainScopedModel model = MainScopedModel();
    return ScopedModel(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF2f4050)
        ),
        debugShowCheckedModeBanner: false,
        home: new SplashScreen(),
        /* theme: ThemeData(clear
            primaryColor: Colors.blue[300],
            accentColor: Colors.blue[200]), */
        /*routes: {
          '/theory': (BuildContext context) => Theory(model),
          '/': (BuildContext context) => Documents(),
        },*/
      ),
    );
  }
}