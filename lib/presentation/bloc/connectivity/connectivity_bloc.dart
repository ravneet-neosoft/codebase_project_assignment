import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityBloc(Connectivity connectivity) : super(ConnectivityInitial()) {
    on<ConnectivityObserve>(_onObserve);
    on<ConnectivityNotify>(_onNotify);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      add(ConnectivityNotify( isOnline: isOnline));
    });
  }

  Future<void> _onObserve(
      ConnectivityObserve event, Emitter<ConnectivityState> emit) async {
    final result = await _connectivity.checkConnectivity();
    final isOnline = result != ConnectivityResult.none;
    emit(isOnline ?  ConnectivityOnline() : ConnectivityOffline());
  }

  void _onNotify(ConnectivityNotify event, Emitter<ConnectivityState> emit) {
    if (event.isOnline && state is ConnectivityOffline) {
      emit(ConnectivityBackOnline());
    } else if (!event.isOnline) {
      emit(ConnectivityOffline());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
