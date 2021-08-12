import 'package:flutter/material.dart';
import 'package:guldfasan/widgets/text_styles.dart';

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.brown.shade400,
          ),
          onPressed: () {
            if (onCompleted != null) {
              onCompleted!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: actions,
        title: Text(
          title,
          style: RajdhaniBold(
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
