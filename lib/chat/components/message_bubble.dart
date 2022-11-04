import 'package:flutter/material.dart';
import 'package:flutter_socket_chat/chat/models/chat_model.dart';

import 'bubble_background.dart';
import 'bubble_child.dart';

@immutable
class MessageBubble extends StatelessWidget {
  final ChatModel? chatModel;
  final Widget? child;

  const MessageBubble({
    Key? key,
    this.chatModel,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        (chatModel?.owner ?? true) ? Alignment.topRight : Alignment.topLeft;

    return FractionallySizedBox(
      widthFactor: 1,
      child: FractionallySizedBox(
        alignment: messageAlignment,
        widthFactor: 0.8,
        child: Align(
          alignment: messageAlignment,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: BubbleBackground(
                colors: (chatModel?.owner ?? true)
                    ? const [Color(0xFF19B7FF), Color(0xFF491CCB)]
                    : const [Color(0xFF6C7689), Color(0xFF3A364B)],
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child ??
                        BubbleChild(
                          chatModel: chatModel,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
