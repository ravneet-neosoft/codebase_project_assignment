import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/common/common_app_bar.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/user_list_view.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: S.of(context)?.userDirectory ?? ""),
      body: SafeArea(child: UserListView()),
    );
  }
}
