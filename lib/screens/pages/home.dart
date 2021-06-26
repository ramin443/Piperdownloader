import 'package:flutter/material.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
    child:
      Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children:[nolinkpasted(context),])
        ],
      ),
    ));
  }
  Widget nolinkpasted(BuildContext context){
    double screenwidth=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 25,bottom: 31),
      width:  screenwidth*0.837,
      decoration: BoxDecoration(
color: Color(0xffFAFAFA).withOpacity(0.52),
        borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: Color(0xff707070).withOpacity(0.2),
        width: 1),

      ),
      padding: EdgeInsets.all(
//          14
  screenwidth*0.0340    ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            child: Text("Copy link from a Youtube Video\n& start downlading",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: proximanovaregular,
              color: blackthemedcolor,
          //    fontSize: 16
           fontSize: screenwidth*0.0366
            ),),
          ),

          Container(
            child: Image.asset("assets/images/Saly-1@3x.png",width: screenwidth*0.49427,),
          ),
          Container(
            child:

            Text("The link will be automatically detected after copying. If link"
           " is not detected, Press the paste link. If link still does not show"
           " up, please ensure that you have copied the link",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: Colors.black.withOpacity(0.58),
                  //    fontSize: 16
                  fontSize: screenwidth*0.0286
              ),),
          ),
        ],
      ),
    );
  }
}
