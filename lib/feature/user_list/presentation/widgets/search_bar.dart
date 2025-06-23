import 'package:codebase_project_assignment/feature/user_list/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/common/app_text_field.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearchBar extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  UserSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
      child: AppTextField(
        controller: searchController,
        hintText: S.of(context)?.searchHint ?? "",
        prefixIcon: const Icon(Icons.search),
        onChanged: (String value) {
          final bloc = context.read<UserBloc>();
          bloc.add(SearchUserListEvent(query: value));
        },
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            final bloc = context.read<UserBloc>();
            searchController.clear();
            bloc.add(SearchUserListEvent(query: ""));
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
