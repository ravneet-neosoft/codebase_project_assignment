import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/presentation/widgets/skeletons/user_list_skeleton.dart';
import 'package:codebase_project_assignment/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/error_parser.dart';

class UserListBody extends StatelessWidget {
  final ScrollController scrollController;

  const UserListBody({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.read<UserBloc>();


    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const UserListSkeleton();
        } else if (state is UserLoaded) {
          final users = state.users;

          if (users.isEmpty) {
            return Center(child: Text(S.of(context)?.noUsersFound??""));
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<UserBloc>().add(const RefreshUserListEvent()),
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: 8,
              ),
              itemCount: state.hasReachedMax
                  ? users.length
                  : bloc.isOnline
                  ? users.length + 1
                  : users.length,
              itemBuilder: (context, index) {
                if (index >= users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return UserCard(user: users[index]);
              },
            ),
          );
        } else if (state is UserError) {
          print("sss ${state.error}");
          return Center(child: Text(ErrorParser.parse(state.error,S.of(context))));
        }
        return Center(child: Text(S.of(context)?.errorLoadingUsers??""));
      },
    );
  }
}
