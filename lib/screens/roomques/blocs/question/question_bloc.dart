import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcqmobile_app/models/getroom/question.dart';
import 'package:mcqmobile_app/responsitory/repository.dart';
import 'package:mcqmobile_app/screens/roomques/blocs/question/question_event.dart';
import 'package:mcqmobile_app/screens/roomques/blocs/question/question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final Repository repository;
  final SocketRepository socketRepository;

  QuestionBloc({
    required this.repository,
    required this.socketRepository,
  }) : super(const QuestionState());

  @override
  Stream<QuestionState> mapEventToState(QuestionEvent event) async* {
    if (event is QuestionConnectSocket) {
      yield QuestionAnswerConnecting();
      try {
        await socketRepository.connectAnswerQuestion(
          event.idroom,
          event.iduser,
        );
        yield QuestionAnswerConnectSuccess();
      } catch (e) {
        yield QuestionAnswerConnectFail();
      }
    } else if (event is QuestionWasAnswer) {
      yield QuestionAnswerLoading();
      try {
        await socketRepository.answerQuestion(
          event.idroom,
          event.iduser,
          event.idques,
          event.idans,
          event.valueans,
          event.istrue,
        );
        yield QuestionAnswerSuccess();
      } catch (e) {
        yield QuestionAnswerFail();
      }
    } else if (event is QuestionEventNextQuestion) {
      yield QuestionAnswerNextQuestion();
    }
  }
}
