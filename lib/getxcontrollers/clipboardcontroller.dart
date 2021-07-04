import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:get/get.dart';
import 'package:piperdownloader/getxcontrollers/downloadcontroller.dart';

class ClipboardController extends GetxController {
  int showdownload = 0;
  String clipboarddata = '';
  TextEditingController linkfieldcontroller = TextEditingController();
  final DownloadController downloadController = Get.put(DownloadController());
  String? extractedlink = '';

  checkyoutubestatus() {
    if (linkfieldcontroller.text.contains("youtube")) {
      showdownload = 1;
      downloadController.sethasvalidlink();
      update();
    }
    if (!linkfieldcontroller.text.contains("youtube")) {
      showdownload = 0;
      downloadController.setnovalidlink();
      update();
    }
  }

  addclipboardtextlistener() async {
    linkfieldcontroller.addListener(() async {
      if (linkfieldcontroller.text.contains("youtube")) {
        showdownload = 1;
        downloadController.sethasvalidlink();
        extractYoutubeLink(linkfieldcontroller.text);
        update();
      }

      if (1 > 0) {
        setclipboarddata();
      }
      if (linkfieldcontroller.text == "") {
        downloadController.setnovalidlink();
        update();
      }

      if (linkfieldcontroller.text != "") {}
    });
  }
  emptyeverything(){
    extractedlink="";
    showdownload=0;
    clipboarddata='';
    linkfieldcontroller.clear();
    update();
  }
  Future<void> extractYoutubeLink(String youtubelink) async {
    String? link;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print("tried");
      link =
          await (FlutterYoutubeDownloader.extractYoutubeLink(youtubelink, 18));
      extractedlink = link;
      print(extractedlink);
      showdownload=2;
      update();

    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
    }
    update();
  }

  setclipboarddata() {
    FlutterClipboard.paste().then((value) {
      // Do what ever you want with the value.
      clipboarddata = value;
      update();
    });
  }

  pastetoclipboard() {
    FlutterClipboard.paste().then((value) {
      // Do what ever you want with the value.
      linkfieldcontroller.text = value;
      clipboarddata = value;
      if (value.contains("youtube")) {
        showdownload = 1;
      }
      update();
    });
  }

  emptytextfield(BuildContext context) {
    linkfieldcontroller.clear();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    showdownload = 0;
    update();
  }
}
