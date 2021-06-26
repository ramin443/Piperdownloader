import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
import 'package:piperdownloader/getxcontrollers/bottomnavigationcontroller.dart';
import 'package:piperdownloader/screens/pages/downloads.dart';
import 'package:piperdownloader/screens/pages/home.dart';
import 'package:piperdownloader/screens/pages/settings.dart';
class Base extends StatelessWidget {
  final BottomNavigationController bottomNavigationController=Get.put(BottomNavigationController());

  List pages=[Home(),Downloads(),Settings()];
  @override
  Widget build(BuildContext context) {
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
          leading:
          Container(
            margin: EdgeInsets.only(left: 8,top: 8),
      child:
          SvgPicture.asset("assets/images/ytdownlogo.svg",
          height: 42,width: 42,)),
          title: Container(
             child: Text("Youtube\nVideo Downloader",style: TextStyle(
               fontFamily: proximanovaregular,
               color: blackthemedcolor,
               fontSize: 18
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
    size: 24,
   ),
    title: Text("Home",
    style: TextStyle(
fontFamily: proximanovaregular,

      fontSize: 12.5
    ),)
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.download_circle,
      size: 24,
     ),
        title: Text("Downloads",
          style: TextStyle(
              fontFamily: proximanovaregular,
              fontSize: 12.5
          ),)
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings,
      size: 24,
     ),
        title: Text("Settings",
          style: TextStyle(
              fontFamily: proximanovaregular,
              fontSize: 12.5
          ),)
    ),
  ],
),
        body: pages[bottomNavigationController.currentindex],
    );});
  }
}
