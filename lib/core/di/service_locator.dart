import 'package:codebase_project_assignment/data/api/user_api_service_impl.dart';
import 'package:codebase_project_assignment/data/sources/local/user_local_data_source.dart';
import 'package:codebase_project_assignment/data/sources/local/user_local_data_source_impl.dart';
import 'package:codebase_project_assignment/data/sources/remote/user_remote_data_source.dart';
import 'package:codebase_project_assignment/data/sources/remote/user_remote_impl.dart';
import 'package:codebase_project_assignment/domain/use_cases/get_user_use_case.dart';
import 'package:codebase_project_assignment/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:codebase_project_assignment/core/network/api_client.dart';
import 'package:codebase_project_assignment/data/api/user_api_service.dart';
import 'package:codebase_project_assignment/data/repositories/user_repository_impl.dart';
import 'package:codebase_project_assignment/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio Client
  sl.registerLazySingleton<Dio>(() => ApiClient.createDioClient());

  // API Services
  sl.registerLazySingleton<UserApiService>(() => UserApiServiceImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl(), sl<SharedPreferences>(), sl<UserLocalDataSource>()));

  // Use Cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // Bloc
  sl.registerFactory(() => UserBloc(getUsersUseCase: sl(), sharedPreferences: sl(), connectivityBloc: sl()));

  //shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //internet connectivity
  sl.registerLazySingleton(() => Connectivity());

  //local data source
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(sl()));
}

