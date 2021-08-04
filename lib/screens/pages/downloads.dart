import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piperdownloader/getxcontrollers/clipboardcontroller.dart';
import 'package:piperdownloader/getxcontrollers/downloadcontroller.dart';
class Downloads extends StatelessWidget {
  final DownloadController downloadController=Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return
      SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: GetBuilder<ClipboardController>(

          init: ClipboardController(),
    builder: (clipboardcontroller){
            return GetBuilder(
                initState: (v){
                  clipboardcontroller.updateListView();
                },  init: DownloadController(),
            builder: (downloadc)=>
        Container(
        width:screenwidth ,
        padding: EdgeInsets.only(
            bottom: screenwidth * 0.05720
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            clipboardcontroller.topdownloadrow(context),
            clipboardcontroller.tasklist.length==0?
            downloadController.emptydownloads(context):
            clipboardcontroller.downloadedvideolist(context),

          ],
        ),
    ));}),
      );
  }
}
