import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mcqmobile_app/models/checkidroom/entercode_response.dart';
import 'package:mcqmobile_app/models/getroom/room_response.dart';
import 'package:mcqmobile_app/models/insert_user_response.dart';
import 'package:mcqmobile_app/responsitory/stream_socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const baseUrl = 'http://192.168.10.28:3000';

class Repository {
  final Dio _dio = Dio();
  final http.Client httpClient;
  final getroom = (idroom) => '$baseUrl/joinroom/getroom?idroom=$idroom';
  final checkidroom = (idroom) => '$baseUrl/joinroom?idroom=$idroom';
  final insertUserToRoomUrl = (idroom, iduser, nameuser) =>
      '$baseUrl/joinroom/addusertoroom?idroom=$idroom&iduser=$iduser&nameuser=$nameuser';

  Repository(@required this.httpClient) : assert(httpClient != null);

  Future<RoomResponse?> getRoom(String idroom) async {
    try {
      final url = (getroom(idroom));
      var response = await httpClient.get(url as Uri);
      if (response.statusCode == 200) {
        var jsondecode = jsonDecode(response.body);
        return RoomResponse.fromJson(jsondecode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<EnterCodeResponse?> checkidRoom(String idroom) async {
    try {
      final url = (checkidroom(idroom));
      print(url);
      var response = await httpClient.get(url as Uri);
      if (response.statusCode == 200) {
        var jsondecode = jsonDecode(response.body);
        return EnterCodeResponse.fromJson(jsondecode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<InsertUserResponse?> insertUserToRoom(
      String idroom, String iduser, String nameuser) async {
    try {
      final url = (insertUserToRoomUrl(idroom, iduser, nameuser));
      print(url);
      var response = await httpClient.put(url as Uri);
      if (response.statusCode == 200) {
        var jsondecode = jsonDecode(response.body);
        return InsertUserResponse.fromJson(jsondecode);
      }
    } catch (e) {
      print(e);
    }
  }
}

class SocketRepository {
  StreamSocket streamSocket;

  SocketRepository({
    required this.streamSocket,
  });

  final IO.Socket socket = IO.io(baseUrl, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
  });

  setStreamSocket(StreamSocket streamSocket) {
    this.streamSocket.dispose();
    this.streamSocket = streamSocket;
  }

  // Connect to server and wait host room start
  // idroom: id room that user enterd before
  // iduser: id user auto create by time current
  // nameuser: nameuser entered sametime with idroom
  //String idroom, String iduser, String nameuser
  connectWaitRoom(String idroom, String iduser, String nameuser) {
    socket.connect();
    socket.onConnect((_) => {print('Connected')});
    //socket.emit('event', 'haha');
    //socket.on(
    //    'event2', (data) => {print(data), streamSocket.addResponse(data)});
    socket.emit('waitRoomSendFromClient', {
      'idroom': idroom,
      'iduser': iduser,
      'nameuser': nameuser,
    });

    socket.on(
        'waitStartRoom' + idroom,
        (data) => {
              print('start ' + data),
              streamSocket.addResponse(data),
            });
    print(socket.connected);
  }

  connectAnswerQuestion(
    String idroom,
    String iduser,
  ) {
    socket.emit('playerJoinToRoomPlay', {
      'idroom': idroom,
      'iduser': iduser,
    });
  }

  // Player answer
  answerQuestion(
    String idroom,
    String iduser,
    String idques,
    String idans,
    String valueans,
    bool istrue,
  ) {
    socket.emit('sendToServer', {
      'idroom': idroom,
      'iduser': iduser,
      'idques': idques,
      'idans': idans,
      'value': valueans,
      'istrue': istrue,
    });
  }

  connectWaitFinishRoom(
    String idroom,
    String iduser,
  ) {
    socket.emit('waitFinishRoom', {
      'idroom': idroom,
      'iduser': iduser,
    });

    socket.on(
        'finishRoomToClient' + idroom,
        (data) => {
              print('finish room ' + data),
              streamSocket.addResponse(data),
            });
  }
}
