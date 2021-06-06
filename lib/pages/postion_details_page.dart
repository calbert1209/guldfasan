import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';

class PositionDetailsPage extends StatelessWidget {
  PositionDetailsPage({required this.postion});

  final Position postion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(
            context,
            this.postion,
          ),
        ),
        title: Text(
          "Edit Position",
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
        ),
      ),
      body: MyContainer(),
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // TODO Display Position Details
          ],
        ),
      ),
    );
  }
}
