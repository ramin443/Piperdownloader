import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:intl/intl.dart';
import 'package:piperdownloader/dbhelpers/DownloadedVidDBHelper.dart';
import 'package:piperdownloader/getxcontrollers/clipboardcontroller.dart';
import 'package:piperdownloader/models/Downloaded_Video_Model.dart';
import 'package:piperdownloader/models/taskinfo.dart';
import 'package:sqflite/sqflite.dart';
class LinkExtractTest extends StatelessWidget {
   LinkExtractTest({Key? key}) : super(key: key);
   List<TaskInformation>? tasks=[];
   List<DownloadedVideo> tasklist=[];
   int count=0;
String? extractedlink;
DownloadedVidDatabaseHelper downloadedVidDatabaseHelper=DownloadedVidDatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){
            _save(DownloadedVideo("_videotitle", "_videothumbnailurl",
                "_channelthumbnailurl", "_channeltitle",
                "_channeldescription", "_taskid", "_filepath"));
          }, icon: Icon(
            CupertinoIcons.add_circled_solid,
            color: Colors.black87,
            size: 28,
          )),
          IconButton(onPressed: (){
            updateListView();
          }, icon: Icon(
            CupertinoIcons.mail,
            color: Colors.black87,
            size: 28,
          )),
        ],
      ),
    );
  }
  getdownloads()async{
    List<DownloadTask>? tas=await FlutterDownloader.loadTasks();
    tasks!.addAll(tas!.map((document) => TaskInformation(
      taskId: document.taskId,
      name: document.filename,
      status: document.status,
      filepath: document.savedDir,
      progress: document.progress,
      link: document.savedDir+"/"+document.filename.toString()
    )));
    for(int i=0;i<=tasks!.length-1;i++){
      print(tasks![i].name);
    }
  }
  Future<void> extractYoutubeLink(String youtubelink) async {
    String? link;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      //    print("tried");
      link =
      await (FlutterYoutubeDownloader.extractYoutubeLink(youtubelink, 18));
      print(youtubelink.substring(youtubelink.length-11));
   //   getvideoinfo(youtubelink.substring(youtubelink.length-11));
      extractedlink = link;
      print(extractedlink);

    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
    }
  }
   // Save data to database
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
       print("Video title"+tasklist[i].videotitle.toString());
     }
   }
}


