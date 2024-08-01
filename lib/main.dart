import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common/common.dart';
import 'core/core.dart';
import 'injection.dart' as di;
import 'presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  SecureStorageClient storageClient = SecureStorageClient.instance;

  bool isLogin = await storageClient.containsKey(SharedPrefKey.accessToken);

  String? token = await storageClient.getByKey(SharedPrefKey.accessToken);
  debugPrint('Token: $token');

  runApp(MyApp(
    isLogin: isLogin,
  ));
}

class MyApp extends StatelessWidget {
  final bool _isLogin;

  const MyApp({
    Key? key,
    bool isLogin = false,
  })  : _isLogin = isLogin,
        super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<SignInBloc>()),
        //Product BLOC
        BlocProvider(create: (context) => di.locator<GetProductBloc>()),
        BlocProvider(create: (context) => di.locator<GetCategoriesBloc>()),
        BlocProvider(create: (context) => di.locator<PostProductBloc>()),
        BlocProvider(create: (context) => di.locator<UploadFileBloc>()),
        BlocProvider(create: (context) => di.locator<UpdateProductBloc>()),
        BlocProvider(create: (context) => di.locator<DeleteProductBloc>()),
        //Order BLOC
        BlocProvider(create: (context) => di.locator<OrderProductBloc>()),
        BlocProvider(create: (context) => di.locator<OrderItemProductsBloc>()),
        BlocProvider(create: (context) => di.locator<UpdateProductStokBloc>()),
        BlocProvider(create: (context) => di.locator<GetOrderByMonthBloc>()),
        BlocProvider(create: (context) => di.locator<GetOrderByDateBloc>()),
        BlocProvider(create: (context) => di.locator<GetOrderItemByDateBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.white,
            selectionHandleColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),

          //colorText: Colors.black,
          useMaterial3: true,
        ),
        home: _isLogin ? MainScreen() : const SignInScreen(),
      ),
    );
  }
}
