import 'package:flutter/material.dart';
import 'package:flutter_socket_chat/chat/models/chat_model.dart';
import 'package:intl/intl.dart';

class BubbleChild extends StatelessWidget {
  final ChatModel? chatModel;

  const BubbleChild({
    Key? key,
    required this.chatModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: [
          Text(
            chatModel?.message ?? "",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat("HH:mm").format(
                  DateTime.parse(chatModel?.dateTime ?? ""),
                ),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Visibility(
                visible: (chatModel?.owner ?? true),
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 5 / 3,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      (chatModel?.NEW ?? true)
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 15,
                            )
                          : const Icon(
                              Icons.done_all,
                              color: Colors.cyanAccent,
                              size: 15,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
