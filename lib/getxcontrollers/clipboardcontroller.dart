import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ClipboardController extends GetxController {
  bool showdownload = false;
  String clipboarddata = '';
  TextEditingController linkfieldcontroller = TextEditingController();

  checkyoutubestatus(){
    if(linkfieldcontroller.text.contains("youtube")){
      showdownload = true;
      update();
    }
    if(!linkfieldcontroller.text.contains("youtube")){
      showdownload = false;
      update();
    }
  }
  addclipboardtextlistener() async {
    if (linkfieldcontroller.text.contains("youtube")) {
      showdownload = true;
      update();
    }
    linkfieldcontroller.addListener(() async {
      if (1 > 0) {
        setclipboarddata();
      }
      if (linkfieldcontroller.text != "") {}
    });
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
        showdownload = true;
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
    showdownload = false;
    update();
  }
}
