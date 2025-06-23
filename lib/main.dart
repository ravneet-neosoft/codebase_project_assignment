import 'package:codebase_project_assignment/core/connectivity_bloc/connectivity_bloc.dart';
import 'package:codebase_project_assignment/core/di/service_locator.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/pages/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/service/network_connectivity.dart';
import 'core/theme/app_theme.dart';
import 'main/navigation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc(sl<NetworkConnectivityService>()),
        ),
        BlocProvider(create: (context) => sl<UserBloc>()),
      ],
      child: MaterialApp(
        home: const UserListPage(),
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
