import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcqmobile_app/screens/roomques/blocs/getroom/getroom_event.dart';
import 'package:mcqmobile_app/screens/roomques/blocs/getroom/getroom_state.dart';

import 'package:mcqmobile_app/responsitory/repository.dart';
import 'package:mcqmobile_app/models/getroom/room_response.dart';

class GetRoomBloc extends Bloc<GetRoomEvent, GetRoomState> {
  final Repository repository;
  GetRoomBloc(this.repository)
      : super(GetRoomStateInitial());

  @override
  Stream<GetRoomState> mapEventToState(GetRoomEvent getRoomEvent) async* {
    if (getRoomEvent is GetRoomEventRequested) {
      yield GetRoomStateLoading();
      try {
        final RoomResponse? room_response =
            await repository.getRoom(getRoomEvent.idroom);
        if (room_response != null) {
          yield GetRoomStateSuccess(room_response);
        } else {
          yield GetRoomStateFail();
        }
      } catch (e) {
        print(e);
        yield GetRoomStateFail();
      }
    }
  }
}
