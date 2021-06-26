import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piperdownloader/getxcontrollers/downloadcontroller.dart';
class Downloads extends StatelessWidget {
  final DownloadController downloadController=Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return
      GetBuilder(
        init: DownloadController(),
          builder: (downloadc)=>
      Container(
      width:screenwidth ,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          downloadController.topdownloadrow(context),
          downloadController.emptydownloads(context)
        ],
      ),
    ));
  }
}
