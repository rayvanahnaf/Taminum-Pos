import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasource/auth_remote_datasource.dart';
import 'package:meta/meta.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource authRemoteDatasource;
  LogoutBloc({required this.authRemoteDatasource}) : super(LogoutInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      emit (LogoutLoading());

      final response = await authRemoteDatasource.logout();

      response.fold(
            (l) => emit(LogoutFailure(message: l)),
            (r) => emit(LogoutSuccess()),
      );
      });
    }
}
