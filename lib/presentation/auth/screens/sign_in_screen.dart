import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/core.dart';
import '../../../../common/common.dart';
import '../../presentation.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  SharedPrefClient sharedPrefClient = SharedPrefClient.instance;

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    // getDataRememberMe();
    // emailTextController.text = 'admin@example.com';
    // passwordTextController.text = '11223344';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222222),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login to POS',
                style: FontsGlobal.semiBoldTextStyle24.copyWith(
                  color: Colors.white,
                ),
              ),
              const VerticalSeparator(height: 2),
              Text(
                'Email',
                style: FontsGlobal.regulerTextStyle16.copyWith(
                  color: ColorConstant.greyTextColor,
                ),
              ),
              const VerticalSeparator(height: 0.5),
              PrimaryTextField(
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                textEditingController: emailTextController,
              ),
              const VerticalSeparator(height: 2),
              Text(
                'Password',
                style: FontsGlobal.regulerTextStyle16.copyWith(
                  color: ColorConstant.greyTextColor,
                ),
              ),
              const VerticalSeparator(height: 0.5),
              PrimaryTextField(
                hintText: 'Password',
                obscureText: true,
                textEditingController: passwordTextController,
                suffixIcon: true,
              ),
              const VerticalSeparator(height: 1),
              //remember me
              Row(
                children: [
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'Remember me',
                    style: FontsGlobal.regulerTextStyle14.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const VerticalSeparator(height: 2),
              BlocConsumer<SignInBloc, BaseState>(
                listener: (context, state) {
                  debugPrint('state SignInBloc : $state');
                  if (state is SignInLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "loading....",
                          style: FontsGlobal.mediumTextStyle14,
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is SuccessState) {
                    //close loading
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    // saveNIKPassword();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                      (route) => false,
                    );
                  } else if (state is ErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Email atau Password salah",
                          style: FontsGlobal.mediumTextStyle14,
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    text: 'Log in',
                    onPressed: () {
                      context.read<SignInBloc>().add(
                            SignInWithNIKAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            ),
                          );
                    },
                  );
                },
              ),
              const VerticalSeparator(height: 2),
              Center(
                  child: Text(
                'or',
                style: FontsGlobal.regulerTextStyle14.copyWith(color: Colors.white),
              )),
              const VerticalSeparator(height: 2),
              SecoundaryButton(
                text: 'Fingerprint',
                onPressed: () {
                  _authenticateWithBiometrics();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveNIKPassword() {
    if (isChecked) {
      sharedPrefClient.saveKey(
        key: SharedPrefKey.authEmail,
        data: emailTextController.text,
      );
      sharedPrefClient.saveKey(
        key: SharedPrefKey.authPassword,
        data: passwordTextController.text,
      );
    } else {
      sharedPrefClient.removeKey(key: SharedPrefKey.authEmail);
      sharedPrefClient.removeKey(key: SharedPrefKey.authPassword);
    }
  }

  void getDataRememberMe() {
    sharedPrefClient.getByKey(key: SharedPrefKey.authEmail).then((value) {
      emailTextController.text = value ?? '';
    });
    sharedPrefClient.getByKey(key: SharedPrefKey.authPassword).then((value) {
      passwordTextController.text = value ?? '';
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
        debugPrint('Masuk Sini 1');
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan Finger Print yang terdaftar di perangkat anda',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Masuk dengan Sidik Jari',
            cancelButton: 'Batal',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
        debugPrint('Success Auth');
        context.read<SignInBloc>().add(
              SignInWithNIKAndPassword(
                email: emailTextController.text,
                password: passwordTextController.text,
              ),
            );
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }
}
