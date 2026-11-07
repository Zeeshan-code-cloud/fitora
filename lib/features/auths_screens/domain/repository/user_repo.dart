import 'package:fitoraa/features/auths_screens/data/user_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../widgets/failure.dart';

abstract class UserRepo {
  Future<Either<Failure,UserModel>> registeredUser(UserModel userModel) async {
    return right(userModel);
  }

  Future<Either<Failure,UserModel>> loginUser(UserModel userModel) async {
    return right(userModel);
  }

  Future<Either<Failure, String>> forgetPassword(String email) async{
    return right(email);
  }

  Future<Either<Failure, String>> verifyEmail(String email) async{
    return right(email);
  }
  Future<Either<Failure, String>> resendVerificationLink(String email) async{
    return right(email);
  }

  Future<Either<Failure, String>> updateProfile(String email) async{
    return right(email);
  }

  Future<Either<Failure,String>> logOut() async{
    return right("Logged out");
  }

  Future<Either<Failure, UserModel>> getCurrentUserSession(UserModel userModel) async {
    return right(userModel);
  }


  Future<Either<Failure, String>> deleteAccount()async{
    return right("deleted");
  }



}