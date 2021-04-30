import 'package:flutter/material.dart';
import 'package:paper_folding_item/paper_folding_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', isExpanded: false),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title, required this.isExpanded}) : super(key: key);

  final String title;
  bool? isExpanded;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: PaperFoldingItem(
          direction: Axis.horizontal,
          contentBackgroundColor: Colors.deepOrange,
          animationDuration: Duration(seconds: 1),
          content: Container(
            color: Colors.amber,
            child: Text("drawer"),
          ),
          contentSizePercent: .6,
          outer: Container(
            child: Text("Content"),
          ),
          status: widget.isExpanded! ? FoldingStatus.OPEN : FoldingStatus.CLOSE,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              widget.isExpanded = widget.isExpanded! == true ? false : true;
            });
          },
        ),
    );
  }
}
