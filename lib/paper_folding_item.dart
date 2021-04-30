library paper_folding_item;

import 'dart:ffi';

import 'package:flutter/material.dart';

enum FoldingStatus {
  OPEN,
  CLOSE,
}

class PaperFoldingItem extends StatelessWidget {
  final FoldingStatus status;
  final Color contentBackgroundColor;
  final Widget content;
  final double contentSizePercent;
  final Widget outer;
  final Axis? direction;
  final Duration? animationDuration;
  final double maxHeight;
  final VoidCallback? onOuterTap;
  final VoidCallback? onInnerTap;

  const PaperFoldingItem({
    Key? key,
    required this.status,
    required this.content,
    required this.contentSizePercent,
    required this.outer,
    required this.contentBackgroundColor,
    this.direction,
    this.animationDuration,
    this.onInnerTap,
    this.onOuterTap,
    required this.maxHeight,
  }) : super(key: key);

  Tween<double> getTween() {
    switch (status) {
      case FoldingStatus.OPEN:
        return Tween<double>(begin: 0.0, end: 1.0);
      case FoldingStatus.CLOSE:
        return Tween<double>(begin: 1.0, end: 0.0);
      default:
        return Tween<double>(begin: 0.0, end: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (direction) {
      case Axis.vertical:
        return buildVertical(context);
      default:
        return buildHorizontal(context);
    }

  }

  Widget buildVertical(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints) {
      return TweenAnimationBuilder<double>(
          curve: Curves.fastOutSlowIn,
          tween: getTween(),
          duration: animationDuration != null ? animationDuration! : Duration(milliseconds: 700),
          builder: (context, data, child) {
            final double drawerWidth = constraints.maxWidth * contentSizePercent * data;
            final double portionAngle = 1.57 * (1 - data);
            final double perspective = 0.007 * (1 - data);
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            final Widget drawerContainer = Container(
              height: height,
              width: width * contentSizePercent,
              child: content,
            );
            return Container(
              height: height,
              color: contentBackgroundColor ,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.fitHeight,
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          width: drawerWidth,
                          height: height,
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: ClipRect(
                            child: Align(
                              widthFactor: 0.5 * data,
                              alignment: Alignment.centerLeft,
                              child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 0, perspective)
                                    ..rotateY(portionAngle),
                                  alignment: Alignment.centerLeft,
                                  child: AbsorbPointer(absorbing: true, child: drawerContainer)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ClipRect(
                            child: Align(
                              widthFactor: 0.5 * data,
                              alignment: Alignment.centerRight,
                              child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 0, -perspective)
                                    ..rotateY(portionAngle),
                                  alignment: Alignment.centerRight,
                                  child: AbsorbPointer(absorbing: true, child:
                                    Stack(children: [
                                      drawerContainer,
                                      // shadow on the right face to enhance 3d effect
                                      Positioned(
                                        right: 0,
                                        child: Opacity(
                                          opacity: (1-data) * .3,
                                          child: Container(
                                            decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
                                            width: drawerWidth,
                                            height: height,
                                          ),
                                        ),
                                      ),
                                    ])
                                  )
                              ),
                            ),
                          ),
                        ),
                        if (data == 1.0) ...[drawerContainer],
                        if (data != 1.0) ...[
                          Positioned(
                              top: height * .1,
                              left: drawerWidth / 2,
                              // width: drawerWidth * data,
                              child: Opacity(
                                opacity: 1-data,
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)]),
                                  width: 2,
                                  height: height * 0.8,
                                ),
                              )),
                        ]
                      ],
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: height,
                      child: outer,
                    )
                  ],
                ),
              ),
            );
          });
    });
  }

  Widget buildHorizontal(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints) {
      return TweenAnimationBuilder<double>(
          curve: Curves.fastOutSlowIn,
          tween: getTween(),
          duration: animationDuration != null ? animationDuration! : Duration(milliseconds: 700),
          builder: (context, data, child) {
            final double drawerHeight = maxHeight * contentSizePercent * data;
            final double portionAngle = 1.50 * (1 - data);
            final double perspective = 0.002 * (1 - data);
            final width = constraints.maxWidth;
            final height = maxHeight;
            final Widget drawerContainer = Container(
              width: width,
              height: height * contentSizePercent,
              child: content,
            );
            return Container(
              width: width,
              color: contentBackgroundColor,
              child: FittedBox(
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
                child: Column(
                  children: <Widget>[
                    // this is the fixed part
                    Container(
                      width: width,
                      child: InkWell(
                        onTap: () => { if(onInnerTap != null) onInnerTap!()},
                        child: outer
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: <Widget>[
                        // this is the folded item
                        Container(
                          color: Colors.black,
                          height: drawerHeight,
                          width: width,
                        ),
                        // Slice Top
                        if(data <1.0) ...[Positioned(
                          top: 0,
                          left: 0,
                          child: ClipRect(
                            clipBehavior: Clip.hardEdge,
                            child: Align(
                              heightFactor: 0.3 * data,
                              alignment: Alignment.topCenter,
                              child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, perspective)
                                    ..rotateX(portionAngle),
                                  alignment: Alignment.topCenter,
                                  child: AbsorbPointer(
                                      absorbing: true,
                                      child: Stack(children: [
                                        drawerContainer,
                                        // shadow on the top face to enhance 3d effect
                                        Opacity(
                                          opacity: (1-data) * .3,
                                          child: Container(
                                            decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
                                            width: width,
                                            height: height,
                                          ),
                                        ),
                                      ])
                                  )),
                            ),
                          ),
                        )],
                        // Slice Bottom
                        if(data <1.0) ...[Positioned(
                          bottom: 0,
                          left: 0,
                          child: ClipRect(
                            clipBehavior: Clip.hardEdge,
                            child: Align(
                              heightFactor: 0.5 * data,
                              alignment: Alignment.bottomCenter,
                              child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, -perspective)
                                    ..rotateX(portionAngle),
                                  alignment: Alignment.bottomCenter,
                                  child: AbsorbPointer(absorbing: true, child: drawerContainer)),
                            ),
                          ),
                        )],
                        // if the animation is completed show the content
                        if (data == 1.0) ...[drawerContainer],
                        // else show a shadow
                        if (data != 1.0) ...[
                          Positioned(
                              left: width * .08,
                              top: drawerHeight / 2,
                              child: Opacity(
                                opacity: 1-data,
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black, blurRadius: 8)]),
                                  width: width - (width * .16),
                                  height: 1,
                                ),
                              )),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
