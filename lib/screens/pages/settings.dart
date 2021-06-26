import 'package:flutter/material.dart';
import 'package:piperdownloader/screens/sharablewidgets/rateus.dart';
class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[  RateUs(),]),

        ],
      ),
    );
  }
}
