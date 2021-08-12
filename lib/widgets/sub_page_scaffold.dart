import 'package:flutter/material.dart';

class SubPageScaffold extends StatelessWidget {
  SubPageScaffold({
    required this.title,
    required this.child,
    this.onCompleted,
    this.actions,
    this.bottomNavigationBar,
    this.titleFontSize = 32,
  });

  final VoidCallback? onCompleted;
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade50,
        leading: onCompleted != null
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.primaryColor,
                ),
                onPressed: onCompleted,
              )
            : null,
        actions: actions,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.w700,
            fontSize: titleFontSize,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: false,
    );
  }
}
