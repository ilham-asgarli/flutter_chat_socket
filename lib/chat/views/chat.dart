import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_chat/chat/models/chat_model.dart';
import 'package:flutter_socket_chat/chat/view-models/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../logic/bloc/chat_bloc.dart';
import '../components/chat_view_placeholder.dart';
import '../components/message_bubble.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ChatViewModel _chatViewModel = ChatViewModel();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _chatViewModel.start(context);
    super.initState();
  }

  @override
  void dispose() {
    _chatViewModel.chatHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildPage();
  }

  buildPage() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state.isTyping || state.isOnline,
                    child: Text(
                      state.isTyping ? "typing..." : "online",
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return StreamBuilder(
      stream: _chatViewModel.chatHelper.streamSocket.getStream,
      initialData: _chatViewModel.chatHelper.messages,
      builder:
          (BuildContext context, AsyncSnapshot<List<ChatModel>?> snapshot) {
        if (snapshot.hasData) {
          return buildChat(snapshot.data);
        } else {
          return const ChatViewPlaceholder();
        }
      },
    );
  }

  Widget buildChat(
    List<ChatModel>? contents,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: LazyLoadScrollView(
            scrollOffset: MediaQuery.of(context).size.height.toInt(),
            isLoading: context.watch<ChatBloc>().state.isLoading,
            onEndOfPage: () {
              //_chatViewModel.loadOldMessages();
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: context.watch<ChatBloc>().state.isLoading,
                    child: const CircularProgressIndicator(),
                  ),
                  buildMessages(contents?.reversed.toList()),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: buildTextField(),
                ),
                const SizedBox(
                  width: 10,
                ),
                buildSend(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMessages(
    List<ChatModel>? contents,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: 1,
      reverse: true,
      shrinkWrap: true,
      itemCount: contents?.length ?? 0,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Visibility(
              visible: false, //_chatViewModel.isNewDay(contents, index),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      DateFormat("dd.MM.yyyy").format(
                        DateTime.parse(
                          contents?[index].dateTime ?? "",
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            MessageBubble(
              chatModel: contents?[index],
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }

  buildTextField() {
    return TextField(
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: textEditingController,
      minLines: null,
      maxLines: 1,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Message",
      ),
      onChanged: (value) {
        _chatViewModel.chatHelper.changeTyping(true);
      },
    );
  }

  Widget buildSend() {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.send),
      onPressed: () {
        _chatViewModel.chatHelper.sendMessage(textEditingController.text);
        textEditingController.clear();
      },
    );
  }
}
