import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/screens/SelectBatch.dart';
import 'package:assesment/screens/login_page.dart';
import 'package:assesment/screens/single_pic.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:assesment/screens/SplashScreen.dart';
import 'package:scoped_model/scoped_model.dart';

void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish();
}

void main() {
  runApp(new MyApp());
  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

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
        theme: ThemeData(primaryColor: Color(0xFF2f4050)),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
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
