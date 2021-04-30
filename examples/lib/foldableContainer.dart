import 'package:flutter/material.dart';

import 'components/foldable2.dart';

class FoldableContainer extends StatelessWidget {
  final _foldingCellKey = GlobalKey<Foldable2State>();

  @override
  Widget build(BuildContext context) {
    return Foldable2.create(
      key: _foldingCellKey,
      frontWidget: _buildFrontWidget(),
      innerWidget: _buildInnerWidget(),
      initialSize: Size(MediaQuery.of(context).size.width, 140),
      // padding: EdgeInsets.all(15),
      // animationDuration: Duration(milliseconds: 300),
      // borderRadius: 10,
      onOpen: () => print('cell opened'),
      onClose: () => print('cell closed'),
    );
  }

  Widget _buildFrontWidget() {
    // return Container(
    //   color: Color(0xFFffcd3c),
    //   child: Text("PROVA")
    // );
    return Container(
      color: Color(0xFFffcd3c),
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "CARD TITLE",
              style: TextStyle(
                color: Color(0xFF2e282a),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: TextButton(
              onPressed: () {
              },
              child: Text(
                "OPEN",
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(80, 40),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInnerWidget() {
    return Container(
      color: Color(0xFFecf2f9),
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "CARD TITLE",
              style: TextStyle(
                color: Color(0xFF2e282a),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "CARD DETAIL",
              style: TextStyle(
                color: Color(0xFF2e282a),
                fontSize: 40.0,
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: TextButton(
              onPressed: () => {},
              child: Text(
                "Close",
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(80, 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

}