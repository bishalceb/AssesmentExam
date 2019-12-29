import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:assesment/screens/SplashScreen.dart';
import 'package:scoped_model/scoped_model.dart';

void printMessage(String msg) => print('[${DateTime.now()}] $msg');

void printPeriodic() => printMessage("Periodic!");
void printOneShot() => printMessage("One shot!");

Future<void> main() async {
  final int periodicID = 0;
  final int oneShotID = 1;

  WidgetsFlutterBinding.ensureInitialized();

  // Start the AlarmManager service.
  await AndroidAlarmManager.initialize();

  printMessage("main run");
  runApp(MyApp());
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 5), periodicID, printPeriodic,
      wakeup: true, exact: true);
  await AndroidAlarmManager.oneShot(
      const Duration(seconds: 5), oneShotID, printOneShot);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      MainScopedModel model = MainScopedModel();
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


