import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/presentation/widgets/common/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearchBar extends StatelessWidget {
  const UserSearchBar({super.key,});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.read<UserBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
      child: AppTextField(
        controller: bloc.searchController,
        hintText: S.of(context)?.searchHint??"",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: bloc.searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            bloc.searchController.clear();
            FocusScope.of(context).unfocus();
          },
        )
            : null,
      ),
    );
  }
}