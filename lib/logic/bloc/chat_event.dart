part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChangeTyping extends ChatEvent {
  final bool isTyping;

  const ChangeTyping({required this.isTyping});

  @override
  List<Object?> get props => [isTyping];
}

class ChangeLoading extends ChatEvent {
  final bool isLoading;

  const ChangeLoading({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class ChangeOnline extends ChatEvent {
  final bool isOnline;

  const ChangeOnline({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}
