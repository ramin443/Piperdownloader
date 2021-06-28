import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
import 'package:piperdownloader/getxcontrollers/bottomnavigationcontroller.dart';
import 'package:piperdownloader/screens/offline/nointernetpage.dart';
import 'package:piperdownloader/screens/pages/downloads.dart';
import 'package:piperdownloader/screens/pages/home.dart';
import 'package:piperdownloader/screens/pages/settings.dart';
import 'package:piperdownloader/screens/sharablewidgets/canceldownload.dart';
import 'package:piperdownloader/screens/sharablewidgets/deletevideo.dart';
class Base extends StatelessWidget {
  final BottomNavigationController bottomNavigationController=Get.put(BottomNavigationController());
  final Connectivity connectivity = Connectivity();

  List pages=[Home(),Downloads(),Settings()];
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return
  GetBuilder(
init: BottomNavigationController(),
    builder: (bottomnavigation){
  return
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          actions: [
            IconButton(onPressed: (){
              showDialog(context: context,

                  builder: (_)=>
                   SimpleDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),

                 children:[DeleteVideo()])
              );

            }, icon: Icon(CupertinoIcons.plus,color: Colors.black87,))
          ],
          leading:
          Container(
            margin: EdgeInsets.only(
//                left: 8,top: 8
                left: screenWidth*0.01946,top: screenWidth*0.01946,

            ),
      child:
          SvgPicture.asset("assets/images/ytdownlogo.svg",
       //   height: 42,width: 42,
         height: screenWidth*0.1021,width: screenWidth*0.1021,
          )),
          title: Container(
             child: Text("Youtube\nVideo Downloader",style: TextStyle(
               fontFamily: proximanovaregular,
               color: blackthemedcolor,
       //        fontSize: 18
         fontSize: screenWidth*0.04379
             ),),
          ),
        ),
      backgroundColor: Colors.white,
bottomNavigationBar: BottomNavigationBar(
  currentIndex: bottomNavigationController.currentindex,
  selectedItemColor: royalbluethemedcolor,
  unselectedItemColor: greythemedcolor,

  backgroundColor: Color(0xfff5f5f5),
  onTap: (index){
    bottomNavigationController.setindex(index);
  },
  items: [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home,
 //   size: 24,
   size: screenWidth*0.0583,
    ),
    title: Text("Home",
    style: TextStyle(
fontFamily: proximanovaregular,
        fontSize: screenWidth*0.03041
  //    fontSize: 12.5
    ),)
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.download_circle,
  //    size: 24,
      size: screenWidth*0.0583,
    ),
        title: Text("Downloads",
          style: TextStyle(
              fontFamily: proximanovaregular,
     //         fontSize: 12.5
              fontSize: screenWidth*0.03041
          ),)
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings,
   //   size: 24,
      size: screenWidth*0.0583,
    ),
        title: Text("Settings",
          style: TextStyle(
              fontFamily: proximanovaregular,
     //         fontSize: 12.5
       fontSize: screenWidth*0.03041
          ),)
    ),
  ],
),
        body:
    StreamBuilder(
    stream: connectivity.onConnectivityChanged,
    builder: (context, snaps){
    return
    snaps.data==ConnectivityResult.none?
    NoInternet():
        pages[bottomNavigationController.currentindex];}),
    );});
  }
}
