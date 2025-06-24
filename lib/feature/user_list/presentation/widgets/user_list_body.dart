import 'package:codebase_project_assignment/core/error/error_parser.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/skeletons/user_list_skeleton.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/place_holder_message.dart';

class UserListBody extends StatelessWidget {
  final ScrollController scrollController;

  const UserListBody({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh:
          () async =>
          context.read<UserBloc>().add(const RefreshUserListEvent()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const UserListSkeleton();
          } else if (state is UserLoaded) {
            final users = state.users;

            if (users.isEmpty) {
              return PlaceHolderMessage(text: S.of(context)?.noUsersFound,);
            }

            return ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              itemCount: state.hasReachedMax ? users.length : users.length + 1,
              itemBuilder: (context, index) {
                if (index >= users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return UserCard(user: users[index]);
              },
            );
          } else if (state is UserError) {
            return PlaceHolderMessage(text: ErrorParser.parse(state.error, S.of(context)));
          }
          return PlaceHolderMessage(text: S.of(context)?.errorLoadingUsers);
        },
      ),
    );
  }
}
