import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_game/presentation/bloc/number_bloc.dart';
import 'package:flutter_number_game/presentation/bloc/number_state.dart';
import 'package:flutter_number_game/presentation/custom_wigets/loading_widget.dart';
import 'package:flutter_number_game/presentation/custom_wigets/msg_display.dart';
import 'package:flutter_number_game/presentation/custom_wigets/number_controls.dart';
import 'package:flutter_number_game/presentation/custom_wigets/number_msg_display.dart';
import 'package:flutter_number_game/service_locator.dart';

class NumberScreen extends StatelessWidget {
  const NumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Game'),
      ),
      body: SingleChildScrollView(child: buildBlocProvider(context)),
    );
  }

  BlocProvider<NumberBloc> buildBlocProvider(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => serviceLocator<NumberBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              BlocBuilder<NumberBloc, NumberState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MsgDisplay(
                      msg: 'Start Searching',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return NumberMsgDisplay(
                      number: state.number,
                    );
                  } else if (state is Error) {
                    return MsgDisplay(
                      msg: state.msg,
                    );
                  } else {
                    return const Center(
                        child: Text('I am broke, try again later'),);
                  }
                },
              ),
              const SizedBox(height: 20),
              const NumberControls(),
            ],
          ),
        ),
      ),
    );
  }
}
