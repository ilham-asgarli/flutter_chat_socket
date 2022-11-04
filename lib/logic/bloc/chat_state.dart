part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final bool isTyping;
  final bool isLoading;
  final bool isOnline;

  const ChatState({
    this.isTyping = false,
    this.isLoading = false,
    this.isOnline = false,
  });

  ChatState copyWith({
    isTyping,
    isLoading,
    isOnline,
  }) =>
      ChatState(
        isTyping: isTyping ?? this.isTyping,
        isLoading: isLoading ?? this.isLoading,
        isOnline: isOnline ?? this.isOnline,
      );

  @override
  List<Object> get props => [isTyping, isLoading, isOnline];
}
