import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../core.dart';

abstract class AuthRemoteDataSource {
  Future<SignInEntity> signIn(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final SecureStorageClient secureStorageClient;

  AuthRemoteDataSourceImpl({required this.dioClient, required this.secureStorageClient});

  @override
  Future<SignInEntity> signIn(
    String email,
    String password,
  ) async {
    final response = await dioClient.login(
      url: UrlConstant.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final signInEntity = SignInEntity.fromJson(response.data);
      debugPrint('accessToken : ${signInEntity.data?.accessToken ?? ''}');
      await secureStorageClient.saveKey(SharedPrefKey.accessToken, 'vjt6zXah8LIe8UIH8BjgsiBAI9Q69DKo');
      await secureStorageClient.saveKey(SharedPrefKey.refreshToken, signInEntity.data!.refreshToken!);

      return signInEntity;
    } else {
      throw ServerException();
    }
  }
}
