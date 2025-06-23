import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:codebase_project_assignment/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'offline_banner.dart';

class UserListHeader extends StatelessWidget {

  const UserListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final showBanner = state is UserLoaded && state.showBackOnlineBanner;

        return Column(
          children: [
            UserSearchBar(),
            if (showBanner)
              OfflineBanner(
                message: S.of(context)?.backOnline??"",
                backgroundColor: Colors.green.shade100,
                textColor: Colors.green.shade900,
                icon: Icons.wifi,
              ),
            BlocBuilder<ConnectivityBloc, ConnectivityState>(
              builder: (context, state) {
                if (state is ConnectivityOffline) {
                  return OfflineBanner(
                    message: S.of(context)?.offline??"",
                    backgroundColor: Colors.red.shade100,
                    textColor: Colors.red.shade900,
                    icon: Icons.wifi_off,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }
}
