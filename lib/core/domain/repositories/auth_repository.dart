import 'package:dartz/dartz.dart';
import '../../../common/common.dart';
import '../../core.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignInEntity>> signIn({
    required String email,
    required String password,
  });
}
