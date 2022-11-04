import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_chat/helpers/chat_helper.dart';

import '../../logic/bloc/chat_bloc.dart';

class ChatViewModel {
  late BuildContext buildContext;
  ChatHelper chatHelper = ChatHelper();

  void start(context) {
    buildContext = context;
    chatHelper.start(changeTypingStatus, changeOnlineStatus);
  }

  void changeTypingStatus(bool typing) {
    BlocProvider.of<ChatBloc>(buildContext).add(ChangeTyping(isTyping: typing));
  }

  void changeOnlineStatus(bool isOnline) {
    BlocProvider.of<ChatBloc>(buildContext)
        .add(ChangeOnline(isOnline: isOnline));
  }
}
