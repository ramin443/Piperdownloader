import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
import 'package:piperdownloader/screens/downloadwidgets/CurrentDownloadInfo.dart';
import 'package:piperdownloader/screens/downloadwidgets/DownloadedVideoCard.dart';
import 'package:piperdownloader/screens/sharablewidgets/downloadinstruction1.dart';
import 'package:piperdownloader/screens/sharablewidgets/rateus.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
    child:
      Container(
        width: screenwidth,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
DownloadedVideoCard(),
          Container(
            margin: EdgeInsets.only(
      //          top: 29,bottom: 18
                top: screenwidth*0.07055,bottom: screenwidth*0.0437

            ),
            padding: EdgeInsets.only(
        //        left: 15
          left: screenwidth*0.0364963
            ),
        //    height: 41,
          height: screenwidth*0.09975,
            width: screenwidth*0.906,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(11)),
border: Border.all(color: Color(0xff707070).withOpacity(0.2),width: 1
), color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.13),blurRadius:  10,offset: Offset(0,3))]
            ),
            child: TextField(
              cursorColor: Colors.black.withOpacity(0.7),
              style: TextStyle(
                  color: Colors.black,
            //      fontSize: 15,
              fontSize: screenwidth*0.0364963,
                  fontFamily: proximanovaregular              ),
              decoration: InputDecoration(
               suffixIcon: GestureDetector(
                 child: Icon(CupertinoIcons.xmark,
                 color: Colors.black87,
                     size: 17,),
               ),
                border: InputBorder.none,
                hintText: "Paste Youtube video link here",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.43),
               //   fontSize: 15,
                    fontSize: screenwidth*0.0364963,
                    fontFamily: proximanovaregular
                )
              ),
            ),
          ),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
             //  width: 119,
               width: screenwidth*0.2895,
                 padding: EdgeInsets.symmetric(vertical: 9),
               decoration: BoxDecoration(
                 color: royalbluethemedcolor,
                 borderRadius: BorderRadius.all(Radius.circular(14)),
                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.13),offset: Offset(0,3),blurRadius: 10)]
               ),
               child: Center(child:Text("Paste Link",style: TextStyle(
               fontSize: 16,
                 color: Colors.white,
                 fontFamily: proximanovaregular
               )),
             )),
             Container(
         //      width: 111,
            width: 111,
               margin: EdgeInsets.only(left: 60),
                 padding: EdgeInsets.symmetric(vertical: 9),
                 decoration: BoxDecoration(
                   color: royalbluethemedcolor.withOpacity(0.41),
                   borderRadius: BorderRadius.all(Radius.circular(14)),
                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.13),offset: Offset(0,3),blurRadius: 10)]
                 ),
                 child:Center(child: Text("Download",style: TextStyle(
                     fontSize: 16,
                     color: Colors.white,
                     fontFamily: proximanovaregular
                 ),
                 ))),
           ],
         ),
          CurrentDownloadInfo(),

          Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children:[
            nolinkpasted(context),
          ]),
          DownloadInstructionOne(),
          RateUs()

        ],
      ),
    ));
  }
  Widget nolinkpasted(BuildContext context){
    double screenwidth=MediaQuery.of(context).size.width;
    return Container(
  //    margin: EdgeInsets.only(top: 25,bottom: 31),
     margin: EdgeInsets.only(top: screenwidth*0.05720,bottom: screenwidth*0.0709),
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
            child: Text("Copy link from a Youtube Video\n& start downloading",
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
