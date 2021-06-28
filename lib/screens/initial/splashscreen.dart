import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
 late Animation<double> upanimation;
 late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    upanimation = Tween<double>(begin: 0.0, end:200).animate(animationController);
    animationController.forward();
    animationController.addListener(() {

    });
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Base');
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Stack(
        children:[
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffFC3434),Color(0xffFF6767)]
              )
            ),
          ),
          Scaffold(
      backgroundColor: Colors.transparent,
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              AnimatedContainer(duration: Duration(milliseconds: 1200),
    margin: EdgeInsets.only(bottom: upanimation.value),
    child:SvgPicture.asset("assets/images/downloadsplashlogo.svg",)),
                Container(
                  child: Text("Youtube Video Downloader",
                  style: TextStyle(
                    fontFamily:proximanovaregular,
                    color: Colors.white
,
                      fontSize: screenWidth*0.0583
                      //fontSize: 24),
                  ),
                )
                )],
            ),
          ),
    )]);
  }
}
