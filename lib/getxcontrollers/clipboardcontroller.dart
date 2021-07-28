import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:get/get.dart' as GetX;
import 'package:piperdownloader/getxcontrollers/downloadcontroller.dart';
import 'package:piperdownloader/getxcontrollers/youtubevideoinfocontroller.dart';
import 'package:piperdownloader/models/channelmodels.dart';
import 'package:piperdownloader/models/video_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../config.dart';

class ClipboardController extends GetX.GetxController {
  int showdownload = 0;
  String clipboarddata = '';
  TextEditingController linkfieldcontroller = TextEditingController();
  final DownloadController downloadController = GetX.Get.put(DownloadController());
   YoutubeVideoInfoController youtubeVideoInfoController = GetX.Get.put(YoutubeVideoInfoController());
  String? extractedlink = '';
  String? currentvideotitle='';
  String? currentvideothumbnaillink='';
  String? currentyoutubechannelthumbnaillink='';
  String? currentytchanneltitle='';
  String? currentytchanneldescription='';
  static const VIDEO_ID = 'PZmSTYU-3rA';
  static const _baseUrl = 'www.googleapis.com';

  updatevideoinfo(String? title,String? thumbnailink){
    currentvideotitle=title;
    currentvideothumbnaillink=thumbnailink;
    update();
  }
  updatechannelinfo(
      {String? title, String? description, String? thumbnailink}){
    currentytchanneltitle=title;
    currentyoutubechannelthumbnaillink=thumbnailink;
    currentytchanneldescription=description;
    update();
  }
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
  emptyeverything(BuildContext context){
    extractedlink="";
    showdownload=0;
    clipboarddata='';
    linkfieldcontroller.clear();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    update();
  }
  Future<void> extractYoutubeLink(String youtubelink) async {
    String? link;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
  //    print("tried");
      link =
          await (FlutterYoutubeDownloader.extractYoutubeLink(youtubelink, 18));
      getvideoinfo("twcVTnMa1ec");
      extractedlink = link;
      print(extractedlink);
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
      if (value.contains("you")) {
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
  Future<int> getvideoinfo(String videoid) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'id': VIDEO_ID,
      'key': Constants.API_KEY,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/videos',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
  //  print(response.body);
    Videos videos=Videos.fromJson(jsonDecode(response.body));
       updatevideoinfo(videos.videos![0].video!.title,
         videos.videos![0].video!.thumbnails!.maxres!.url);
    getChannelInfo(videos.videos![0].video!.channelId);
    update();
 //   print(videos.kind);
   // print(videos.videos![0].video!.thumbnails!.maxres!.url);
    //   getChannelInfo(videos.videos![0].video!.channelId);

    // return channelInfo;
    return 0;
  }
   Future<ChannelInfo> getChannelInfo(String? channelid) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'id': channelid!,
      'key': Constants.API_KEY,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    // print(response.body);
    ChannelInfo channelInfo = ChannelInfo.fromJson(jsonDecode(response.body));
    updatechannelinfo(thumbnailink: channelInfo.items![0].snippet!.thumbnails!.high!.url,
    title:   channelInfo.items![0].snippet!.title,
    description: channelInfo.items![0].snippet!.description );
    showdownload=2;
    update();
  //  print("Channel thumbnal");
    //print(channelInfo.items![0].snippet!.thumbnails!.high!.url);
    return channelInfo;
  }

}
