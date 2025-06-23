import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:codebase_project_assignment/core/error/app_error.dart';
import 'package:codebase_project_assignment/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/domain/use_cases/get_user_use_case.dart';
import 'package:codebase_project_assignment/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_list_event.dart';
part 'user_list_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  final SharedPreferences sharedPreferences;
  final ConnectivityBloc connectivityBloc;

  int currentPage = 1;
  bool hasReachedMax = false;
  bool isFetching = false;
  List<UserEntity> users = [];
  static const String _cacheKey = 'cached_user_list';
  final TextEditingController searchController = TextEditingController();
  bool isOnline = true;
  Timer? _debounce;
  String _searchQuery = '';


  UserBloc({
    required this.getUsersUseCase,
    required this.sharedPreferences,
    required this.connectivityBloc,
  }) : super(UserInitial()) {
    on<GetUserListEvent>(_onGetUserListEvent);
    on<SearchUserListEvent>(_onSearchUserListEvent);
    on<RefreshUserListEvent>(_onRefreshUserListEvent);
    on<LoadCachedUserListEvent>(_onLoadCachedUsers);
    on<ScrollReachedBottomEvent>(_onScrollReachedBottom);
    on<SetUserErrorEvent>(_onSetUserErrorEvent);
    on<BackOnlineBannerHandledEvent>(_onBackOnlineBannerHandled);
    on<_ShowBackOnlineBannerEvent>(_onShowBackOnlineBanner);



    connectivityBloc.stream.listen((state) {
      if (state is ConnectivityOffline) {
        isOnline = false;
        final data = sharedPreferences.getString(_cacheKey);
        if (data != null) {
          final List<dynamic> decoded = jsonDecode(data);
          final cachedUsers = decoded.map((e) => UserEntity(
            id: e['id'],
            email: e['email'],
            firstName: e['first_name'],
            lastName: e['last_name'],
            avatar: e['avatar'],
          )).toList();
          users = cachedUsers;
          add(LoadCachedUserListEvent());
        } else {
          add(SetUserErrorEvent(AppError.network()));
        }
      } else if (state is ConnectivityBackOnline) {
        isOnline = true;
        add(GetUserListEvent(pageNumber: '1', forceRefresh: true, isConnected: isOnline));
        add(_ShowBackOnlineBannerEvent());
      }
    });

    searchController.addListener(() {
      final query = searchController.text.trim();
      if (_searchQuery != query) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 400), () {
          add(SearchUserListEvent(query: query));
        });
        _searchQuery = query;
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _debounce = null;
    searchController.dispose();
    return super.close();
  }


  Future<void> _onGetUserListEvent(
      GetUserListEvent event, Emitter<UserState> emit) async {

    final int page = int.tryParse(event.pageNumber) ?? 1;
    if (!isOnline && page > 1) return;

    if (isFetching || hasReachedMax && !event.forceRefresh) return;
    isFetching = true;

    try {
      final int page = int.tryParse(event.pageNumber) ?? 1;

      if (page == 1) {
        emit(UserLoading());
        users = [];
      }

      final newUsers = await getUsersUseCase(page, isOnline: isOnline);

      final currentBannerFlag =
      (state is UserLoaded) ? (state as UserLoaded).showBackOnlineBanner : false;


      if (newUsers.isEmpty) {
        hasReachedMax = true;
        emit(UserLoaded(users: users, hasReachedMax: true,
          showBackOnlineBanner: currentBannerFlag));
      } else {
        currentPage = page;
        users = [...event.currentUsersList, ...newUsers];
        hasReachedMax = newUsers.length < 10;

        emit(UserLoaded(users: users, hasReachedMax: hasReachedMax,
          showBackOnlineBanner: currentBannerFlag));
        await _cacheUsers(users);
      }
    } catch (e) {
      emit(UserError(AppError.unknown()));
    } finally {
      isFetching = false;
    }
  }

  void _onSearchUserListEvent(
      SearchUserListEvent event, Emitter<UserState> emit) {
    final query = event.query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    final filteredUsers = users.where((user) {
      final name = user.fullName.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      return name.contains(query);
    }).toList();

    final currentBannerFlag =
    (state is UserLoaded) ? (state as UserLoaded).showBackOnlineBanner : false;

    emit(UserLoaded(users: filteredUsers, hasReachedMax: true, showBackOnlineBanner: currentBannerFlag));
  }

  void _onScrollReachedBottom(ScrollReachedBottomEvent event, Emitter<UserState> emit) {
    if (!isOnline || hasReachedMax || isFetching) return;
    if (!hasReachedMax && !isFetching  && isOnline) {
      add(GetUserListEvent(
        pageNumber: '${currentPage + 1}',
        currentUsersList: users,
        isConnected: isOnline,
      ));
    }
  }

  void _onBackOnlineBannerHandled(BackOnlineBannerHandledEvent event, Emitter<UserState> emit) {
    if (state is UserLoaded && (state as UserLoaded).showBackOnlineBanner) {
      emit((state as UserLoaded).copyWith(showBackOnlineBanner: false));
    }
  }


  Future<void> _onRefreshUserListEvent(
      RefreshUserListEvent event, Emitter<UserState> emit) async {
    currentPage = 1;
    hasReachedMax = false;
    users = [];
    add(GetUserListEvent(pageNumber: '1', isConnected: isOnline));
  }

  Future<void> _onLoadCachedUsers(
      LoadCachedUserListEvent event, Emitter<UserState> emit) async {
    final data = sharedPreferences.getString(_cacheKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      final cachedUsers = decoded.map((e) => UserEntity(
        id: e['id'],
        email: e['email'],
        firstName: e['first_name'],
        lastName: e['last_name'],
        avatar: e['avatar'],
      )).toList();

      users = cachedUsers;
      emit(UserLoaded(users: cachedUsers, hasReachedMax: true));
    } else {
      emit(UserError(AppError.cache()));
    }
  }

  Future<void> _cacheUsers(List<UserEntity> users) async {
    final encoded = jsonEncode(users.map((e) => {
      'id': e.id,
      'email': e.email,
      'first_name': e.firstName,
      'last_name': e.lastName,
      'avatar': e.avatar,
    }).toList());
    await sharedPreferences.setString(_cacheKey, encoded);
  }

  void _onSetUserErrorEvent(
      SetUserErrorEvent event,
      Emitter<UserState> emit,
      ) {
    emit(UserError(event.error));
  }

  void _onShowBackOnlineBanner(
      _ShowBackOnlineBannerEvent event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      emit((state as UserLoaded).copyWith(showBackOnlineBanner: true));
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) {
        add(BackOnlineBannerHandledEvent());
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      add(_ShowBackOnlineBannerEvent());
    }
  }
}





