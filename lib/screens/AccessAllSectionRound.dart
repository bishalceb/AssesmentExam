import 'package:flutter/material.dart';
import 'package:assesment/screens/StudentList.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/theory_round.dart';
import 'package:assesment/screens/practical_round.dart';
import 'package:assesment/screens/documents.dart';
import 'package:assesment/model/scopedModel.dart';


class AccessAllSectionRound extends StatefulWidget {
  @override
  _AccessAllSectionRoundState createState() => _AccessAllSectionRoundState();
}

class _AccessAllSectionRoundState extends State<AccessAllSectionRound> {
  static final card_color=Colors.white;
  static final card_text_color=Colors.black;
  static final card_border_color=Colors.black26;
  final MainScopedModel model = MainScopedModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("selected batch=="+UserDetailApi.response[0].selected_batch.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            firstrow(context),
            secondrow(),
            thirdrow()
          ],
        ),
      ),
    );
  }
  Widget firstrow(context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 180,
              height: 200,
              child: new InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>StudentList()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: new BorderSide(color: card_border_color, width: 2.0),
                  ),
                  color: card_color,
                  elevation: 15,
                  child: Center(
                    child: Text('Student Round',textAlign: TextAlign.center, style: TextStyle(color: card_text_color,fontSize: 25.0)),
                  ),
                ),
              )
          ),

          Container(
              width: 180,
              height: 200,
              child: new InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Theory(model)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: new BorderSide(color: card_border_color, width: 2.0),
                  ),
                  color: card_color,
                  elevation: 15,
                  child: Center(
                    child: Text('Theory Round',textAlign: TextAlign.center, style: TextStyle(color: card_text_color,fontSize: 25.0)),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  Widget secondrow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 180,
              height: 200,
              child: new InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Practical()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: new BorderSide(color: card_border_color, width: 2.0),
                  ),
                  color: card_color,
                  elevation: 15,
                  child: Center(
                    child: Text('Practical Round',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: card_text_color, fontSize: 25.0)),
                  ),
                ),
              )
          ),

          Container(
              width: 180,
              height: 200,
              child: new InkWell(
                onTap: () {
                  print("click Student");
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: new BorderSide(color: card_border_color, width: 2.0),
                  ),
                  color: card_color,
                  elevation: 15,
                  child: Center(
                    child: Text(
                        'Center Infrastructure Round', textAlign: TextAlign.center,
                        style: TextStyle(
                            color: card_text_color, fontSize: 25.0)),
                  ),
                ),
              )
          )


        ],
      ),
    );
  }


    Widget thirdrow() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 180,
                height: 200,
                child: new InkWell(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Documents()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: new BorderSide(
                          color: card_border_color, width: 2.0),
                    ),
                    color: card_color,
                    elevation: 10,
                    child: Center(
                      child: Text(
                          'Documentation Round', textAlign: TextAlign.center,
                          style: TextStyle(
                              color: card_text_color, fontSize: 25.0)),
                    ),
                  ),
                )
            ),
            Container(
                width: 180,
                height: 200,
                child: new InkWell(
                  onTap: () {
                    print("click Student");
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: new BorderSide(
                          color: card_border_color, width: 2.0),
                    ),
                    color: card_color,
                    elevation: 10,
                    child: Center(
                      child: Text(
                          'End of Assesment', textAlign: TextAlign.center,
                          style: TextStyle(
                              color: card_text_color, fontSize: 25.0)),
                    ),
                  ),
                )
            )
          ],
        ),
      );
    }

    static Widget selectedCardfunction(){
    }
  }

