import 'package:flutter/material.dart';

class SubPageScaffold extends StatelessWidget {
  SubPageScaffold({
    required this.onCompleted,
    required this.title,
    required this.child,
    this.actions,
    this.titleFontSize = 32,
  });

  final VoidCallback onCompleted;
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber.shade700,
          ),
          onPressed: onCompleted,
        ),
        actions: actions,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.w700,
            fontSize: titleFontSize,
            color: Colors.amber.shade700,
          ),
        ),
      ),
      body: child,
      resizeToAvoidBottomInset: false,
    );
  }
}
