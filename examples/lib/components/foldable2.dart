import 'dart:math';

import 'package:flutter/material.dart';

/// [Foldable2] is a Widget that expands with a folding animation to show more data
class Foldable2 extends StatefulWidget {

  /// initial size (not expanded) of the widget
  final Size? initialSize;
  /// Widget to show when the Foldable is closed (which becomes the head when is open)
  final Widget frontWidget;
  /// Widget to show when Foldable is open, under the header
  final Widget innerWidget;
  /// On open callback
  final VoidCallback? onOpen;
  /// on close callback
  final VoidCallback? onClose;

  final bool? isExpanded;

  Foldable2.create({
    Key? key,
    required this.frontWidget,
    required this.innerWidget,
    this.initialSize = const Size(100.0,100.0),
    this.isExpanded = false,
    this.onOpen,
    this.onClose,
  })
  : assert(frontWidget != null),
    assert(innerWidget != null),
    assert(initialSize != null)
  ;

  @override
  Foldable2State createState() => Foldable2State();

}

class Foldable2State extends State<Foldable2> with SingleTickerProviderStateMixin{
  // bool _isExpanded = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // declare the animation controller with the animation duration
    // todo: duration by parameter
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    // add a listener to the animation status
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        // if the animation is complete and onOpen callback is not null calls it
        if(widget.onOpen != null) widget.onOpen!();
      } else if (status == AnimationStatus.dismissed) {
        // if the animation is dismissed and onClose callback is not null calls it
        if(widget.onClose != null) widget.onClose!();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  void didUpdateWidget(Foldable2 oldWidget) {
    super.didUpdateWidget(oldWidget);

      if(widget.isExpanded!) {
        _animationController.reverse();
        return;
      }
      _animationController.forward();
      return;
  }

  // void toggleFold() {
  //   _isExpanded = !_isExpanded;
  //   if(_isExpanded) {
  //     _animationController.reverse();
  //     return;
  //   }
  //   _animationController.forward();
  //   return;
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = _animationController.value * pi;
          final cellWidth = widget.initialSize?.width;
          final cellHeight = widget.initialSize?.height;

          return Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: Colors.transparent,
              width: cellWidth,
              // height here is calculated with the base height + (baseHeight times the animation current value)
              // so the container is growing accordingly to the animation
              height: cellHeight! + (cellHeight * _animationController.value),
              child: Stack(
                children: <Widget>[
                  // todo: clip for border radius!
                  // ClipRRect(
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(widget.borderRadius!),
                  //     topRight: Radius.circular(widget.borderRadius!)
                  //   ),
                  //   child:
                  // this is the inner widget
                  Container(
                    width: cellWidth,
                    height: cellHeight,
                    child: OverflowBox(
                      minHeight: cellHeight,
                      // todo: try not to set the max height (it will constraint it to the parent)
                      // the issue here is that we may not know the final height...
                      maxHeight: cellHeight * 2,
                      // todo: try to change this
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        child: Align(
                          // todo: test - multiply the child height by 50% of it's parent??
                          heightFactor: .5,
                          alignment: Alignment.topCenter,
                          // ****** THIS IS THE INNER WIDGET *****
                          child: widget.innerWidget
                        )
                      ),
                    )
                  ),
                  // this is the inner widget animation
                  Transform(
                    alignment: Alignment.center,
                    // this is the actual transformation
                    // @see https://medium.com/flutter-community/advanced-flutter-matrix4-and-perspective-transformations-a79404a0d828
                    transform: Matrix4.identity()
                      ..setEntry(3,2,0.001)
                      ..rotateX(angle),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(pi),
                      // todo only if rounded edges
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.only(
                      //       bottomLeft: Radius.circular(widget.borderRadius!),
                      //       bottomRight: Radius.circular(widget.borderRadius!)),
                      // )
                      //  child: Container(
                      child: Container(
                        width: cellWidth,
                        height: cellHeight * 2,
                        alignment: Alignment.topCenter,
                        child: ClipRect (
                          child: Align(
                            heightFactor: .5,
                            alignment: Alignment.bottomCenter,
                            child: widget.innerWidget,
                          )
                        )
                      )
                    )
                  ),
                  // this is the front widget
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(angle),
                    child: Opacity(
                      opacity: angle > 1.5708 ? 0.0 : 1.0,
                      // todo: clip for border radius!
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(widget.borderRadius!),
                      //     topRight: Radius.circular(widget.borderRadius!)
                      //   ),
                      //   child: Container(
                      child: Container(
                        width: angle >= 1.5708 ? 0.0 : cellWidth,
                        height: angle >= 1.5708 ? 0.0 : cellHeight,
                        child: widget.frontWidget
                      )
                    )
                  )
                ],
              )
            )
          );
        }
    );
  }
}