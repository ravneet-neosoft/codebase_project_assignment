part of 'user_list_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  final bool hasReachedMax;

  const UserLoaded({required this.users, required this.hasReachedMax});

  UserLoaded copyWith({
    List<UserEntity>? users,
    bool? hasReachedMax,
    bool? showBackOnlineBanner,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [users, hasReachedMax];
}

class UserError extends UserState {
  final AppError error;
  const UserError(this.error);

  @override
  List<Object?> get props => [error];
}
