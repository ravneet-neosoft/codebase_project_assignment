import 'package:codebase_project_assignment/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/presentation/widgets/user_list_body.dart';
import 'package:codebase_project_assignment/presentation/widgets/user_list_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserBloc>();
    final cachedData = bloc.sharedPreferences.getString('cached_user_list');

    if (cachedData != null && cachedData.isNotEmpty) {
      bloc.add(const LoadCachedUserListEvent());
    } else {
      bloc.add(GetUserListEvent(
        pageNumber: '1',
        isConnected: bloc.isOnline,
      ));
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final state = bloc.state;
        if (state is UserLoaded &&
            !state.hasReachedMax &&
            bloc.isOnline &&
            !bloc.isFetching) {
          bloc.add(
            GetUserListEvent(
              pageNumber: '${bloc.currentPage + 1}',
              currentUsersList: state.users,
              isConnected: bloc.isOnline,
            ),
          );
        }
      }
    });
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserListHeader(),
        Expanded(
          child: UserListBody(
            scrollController: _scrollController,
          ),
        ),
      ],
    );
  }
}
