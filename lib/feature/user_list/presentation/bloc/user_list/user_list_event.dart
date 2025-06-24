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

  const GetUserListEvent({
    required this.pageNumber,
    this.currentUsersList = const [],
    this.forceRefresh = false,
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

class ScrollReachedBottomEvent extends UserEvent {}
