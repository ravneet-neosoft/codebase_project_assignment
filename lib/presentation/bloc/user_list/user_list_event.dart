part of 'user_list_bloc.dart';


abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserListEvent extends UserEvent {
  final String pageNumber;
  final List<UserEntity> currentUsersList;
  final bool forceRefresh;
  final bool isConnected;


  const GetUserListEvent({
    required this.pageNumber,
    this.currentUsersList = const [],
    this.forceRefresh = false,
    required this.isConnected,
  });

  @override
  List<Object?> get props => [pageNumber, currentUsersList];
}

class SearchUserListEvent extends UserEvent {
  final String query;

  const SearchUserListEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class RefreshUserListEvent extends UserEvent {
  const RefreshUserListEvent();
}

class LoadCachedUserListEvent extends UserEvent {
  const LoadCachedUserListEvent();

  @override
  List<Object?> get props => [];
}

class SetUserErrorEvent extends UserEvent {
  final AppError error;
  const SetUserErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}

class ScrollReachedBottomEvent extends UserEvent {}

class BackOnlineBannerHandledEvent extends UserEvent {}

class _ShowBackOnlineBannerEvent extends UserEvent {}





