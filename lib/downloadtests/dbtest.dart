import 'package:facebook_video_download/data/facebookData.dart';
import 'package:facebook_video_download/data/facebookPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class FBTest extends StatefulWidget {
  const FBTest({Key? key}) : super(key: key);

  @override
  _FBTestState createState() => _FBTestState();
}

class _FBTestState extends State<FBTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(onPressed: (){
          fbtest();
        }, icon: Icon(
          CupertinoIcons.add_circled_solid,
          color: Colors.black,
            size: 24,
        ))],
      ),
    );
  }
  Future<void> fbtest() async {
    FacebookPost data = await FacebookData.postFromUrl(
        "https://www.facebook.com/115258256516046/videos/502190211195678/");
    print(data.postUrl);
    print(data.videoHdUrl);
    print(data.videoMp3Url);
    print(data.videoSdUrl);
    print(data.commentsCount);
    print(data.sharesCount);
  }
}
