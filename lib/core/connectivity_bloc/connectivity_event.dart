import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectivityNotify extends ConnectivityEvent {
  final bool isOnline;

  const ConnectivityNotify({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}


