import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../core/core.dart';
import 'presentation/presentation.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // SSL pinning
  var logger = Logger();
  Get.put<Logger>(logger); // Memasukkan logger ke dalam container Get

  //CookieJar
  var cookieJar = CookieJar();
  Get.put<CookieJar>(cookieJar);

  final DioClient ioClient = DioClient(
    logger: Get.find<Logger>(), // Memastikan Logger diinject ke DioClient
  );

  final SecureStorageClient secureStorageClient = SecureStorageClient.instance;

  // Assessment external
  Get.put<DioClient>(ioClient);

  //auth data source
  Get.put<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(
    dioClient: Get.find(),
    secureStorageClient: secureStorageClient,
  ));

  Get.put<ProductRemoteDataSource>(ProductRemoteDataSourceImpl(
    dioClient: Get.find(),
  ));

  // auth repository
  Get.put<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: Get.find(),
  ));

  Get.put<ProductRepository>(ProductRepositoryImpl(
    remoteDataSource: Get.find(),
  ));

  // bloc

  locator.registerLazySingleton(() => SignInBloc(signIn: locator()));

  //Product BLOC
  locator.registerLazySingleton(() => GetProductBloc(locator()));
  locator.registerLazySingleton(() => GetCategoriesBloc(locator()));
  locator.registerLazySingleton(() => PostProductBloc(locator()));
  locator.registerLazySingleton(() => UploadFileBloc(locator()));
  locator.registerLazySingleton(() => UpdateProductBloc(locator()));
  locator.registerLazySingleton(() => DeleteProductBloc(locator()));
  locator.registerLazySingleton(() => OrderProductBloc(locator()));
  locator.registerLazySingleton(() => OrderItemProductsBloc(locator()));
  locator.registerLazySingleton(() => UpdateProductStokBloc(locator()));
  locator.registerLazySingleton(() => GetOrderByMonthBloc(locator()));
  locator.registerLazySingleton(() => GetOrderByDateBloc(locator()));
  locator.registerLazySingleton(() => GetOrderItemByDateBloc(locator()));

  // repository

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  // data sources

  //assessment data source local

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: Get.find(),
      secureStorageClient: secureStorageClient,
    ),
  );

  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      dioClient: Get.find(),
    ),
  );

  // helper

  // network info

  // external
  locator.registerLazySingleton(() => ioClient);
}
