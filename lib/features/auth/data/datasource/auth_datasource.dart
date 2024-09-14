import 'package:application/core/errors/failure.dart';
import 'package:application/core/success/success.dart';

abstract interface class AuthenticateUserDataSource{
  Future<Success> authenticationRequest();
}

class AuthenticateUserDataSourceImpl extends AuthenticateUserDataSource {
  final String url;
  final String username;
  final String password;
  AuthenticateUserDataSourceImpl({required this.url , required this.username , required this.password});
  
  @override
  Future<Success> authenticationRequest() async {
    try {
       
    } catch (e) {
      throw const Failure(errorMessage: "Something Went Wrong", statusCode: "200"); 
    }
     return const Success(message: "Success", statusCode: "202", token: "hello");
  }

  
}