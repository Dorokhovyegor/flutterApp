import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  Answer(this.callBack, this.answerText);

  final Function callBack;
  final String answerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: RaisedButton(
        textColor: Colors.white70,
        color: Colors.deepPurple,
        child: Text(answerText),
        onPressed: callBack,
      ),
    );
  }
}
