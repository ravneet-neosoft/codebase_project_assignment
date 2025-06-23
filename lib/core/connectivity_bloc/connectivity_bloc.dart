import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/service/network_connectivity.dart';
import 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final NetworkConnectivityService _connectivity;
  late StreamSubscription<bool> _subscription;

  ConnectivityBloc(
      this._connectivity
      ) : super(ConnectivityInitial()) {
    on<ConnectivityNotify>(_onNotify);

    _subscription = _connectivity.connectionStream.listen((isOnline) {
      add(ConnectivityNotify( isOnline: isOnline));
    });
  }


  Future<void> _onNotify(ConnectivityNotify event, Emitter<ConnectivityState> emit) async {
    if (event.isOnline && state is ConnectivityOffline) {
      emit(ConnectivityBackOnline());
      await Future.delayed(Duration(seconds: 3)).then((_){
        emit(ConnectivityInitial());
      });
    } else if (!event.isOnline) {
      emit(ConnectivityOffline());
    }
  }

  @override
  Future<void> close() {
    _connectivity.dispose();
    _subscription.cancel();
    return super.close();
  }
}
