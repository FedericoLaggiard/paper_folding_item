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
  Axis direction = Axis.horizontal;

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
        body: Stack(
          children: [
            PaperFoldingItem(
              direction: widget.direction,
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
            Positioned(
                bottom: 10,
                left: 10,
                child: ElevatedButton(
                  style: ButtonStyle(
                  ),
                  onPressed: () {
                    setState(() {
                      widget.direction = widget.direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
                    });
                  },
                  child: Icon(Icons.arrow_forward),
                )
            ),
          ]),
        floatingActionButton: FloatingActionButton(
          child: Text("${widget.isExpanded! ? "-" : "+"}", style: TextStyle(fontSize: 20),),
          onPressed: () {
            setState(() {
              widget.isExpanded = widget.isExpanded! == true ? false : true;
            });
          },
        ),
    );
  }
}
