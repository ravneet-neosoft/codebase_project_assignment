import 'package:codebase_project_assignment/core/connectivity_bloc/connectivity_bloc.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'offline_banner.dart';

class UserListHeader extends StatelessWidget {
  const UserListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserSearchBar(),
        BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            if (state is ConnectivityOffline) {
              return OfflineBanner(
                message: S.of(context)?.offline ?? "",
                backgroundColor: Colors.red.shade100,
                textColor: Colors.red.shade900,
                icon: Icons.wifi_off,
              );
            } else if (state is ConnectivityBackOnline) {
              return OfflineBanner(
                message: S.of(context)?.backOnline ?? "",
                backgroundColor: Colors.green.shade100,
                textColor: Colors.green.shade900,
                icon: Icons.wifi,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
