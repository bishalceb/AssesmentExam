import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:assesment/screens/AccessAllSectionRound.dart';
import 'package:assesment/api/UserDetailApi.dart';

class SelectBatch extends StatefulWidget {
  @override
  _SelectBatchState createState() => _SelectBatchState();
}

class _SelectBatchState extends State<SelectBatch> {

  UserDetailApi userDetailApi;
  List<BatcheData> batcheData=UserDetailApi.response[0].batcheData;
  String _value;
  int _selected_postion=0;
  List <String> spinnerItems = [] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0;i<batcheData.length;i++){
      spinnerItems.add(batcheData[i].batchNo.toString());
    }
    print("batch=="+spinnerItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Batch"),),
      body: batchdesign(),
    );
  }
  Widget batchdesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
    Padding(
    padding: EdgeInsets.all(15.0),
    child: DropdownButton<String>(
    isExpanded: true,
    items:spinnerItems.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value,textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.black),),
    );
    }).toList(),
    onChanged: (String value) {
      int position = 0;
      for ( int j =0 ; j< batcheData.length; j++){
        if(batcheData[j].batchNo == value){
          position = j;
          UserDetailApi.response[0].selected_batch=position;
        }
      }
    setState(() {
    _value = value;
    UserDetailApi.response[0].selected_batch=position;
    });
    },
    hint: Text('Select Batch'),
    value: _value,
    ),
    ),
        Padding(padding: EdgeInsets.all(2.0),
         child: Center(
             child:Container(
               margin: EdgeInsets.only(top: 140.0),
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
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessAllSectionRound()));
                   }
               ),
             )
         ),
        )
      ],
    );
  }
}

