import 'package:codebase_project_assignment/feature/user_list/data/models/user_detail_arguments.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/pages/user_detail_page.dart';
import 'package:codebase_project_assignment/main/navigation/route_paths.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutePaths.userDetail:
      final args = settings.arguments as UserDetailArguments;
      return MaterialPageRoute(
        builder: (_) => UserDetailPage(
          avatar: args.avatar,
          name: args.name,
          email: args.email,
        ),
      );
    default:
      return null;
  }
}
