
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:piperdownloader/downloadtests/dbtest.dart';
import 'package:piperdownloader/downloadtests/downloadtester.dart';
import 'package:piperdownloader/downloadtests/linkextracttest.dart';
import 'package:piperdownloader/screens/base.dart';
import 'package:piperdownloader/screens/initial/splashscreen.dart';
import 'package:piperdownloader/testers/pubtester.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Video Downloader',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
      routes: <String,WidgetBuilder>{
        '/Base':(BuildContext context)=> Base()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),

    );
  }
  emptycode(){}

}
