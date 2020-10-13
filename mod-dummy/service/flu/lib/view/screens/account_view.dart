import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext bcontext) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: RaisedButton(
          child: Text('Test Auth Dialog'),
          autofocus: false,
          clipBehavior: Clip.none,
          onPressed: () => null,
        ),
      ),
    );
  }
}
