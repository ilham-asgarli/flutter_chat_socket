import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<ChangeTyping>(_onChangeTyping);
    on<ChangeLoading>(_onChangeLoading);
    on<ChangeOnline>(_onChangeOnline);
  }

  void _onChangeTyping(ChangeTyping event, Emitter<ChatState> emit) {
    emit(state.copyWith(isTyping: event.isTyping));
  }

  void _onChangeLoading(ChangeLoading event, Emitter<ChatState> emit) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onChangeOnline(ChangeOnline event, Emitter<ChatState> emit) {
    emit(state.copyWith(isOnline: event.isOnline));
  }
}
