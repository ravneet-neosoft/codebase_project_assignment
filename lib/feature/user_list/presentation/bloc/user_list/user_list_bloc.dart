import 'dart:async';
import 'package:codebase_project_assignment/core/error/app_error.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/use_cases/get_user_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_list_event.dart';
part 'user_list_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;

  int currentPage = 1;
  bool hasReachedMax = false;
  bool isFetching = false;
  List<UserEntity> users = [];
  Timer? _debounce;
  String _searchQuery = '';

  UserBloc({required this.getUsersUseCase}) : super(UserInitial()) {
    on<GetUserListEvent>(_onGetUserListEvent);
    on<SearchUserListEvent>(_onSearchUserListEvent);
    on<RefreshUserListEvent>(_onRefreshUserListEvent);
    on<ScrollReachedBottomEvent>(_onScrollReachedBottom);
    add(GetUserListEvent(pageNumber: '1', forceRefresh: true));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _debounce = null;
    return super.close();
  }

  Future<void> _onGetUserListEvent(
    GetUserListEvent event,
    Emitter<UserState> emit,
  ) async {
    if (isFetching || hasReachedMax && !event.forceRefresh) return;
    isFetching = true;

    try {
      final int page = int.tryParse(event.pageNumber) ?? 1;

      if (page == 1) {
        emit(UserLoading());
        users = [];
      }

      final newUsers = await getUsersUseCase(page);

      if (newUsers.isEmpty) {
        hasReachedMax = true;
        emit(UserLoaded(users: users, hasReachedMax: true));
      } else {
        currentPage = page;
        users = [...event.currentUsersList, ...newUsers];
        hasReachedMax = newUsers.length < 10;

        emit(UserLoaded(users: users, hasReachedMax: hasReachedMax));
      }
    } catch (e) {
      emit(UserError(AppError.unknown()));
    } finally {
      isFetching = false;
    }
  }

  void _onSearchUserListEvent(
    SearchUserListEvent event,
    Emitter<UserState> emit,
  ) {
    final query = event.query.trim().toLowerCase().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    if (_searchQuery != query) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {});
      _searchQuery = query;
      final filteredUsers =
          users.where((user) {
            final name = user.fullName.toLowerCase().replaceAll(
              RegExp(r'\s+'),
              ' ',
            );
            return name.contains(query);
          }).toList();

      emit(UserLoaded(users: filteredUsers, hasReachedMax: true));
    }
  }

  void _onScrollReachedBottom(
    ScrollReachedBottomEvent event,
    Emitter<UserState> emit,
  ) {
    if (!hasReachedMax && !isFetching) {
      add(
        GetUserListEvent(
          pageNumber: '${currentPage + 1}',
          currentUsersList: users,
        ),
      );
    }
  }

  Future<void> _onRefreshUserListEvent(
    RefreshUserListEvent event,
    Emitter<UserState> emit,
  ) async {
    currentPage = 1;
    hasReachedMax = false;
    users = [];
    add(GetUserListEvent(pageNumber: '1', ));
  }

}
