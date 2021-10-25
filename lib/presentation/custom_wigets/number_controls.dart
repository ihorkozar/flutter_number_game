import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_game/presentation/bloc/number_bloc.dart';
import 'package:flutter_number_game/presentation/bloc/number_events.dart';

class NumberControls extends StatefulWidget {
  const NumberControls({
    Key? key,
  }) : super(key: key);

  @override
  State<NumberControls> createState() => _NumberControlsState();
}

class _NumberControlsState extends State<NumberControls> {
  String input = '';
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            input = value;
          },
          onSubmitted: (_) {
            getConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                  onPressed: getConcrete,
                  child: const Text('Search'),
                )),
            const SizedBox(width: 10,),
            Expanded(
                child: ElevatedButton(
                  onPressed: getRandom,
                  child: const Text('Get random'),
                )),
          ],
        )
      ],
    );
  }

  void getConcrete() {
    controller.clear;
    BlocProvider.of<NumberBloc>(context).add(GetConcreteNumberEvent(input));
  }

  void getRandom() {
    controller.clear;
    BlocProvider.of<NumberBloc>(context).add(GetRandomNumberEvent());
  }
}