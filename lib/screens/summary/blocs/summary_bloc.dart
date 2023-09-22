import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcqmobile_app/models/getroom/room_response.dart';
import 'package:mcqmobile_app/responsitory/repository.dart';
import 'package:mcqmobile_app/screens/summary/blocs/summary_event.dart';
import 'package:mcqmobile_app/screens/summary/blocs/summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final Repository repository;

  SummaryBloc(this.repository) : super(const SummaryState());

  @override
  Stream<SummaryState> mapEventToState(SummaryEvent event) async* {
    if (event is SummaryEventRequested) {
      yield SummaryLoadingState();
      try {
        final RoomResponse? roomResponse =
            await repository.getRoom(event.idroom);

        if (roomResponse != null) {
          yield SummarySuccessState(roomResponse);
        } else {
          yield SummaryFailState();
        }
      } catch (e) {
        yield SummaryFailState();
      }
    }
  }
}
