import 'dart:async';
import 'dart:math';

import 'package:socket_io_client/socket_io_client.dart';

import '../chat/models/chat_model.dart';

class StreamSocket {
  final socketResponse = StreamController<List<ChatModel>>.broadcast();

  void Function(List<ChatModel>) get add => socketResponse.sink.add;

  Stream<List<ChatModel>> get getStream =>
      socketResponse.stream.asBroadcastStream();
}

class ChatHelper {
  StreamSocket streamSocket = StreamSocket();

  Socket socket = io(
    "https://nodejs-chat-socket-1.herokuapp.com/",
    OptionBuilder().setTransports(
      ['websocket'],
    ).build(),
  );

  bool typing = false;

  List<ChatModel> messages = [];
  String userId = Random().nextInt(100).toString();
  String roomId = "1";

  start(Function(bool typing) changeTypingStatus,
      Function(bool typing) changeOnlineStatus) {
    socket.onConnect((_) {
      streamSocket.add(messages);
      socket.emit('join_room', {
        "userId": userId,
        "roomId": roomId,
      });
    });

    socket.on('online', (data) {
      changeOnlineStatus(data["isOnline"]);
    });

    socket.on('typing', (data) {
      changeTypingStatus(data);
    });

    socket.on('message', (data) {
      messages.add(
        ChatModel(
          message: data["message"],
          owner: data["userId"] == userId,
          NEW: true,
          dateTime:
              DateTime.fromMicrosecondsSinceEpoch(data["created_at"] * 1000)
                  .toString(),
        ),
      );
      streamSocket.add(messages);
    });
  }

  void dispose() {
    socket.dispose();
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      socket.emit('message', {
        "userId": userId,
        "roomId": roomId,
        "message": message,
      });
    }
  }

  void changeTyping(bool isTyping) {
    socket.emit("typing", isTyping);
  }
}
