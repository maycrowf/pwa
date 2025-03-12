part of 'main.dart';

Future<void> _initServiceLocator() async {
  await dotenv.load(fileName: ".env");
  final getIt = GetIt.instance;

  getIt
    // Services
    ..registerLazySingleton<WebViewService>(
      () => WebViewService(),
    )
    ..registerLazySingleton<LocationService>(
      () => LocationService(),
    )

    // Cubits
    ..registerLazySingleton<WebViewCubit>(
      () => WebViewCubit(getIt<WebViewService>()),
    )
    ..registerLazySingleton<LocationCubit>(
      () => LocationCubit(getIt<LocationService>(), getIt<WebViewService>()),
    );
}
