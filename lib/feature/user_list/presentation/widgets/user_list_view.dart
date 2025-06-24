import 'package:codebase_project_assignment/core/connectivity_bloc/connectivity_bloc.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/user_list_body.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/user_list_header.dart';
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
    bloc.add(GetUserListEvent(pageNumber: '1'));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final state = bloc.state;
        if (state is UserLoaded && !state.hasReachedMax && !bloc.isFetching) {
          bloc.add(
            GetUserListEvent(
              pageNumber: '${bloc.currentPage + 1}',
              currentUsersList: state.users,
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
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
      final bloc = context.read<UserBloc>();
      if (state is ConnectivityBackOnline) {
        bloc.add(RefreshUserListEvent());
      }
       return Column(
        children: [
          UserListHeader(connectivityState: state),
          Expanded(child: UserListBody(scrollController: _scrollController)),
        ],
      );
        }
    );
  }
}
