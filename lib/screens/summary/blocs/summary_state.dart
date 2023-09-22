import 'package:equatable/equatable.dart';
import 'package:mcqmobile_app/models/getroom/room_response.dart';

class SummaryState extends Equatable {
  const SummaryState();

  @override
  List<Object?> get props => [];
}

class SummaryLoadingState extends SummaryState {}

class SummaryFailState extends SummaryState {}

class SummarySuccessState extends SummaryState {
  final RoomResponse roomResponse;
  const SummarySuccessState(this.roomResponse);
}
