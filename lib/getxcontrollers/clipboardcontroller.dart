import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:get/get.dart' as GetX;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piperdownloader/constants/colorconstants.dart';
import 'package:piperdownloader/constants/fontconstants.dart';
import 'package:piperdownloader/dbhelpers/DownloadedVidDBHelper.dart';
import 'package:piperdownloader/downloadtests/downloadtester.dart';
import 'package:piperdownloader/getxcontrollers/downloadcontroller.dart';
import 'package:piperdownloader/getxcontrollers/youtubevideoinfocontroller.dart';
import 'package:piperdownloader/models/Downloaded_Video_Model.dart';
import 'package:piperdownloader/models/channelmodels.dart';
import 'package:piperdownloader/models/video_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:piperdownloader/screens/downloadwidgets/DownloadedVideoCard.dart';
import 'package:piperdownloader/screens/sharablewidgets/deletevideo.dart';
import 'package:sqflite/sqflite.dart';

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
  static const _baseUrl = 'www.googleapis.com';
  String? _localPath;
  bool? _permissionReady;
  bool? _isLoading;
  ReceivePort _port = ReceivePort();
  int? downloadno=0;
  List<DownloadedVideo> tasklist=[];
  int count=0;
  DownloadedVidDatabaseHelper downloadedVidDatabaseHelper=DownloadedVidDatabaseHelper();
  List<TaskInfo> taskss = [];

  setdownloadno(){
    downloadno=downloadno!+1;
    update();
  }

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
    if (linkfieldcontroller.text.contains("you")) {
      showdownload = 1;
      downloadController.sethasvalidlink();
      update();
    }
    if (!linkfieldcontroller.text.contains("you")) {
      showdownload = 0;
      downloadController.setnovalidlink();
      update();
    }
  }

  addclipboardtextlistener() async {
    linkfieldcontroller.addListener(() async {
      if (linkfieldcontroller.text.contains("you")) {
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
      
      getvideoinfo(youtubelink.substring(youtubelink.length-11));
      extractedlink = link;
      print(extractedlink);
      update();

    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
      print('failed to extract');
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
      'id': videoid,
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
         videos.videos![0].video!.thumbnails!.thumbnailsDefault!.url);
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
  emptyall(){
    taskss.clear();
    taskss=[];
    update();
  }
  loadtasks() async {
    taskss.clear();
    taskss=[];
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    taskss.addAll(tasks!.map((document) => TaskInfo(
      taskId: document.taskId,
      status: document.status,
      progress: document.progress,
      name: document.filename,
      link: document.url,
      filepath: document.savedDir,
    )));
    update();
    //   for(int i=0;i<=taskss.length-1;i++){
   //   print("Download name:"+taskss[i].name.toString());
   // }
    //  tasks[0].savedDir
  }

  initializedownload(
      String downloadlink, String tracktitle) {
    unbindBackgroundIsolate();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _isLoading = true;
    _permissionReady = false;
    prepare(downloadlink, tracktitle);
    //  requestDownload(downloadlink);
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    if(downloadno==0) {
      _port.listen((dynamic data) {
        if (debug) {
          print('UI Isolate Callback: $data');
        }
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
        loadtasks();
        if(progress==100){
          loadtasks();
        }
        if (taskss != null && taskss!.isNotEmpty) {
          final task = taskss!.firstWhere((task) => task.taskId == id);
          task.status = status;
          task.progress = progress;

          loadtasks();

          update();
        }
      });
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }
    _permissionReady = hasGranted;
    update();
  }
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  Future<Null> prepare(
      String downloadlink, String tracktitle) async {
    final tasks = await FlutterDownloader.loadTasks();
    _permissionReady = await _checkPermission();

    if (_permissionReady!) {
      await _prepareSaveDir();
      requestDownload(downloadlink, tracktitle);
    }
    _isLoading = false;
    update();
  }
  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void requestDownload(
      String downloadlink, String tracktitle) async {
    setdownloadno();
    final taskId = await FlutterDownloader.enqueue(
        url: downloadlink,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath!,
        fileName: tracktitle,
        showNotification: true,
        openFileFromNotification: true);
    _save(DownloadedVideo(currentvideotitle, currentvideothumbnaillink,
        currentyoutubechannelthumbnaillink, currentytchanneltitle,
        currentytchanneldescription, taskId, _localPath!));
    updateListView();
  }
  void _save(DownloadedVideo downloadedVideo) async {

    int result;
    if (downloadedVideo.id != null) {  // Case 1: Update operation
      result = await downloadedVidDatabaseHelper.updateDownload(downloadedVideo);
    } else { // Case 2: Insert Operation
      result = await downloadedVidDatabaseHelper.insertDownload(downloadedVideo);
    }

    if (result != 0) {  // Success
      print('Download saved succesfully');
    } else {  // Failure
      print('Problem Saving Download');
    }

  }

  void _delete(int id) async {
    int result = await downloadedVidDatabaseHelper.deleteDownload(id);
    if (result != 0) {
      print("Deleted succesfully");
    } else {
      print("Delete unsuccesful");
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = downloadedVidDatabaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<DownloadedVideo>> noteListFuture = downloadedVidDatabaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        this.tasklist = noteList;
        this.count = noteList.length;
      });
    });
    for(int i=0;i<=tasklist.length-1;i++){
      print("Video length"+tasklist.length.toString());
      print("Video image: "+tasklist[i].videothumbnailurl.toString());
    }
  }
  Widget topdownloadrow(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
//      top: 22
          top: screenwidth * 0.0462),
      padding: EdgeInsets.symmetric(
//      horizontal: 21
          horizontal: screenwidth * 0.05109),
      width: screenwidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              "All Downloads",
              style: TextStyle(
                  fontFamily: proximanovabold,
                  color: blackthemedcolor,
                  //   fontSize: 19
                  fontSize: screenwidth * 0.0462),
            ),
          ),
          Container(
            child: Text(
              tasklist.length.toString()+" files",
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: blackthemedcolor,
                  //   fontSize: 14
                  fontSize: screenwidth * 0.0340),
            ),
          ),
        ],
      ),
    );
  }

  Widget downloadedvideolist(BuildContext context,

      ){
    double screenwidth=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenwidth*0.0535),

      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: tasklist.length,
          itemBuilder: (context,index){
        return downloadedvidcard(
          context,
          DownloadedVideo(this.tasklist[index].videotitle, this.tasklist[index].videothumbnailurl,
              this.tasklist[index].channelthumbnailurl, this.tasklist[index].channeltitle,
              this.tasklist[index].channeldescription, this.tasklist[index].taskid,
              this.tasklist[index].filepath),index);

      }),
    );
  }

  Widget downloadedvidcard(BuildContext context,
      DownloadedVideo? downloadedvideo,int? index){
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        top: screenWidth * 0.05720, ),
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(11)),
          border:
          Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1)),
      width: screenWidth * 0.915,
      padding: EdgeInsets.all(
        //      16
          screenWidth * 0.0389),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Container(
                  //       height: 67, width: 67,
                  height: screenWidth * 0.1630, width: screenWidth * 0.1630,
                  decoration: BoxDecoration(
                    color: royalbluethemedcolor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: downloadedvideo!.videothumbnailurl.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: screenWidth * 0.1630,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: screenWidth * 0.63,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                //          right: 5
                                  right: screenWidth * 0.01216),
                              width: screenWidth * 0.46,
                              child: Text(
                                downloadedvideo!.videotitle.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: proximanovaregular,
                                    color: blackthemedcolor,
                                    //    fontSize: 14.5
                                    fontSize: screenWidth * 0.03527),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                          children: [DeleteVideo(
                                            index: index,
                                            taskid: downloadedvideo!.taskid.toString(),

                                          )]));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
