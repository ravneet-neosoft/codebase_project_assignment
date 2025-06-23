import 'package:codebase_project_assignment/core/di/service_locator.dart';
import 'package:codebase_project_assignment/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:codebase_project_assignment/presentation/bloc/connectivity/connectivity_event.dart';
import 'package:codebase_project_assignment/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:codebase_project_assignment/presentation/pages/user_list_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
          create: (_) => ConnectivityBloc(Connectivity())..add(ConnectivityObserve()),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            getUsersUseCase: sl(),
            sharedPreferences: sl(),
            connectivityBloc: context.read<ConnectivityBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: const UserListPage(),
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates:  [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
