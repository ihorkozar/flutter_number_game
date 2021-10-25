import 'package:flutter/material.dart';

class MsgDisplay extends StatelessWidget {
  final String msg;

  const MsgDisplay({
    Key? key,
    required this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            msg,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