//                              vertical: 5,horizontal: 12
                                      vertical: screenWidth * 0.01216,
                                      horizontal: screenWidth * 0.02919),
                                  decoration: BoxDecoration(
                                      color: redthemedcolor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xffFF0000)
                                                .withOpacity(0.48),
                                            blurRadius: 10,
                                            offset: Offset(0, 3))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontFamily: proximanovaregular,
                                          color: Colors.white,
                                          //           fontSize: 12.5
                                          fontSize: screenWidth * 0.0304),
                                    ),
                                  ),
                                ))
                          ],
                        )),
                    Container(
                        width: screenWidth * 0.63,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                "5.2M views",
                                style: TextStyle(
                                    fontFamily: proximanovaregular,
                                    color: greythemedcolor,
                                    //    fontSize: 14.5
                                    fontSize: screenWidth * 0.03527),
                              ),
                            ),
                            Container(
                              child: Text(
                                "01:45",
                                style: TextStyle(
                                    fontFamily: proximanovaregular,
                                    color: greythemedcolor,
                                    //    fontSize: 14.5
                                    fontSize: screenWidth * 0.03527),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
//     top:12
                top: screenWidth * 0.0391),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    //    height: 45,width: 45,
                    height: screenWidth * 0.1094, width: screenWidth * 0.1094,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greythemedcolor,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: downloadedvideo!.channelthumbnailurl.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      //       left: 12
                        left: screenWidth * 0.0291),
                    //    height: 45,
                    height: screenWidth * 0.1094,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            downloadedvideo!.channeltitle.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: proximanovabold,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenWidth * 0.0352),
                          ),
                        ),
                        Container(
                          child: Text(
                            downloadedvideo!.channeldescription.toString(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: proximanovaregular,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenWidth * 0.0352),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
//      top: 16
                top: screenWidth * 0.0389),
            child:

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await FlutterDownloader.open(
                        taskId: downloadedvideo!.taskid.toString());
                  },
                  child: Container(
//width:108,height:27,
                    width: screenWidth * 0.262, height: screenWidth * 0.0656,
                    decoration: BoxDecoration(
                        color: royalbluethemedcolor,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff0062FF).withOpacity(0.28),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ]),
                    child: Center(
                      child: Text(
                        "Open Video",
                        style: TextStyle(
                            fontFamily: proximanovaregular,
                            color: Colors.white,
                            //      fontSize: 13
                            fontSize: screenWidth * 0.03163),
                      ),
                    ),
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget homepagedownloadvideo(BuildContext context){
    double screenwidth = MediaQuery.of(context).size.width;
    return  Container(
      margin: EdgeInsets.only(
          top:
          screenwidth * 0.05720,
          bottom:
          screenwidth * 0.0709),
      padding: EdgeInsets.all(
//    15
          screenwidth * 0.03649),
      width: screenwidth * 0.915,
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius:
          BorderRadius.all(
              Radius.circular(
                  11)),
          border: Border.all(
              color: Color(
                  0xff707070)
                  .withOpacity(0.2),
              width: 1)),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,
        crossAxisAlignment:
        CrossAxisAlignment
            .start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius
                      .all(Radius
                      .circular(
                      11)),
                  child: Container(
                    //    height: 67,width: 67,
                    height:
                    screenwidth *
                        0.1630,
                    width:
                    screenwidth *
                        0.1630,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(
                            11)),
                        color:
                        royalbluethemedcolor),
                    child:
                    CachedNetworkImage(
                      imageUrl:
                      currentvideothumbnaillink!,
                      fit: BoxFit
                          .cover,
                    ),
                  ),
                ),
                Expanded(
                    child:
                    Container(
                      margin: EdgeInsets
                          .only(
                        //          left: 14
                          left: screenwidth *
                              0.034063),
                      //   height: 67,
                      height:
                      screenwidth *
                          0.1630,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Container(
                            child: Text(
                            currentvideotitle!,
                              textAlign:
                              TextAlign
                                  .left,
                              maxLines:
                              2,
                              style: TextStyle(
                                  fontFamily: proximanovaregular,
                                  color: blackthemedcolor,
                                  //    fontSize: 14.5
                                  fontSize: screenwidth * 0.03527),
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Container(
                                child:
                                Text(
                                  "5.2M views.",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: proximanovaregular,
                                      color: greythemedcolor,
                                      //    fontSize: 12.5
                                      fontSize: screenwidth * 0.03041),
                                ),
                              ),
                              Container(
                                child:
                                Text(
                                  "01:45",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: proximanovaregular,
                                      color: greythemedcolor,
                                      //    fontSize: 12.5
                                      fontSize: screenwidth * 0.03041),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),

          //channelinfo
          Container(
            margin: EdgeInsets.only(
//     top:12
                top: screenwidth *
                    0.0391),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .start,
              children: [
                ClipOval(
                  child: Container(
                    //    height: 45,width: 45,
                    height:
                    screenwidth *
                        0.1094,
                    width:
                    screenwidth *
                        0.1094,
                    decoration:
                    BoxDecoration(
                      shape: BoxShape
                          .circle,
                      color:
                      greythemedcolor,
                    ),
                    child:
                    CachedNetworkImage(
                      imageUrl:
                      currentyoutubechannelthumbnaillink!,
                      fit: BoxFit
                          .cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets
                        .only(
                      //       left: 12
                        left: screenwidth *
                            0.0291),
                    //    height: 45,
                    height:
                    screenwidth *
                        0.1094,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Container(
                          child:
                          Text(
                            currentytchanneltitle!,
                            textAlign:
                            TextAlign.center,
                            maxLines:
                            1,
                            style: TextStyle(
                                fontFamily: proximanovabold,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenwidth * 0.0352),
                          ),
                        ),
                        Container(
                          child:
                          Text(
                            currentytchanneldescription!,
                            textAlign:
                            TextAlign.start,
                            maxLines:
                            1,
                            style: TextStyle(
                                fontFamily: proximanovaregular,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenwidth * 0.0352),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          //quality options
          Container(
              margin:
              EdgeInsets.only(
                  top: 20),
              child:
              taskss.length!=0 &&
    taskss[taskss.length-1].name==currentvideotitle?
              taskss[taskss.length-1].status==DownloadTaskStatus.complete?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await FlutterDownloader.open(
                          taskId: taskss[taskss.length-1].taskId.toString());
                    },
                    child: Container(
//width:108,height:27,
                      width: screenwidth * 0.262, height: screenwidth * 0.0656,
                      decoration: BoxDecoration(
                          color: royalbluethemedcolor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff0062FF).withOpacity(0.28),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ]),
                      child: Center(
                        child: Text(
                          "Open Video",
                          style: TextStyle(
                              fontFamily: proximanovaregular,
                              color: Colors.white,
                              //      fontSize: 13
                              fontSize: screenwidth * 0.03163),
                        ),
                      ),
                    ),
                  )
                ],
              ):
                  Column(
                    children: [
                      Container(
                        margin:EdgeInsets.only(top: 12,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                taskss[taskss.length-1].progress!<100?
                                "Download in progress":"Download Successful",style: TextStyle(
                                fontFamily: proximanovaregular,
                                color: Colors.black87,
                                fontSize: 13
                              ),
                              ),
                            ),
                            taskss[taskss.length-1].progress!<100?Container(
                              child: Text(
                                taskss[taskss.length-1].progress.toString()+" %",style: TextStyle(
                                  fontFamily: proximanovaregular,
                                  color: Colors.black87,
                                  fontSize: 13
                              ),
                              ),
                            ):
                            Icon(
                              CupertinoIcons.checkmark_alt_circle_fill,
                              color: Color(0xff00C6B0),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          width:screenwidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: LinearProgressIndicator(
                            backgroundColor: Color(0xff707070).withOpacity(0.24),
                            color: taskss[taskss.length-1].progress==100?
                            Color(0xff00C6B0):royalbluethemedcolor,
                            value: taskss[taskss.length-1].progress!/100,
                          ),
                        ),
                      ),

                    ],

                  ):
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                children: [
                  downloadbutton(
                      context,
                          extractedlink!,
                          currentvideotitle!)
                  //         qualitybox(context, '360p'),
                  //       qualitybox(context, '720p')
                ],
              )

          )
        ],
      ),
    );
  }
  Widget downloadbutton(
      BuildContext context, String downloadlink, String title) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        loadtasks();
        initializedownload(downloadlink, title);
      },
      child: Container(
        //      height: 30,
        //    height: screenWidth * 0.0729,
        //  width: screenWidth * 0.3849,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 13.5),
        decoration: BoxDecoration(
            color: royalbluethemedcolor,
            borderRadius: BorderRadius.all(Radius.circular(7)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xff0062FF).withOpacity(0.28),
                  blurRadius: 10,
                  offset: Offset(0, 3)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.download,
              //      size: 20,
              size: screenWidth * 0.0466,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                "Download",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: Colors.white,
                    //    fontSize: 14.5
                    fontSize: screenWidth * 0.0352),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getdownloadslist(){

  }


}

class TaskInfo {
 late final String? name;
 late final String? link;
 late final String? filepath;
 late String? taskId;
 late int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  TaskInfo({this.name, this.link, this.filepath,this.taskId,this.progress,this.status});
}

class _ItemHolder {
  final String? name;
  final TaskInfo? task;

  _ItemHolder({this.name, this.task});
}