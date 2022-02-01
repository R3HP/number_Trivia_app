import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_number_trivia_app/dependecy_injection.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/bloc/numbertriva_bloc.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/widgets/message_widget.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/widgets/trivia_control.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/widgets/trivia_display.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('NumberTriviaApp'),),body: SingleChildScrollView(child: buildBody()));
  }

  Widget buildBody() {
    return BlocProvider(
      create: (_) => getIt<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (cntx, state) {
                if (state is NumberTriviaInitial) {
                  return const MessageDisplay(message: 'Search a Number');
                } else if (state is NumberTriviaLoadingState) {
                  return const LoadingWidget();
                } else if (state is NumberTriviaLoadedState) {
                  return TriviaDisplay(numberTriviaEntitie: state.numberTrivia);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }else{
                  return const MessageDisplay(message: 'Unexpected State');
                }
              }),
              const SizedBox(
                height: 10,
              ),
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
