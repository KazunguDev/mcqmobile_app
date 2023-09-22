import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcqmobile_app/models/getroom/room_response.dart';
import 'package:mcqmobile_app/responsitory/repository.dart';
import 'package:mcqmobile_app/responsitory/stream_socket.dart';
import 'package:mcqmobile_app/screens/waitroom_finish/blocs/waitroom_finish_event.dart';
import 'package:mcqmobile_app/screens/waitroom_finish/blocs/waitroom_finish_state.dart';

class WaitRoomFinishBloc
    extends Bloc<WaitRoomFinishEvent, WaitRoomFinishState> {
  StreamSocket streamSocket = StreamSocket();
  final SocketRepository socketRepository;
  final Repository repository;

  WaitRoomFinishBloc(this.socketRepository, this.repository)
      : super(const WaitRoomFinishState());

  @override
  Stream<WaitRoomFinishState> mapEventToState(
      WaitRoomFinishEvent event) async* {
    if (event is WaitRoomFinishEventConnected) {
      socketRepository.setStreamSocket(streamSocket);
      try {
        final RoomResponse? roomResponse =
            await repository.getRoom(event.idroom);

        await socketRepository.connectWaitFinishRoom(
          event.idroom,
          event.iduser,
        );

        if (roomResponse != null) {
          yield WaitRoomFinishStateSuccess(streamSocket, roomResponse);
        } else {
          yield WaitRoomFinishStateFail();
        }
      } catch (e) {
        yield WaitRoomFinishStateFail();
      }
    }
  }
}
