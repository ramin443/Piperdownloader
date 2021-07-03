import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
class CurrentDownloadInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth*0.05720,bottom: screenWidth*0.0709),
      padding: EdgeInsets.all(
//    15
screenWidth*0.03649
),
      width: screenWidth*0.915,
      decoration: BoxDecoration(
        color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: Color(0xff707070).withOpacity(0.2),width: 1)
    ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
            //    height: 67,width: 67,
             height: screenWidth*0.1630,width: screenWidth*0.1630,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  color: royalbluethemedcolor
                ),
              ),
              Expanded(
                child:
              Container(
                margin: EdgeInsets.only(
          //          left: 14
            left: screenWidth*0.034063
                ),
             //   height: 67,
              height: screenWidth*0.1630,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("And to those tops and more."
                        "And to those tops and more"
                        "And to those tops and more",
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: proximanovaregular,
                          color: blackthemedcolor,
                          //    fontSize: 14.5
                          fontSize: screenWidth*0.03527
                      ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("5.2M views.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: proximanovaregular,
                              color: greythemedcolor,
                              //    fontSize: 12.5
                             fontSize: screenWidth*0.03041
                          ),),
                      ),
                      Container(
                        child: Text("01:45",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: proximanovaregular,
                              color: greythemedcolor,
                              //    fontSize: 12.5
                              fontSize: screenWidth*0.03041
                          ),),
                      ),
                    ],
                  )
                ],
              ),
              )),
            ],),
          ),

          //channelinfo
Container(
  margin: EdgeInsets.only(
//     top:12
  top: screenWidth*0.0391
  ),

  child: Row(mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Container(
  //    height: 45,width: 45,
      height: screenWidth*0.1094,width: screenWidth*0.1094,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: greythemedcolor,
      ),
    ),
    Expanded(
      child: Container(
        margin: EdgeInsets.only(
     //       left: 12
       left:  screenWidth*0.0291 ),
    //    height: 45,
      height: screenWidth*0.1094,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text("_blackeyedpeas",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovabold,
                    color: blackthemedcolor,
                    //    fontSize: 14.5
                    fontSize: screenWidth*0.0352
                ),),
            ),
            Container(
              child: Text("Black Eyed Peas",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: blackthemedcolor,
                    //    fontSize: 14.5
                    fontSize: screenWidth*0.0352
                ),),
            ),
          ],
        ),
      ),
    )
  ],
  ),
),
          //quality options
        Container(
          margin:EdgeInsets.only(top: 20) ,
    child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              qualitybox(context,'360p')
,              qualitybox(context,'720p')
            ],
          ))
        ],
      ),
    );
  }
  Widget qualitybox(BuildContext context, String quality){
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return  Container(

      //      height: 30,
      height: screenWidth*0.0729,
      width: screenWidth*0.3849,
      decoration: BoxDecoration(
          color: royalbluethemedcolor,
          borderRadius: BorderRadius.all(Radius.circular(7)),
          boxShadow: [BoxShadow(color: Color(0xff0062FF).withOpacity(0.28),blurRadius: 10,offset: Offset(0,3)),]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(FeatherIcons.download,
            //      size: 20,
            size: screenWidth*0.0466,
            color: Colors.white,),
          Container(
            child: Text(quality,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: Colors.white,
                  //    fontSize: 14.5
                  fontSize: screenWidth*0.0352
              ),),
          ),
          Container(
            child: Text("Download",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: Colors.white,
                  //    fontSize: 14.5
                  fontSize: screenWidth*0.0352
              ),),
          ),
        ],
      ),
    );
  }
}
