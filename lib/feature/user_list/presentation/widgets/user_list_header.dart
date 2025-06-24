import 'package:codebase_project_assignment/core/connectivity_bloc/connectivity_bloc.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'offline_banner.dart';

class UserListHeader extends StatelessWidget {
  final ConnectivityState connectivityState;

  const UserListHeader({super.key, required this.connectivityState});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserSearchBar(),
        if (connectivityState is ConnectivityOffline)
          OfflineBanner(
            message: S.of(context)?.offline??"",
            backgroundColor: Colors.red.shade100,
            textColor: Colors.red.shade900,
            icon: Icons.wifi_off,
          )
        else if (connectivityState is ConnectivityBackOnline)
          OfflineBanner(
            message: S.of(context)?.backOnline??"",
            backgroundColor: Colors.green.shade100,
            textColor: Colors.green.shade900,
            icon: Icons.wifi,
          ),
      ],
    );
  }
}
