import 'package:flutter/material.dart';
import 'package:flutter_number_game/domain/entities/number.dart';

class NumberMsgDisplay extends StatelessWidget {
  final Number number;

  const NumberMsgDisplay({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(children: [
        Text(
          number.number.toString(),
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                number.text,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
