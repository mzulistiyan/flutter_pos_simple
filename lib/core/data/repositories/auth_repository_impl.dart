import '../../../common/common.dart';
import '../../core.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SignInEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.signIn(
        email,
        password,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(''));
    }
  }
}
