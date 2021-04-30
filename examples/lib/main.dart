import 'package:flutter/material.dart';
import 'package:paper_folding_item/paper_folding_item.dart';

void main() {
  runApp(MyApp());
}

class FolderStatus {
  bool isExpanded;
  String title;
  Color headColor;

  FolderStatus({
    required this.isExpanded,
    required this.title,
    required this.headColor,
  });
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
  final List<FolderStatus> folders = [
    FolderStatus(isExpanded: false, title: "Number One", headColor: Colors.blue),
    FolderStatus(isExpanded: false, title: "Number Two", headColor: Colors.purple),
    FolderStatus(isExpanded: false, title: "Number Tree", headColor: Colors.deepOrange),
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget renderFoldContent() {
    return Container(
      color: Colors.amber,
      child: Image.asset('assets/images/1.png'),
    );
  }

  Widget renderFoldTitle() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text("Content", style: TextStyle(fontSize: 24),)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.folders.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: PaperFoldingItem(
                    maxHeight: 200,
                    direction: widget.direction,
                    contentBackgroundColor: widget.folders[index].headColor,
                    animationDuration: Duration(seconds: 1),
                    content: renderFoldContent(),
                    contentSizePercent: .6,
                    outer: renderFoldTitle(),
                    status: widget.folders[index].isExpanded ? FoldingStatus.OPEN : FoldingStatus.CLOSE,
                    onInnerTap: () => {
                      setState(() => widget.folders[index].isExpanded = !widget.folders[index].isExpanded)
                    },
                  ),
                );
              }
          )
        ),
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
