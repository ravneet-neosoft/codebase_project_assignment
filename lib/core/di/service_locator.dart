import 'package:codebase_project_assignment/core/service/network_connectivity.dart';
import 'package:codebase_project_assignment/feature/user_list/data/api/user_api_service_impl.dart';
import 'package:codebase_project_assignment/feature/user_list/data/sources/user_data_source.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/use_cases/get_user_use_case.dart';
import 'package:codebase_project_assignment/feature/user_list/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:codebase_project_assignment/core/network/api_client.dart';
import 'package:codebase_project_assignment/feature/user_list/data/api/user_api_service.dart';
import 'package:codebase_project_assignment/feature/user_list/data/repositories/user_repository_impl.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton<NetworkConnectivityService>((){
    final NetworkConnectivityService networkService = NetworkConnectivityService();
    networkService.initialize();
    return networkService;
  });

  // Dio Client
  sl.registerLazySingleton<Dio>(() => ApiClient.createDioClient());

  // API Services
  sl.registerLazySingleton<UserApiService>(() => UserApiServiceImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<UserDataSource>(() => UserRemoteDataSourceImpl(sl()), instanceName: "remote");

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl<UserDataSource>(instanceName: "remote"), sl<UserDataSource>(instanceName: "local"), sl<SharedPreferences>(), sl<NetworkConnectivityService>()));

  // Use Cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // Bloc
  sl.registerFactory(() => UserBloc(getUsersUseCase: sl()));

  //shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //local data source
  sl.registerLazySingleton<UserDataSource>(() => UserLocalDataSourceImpl(sl()), instanceName: "local");

}

