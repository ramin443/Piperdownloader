import 'package:flutter/material.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
class DownloadInstructionTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        //      horizontal: 22
          left: screenwidth*0.0535,
        right: screenwidth*0.0535,
         bottom: screenwidth*0.0243
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              //        bottom: 10
                bottom: screenwidth*0.02433
            ),
            child: Text("See how to download",style: TextStyle(
                fontFamily: proximanovabold,
                color: blackthemedcolor,
                //     fontSize: 17.5
                fontSize: screenwidth*0.04257
            ),),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Icon(Icons.arrow_forward,
          color: greythemedcolor,
       //     size: 18,
         size: screenwidth*0.0437,
          ),
          Container(
            margin: EdgeInsets.only(
              //        bottom: 10
                bottom: screenwidth*0.00433,
        //      left: 16
          left: screenwidth*0.0389
            ),
            child: Text("View the step by step tutorial to see how to\ndownload.",style: TextStyle(
                fontFamily: proximanovaregular,
                color: greythemedcolor,
                //     fontSize: 17.5
                fontSize: screenwidth*0.03527
            ),),
          )]),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getastep(context,1,"Open Youtube app in your device."),
                getastep(context,2,"Choose and open the video you want to\ndownload."),
                getastep(context,3,"Tap on the share button below the video and\nthen"
                  " press the copy link button."),
                getastep(context,4,"Open this app after the link is copied."),
                getastep(context,5,"The link will be detected automatically. If it does\n"
                  "not show, Paste the link using the Paste link\nbutton"),
              ],
            ),
          ),


        ],
      ),
    );  }
  Widget getastep(BuildContext context, int stepnumber, String steppoint){
    double screenwidth=MediaQuery.of(context).size.width;
    return   Container(
      child:
      Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[

      Container(
                margin: EdgeInsets.only(
//                    top:subpoint==""?8:0,bottom: subpoint==""? 8:0
                    top:screenwidth*0.0194,bottom: screenwidth*0.0194
                ),
                child:

                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Step $stepnumber:  ",

                          style: TextStyle(
                            fontFamily: proximanovabold
                        ),),
                        TextSpan(
                          text: steppoint,),

                      ],
                      style: TextStyle(
                          fontFamily: proximanovaregular,
                          color: Colors.black87,
                          //      fontSize: 14
                          fontSize: screenwidth*0.03527
                      )
                  ),

                )),

          ]),
    );
  }
}
