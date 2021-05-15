import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool isAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.isAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];

    widgetList.add(child);
    if (isAsyncCall) {
      final modal = new Stack(children: [
        new Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: false, color: color),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        )
      ]);
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
