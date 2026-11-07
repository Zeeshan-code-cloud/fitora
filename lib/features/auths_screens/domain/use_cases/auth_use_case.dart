import 'package:fitoraa/features/auths_screens/data/user_model.dart';
import 'package:fitoraa/features/auths_screens/domain/repository/user_repo.dart';
import 'package:fitoraa/widgets/failure.dart';
import 'package:fpdart/fpdart.dart';

class LoginUseCase {
  late final UserRepo userRepo;
  LoginUseCase({required this.userRepo});

  Future<Either<Failure, UserModel>>  call(UserModel userModel) async {
    return await userRepo.loginUser(userModel);
  }
 }

class RegisteredUseCase {
  late UserRepo userRepo;
  RegisteredUseCase({required this.userRepo});

  Future<Either<Failure,UserModel>> call(UserModel userModel) async {
    return await userRepo.registeredUser(userModel);
  }
}

// class RegisteredWithGoogle {
//   late UserRepo userRepo;
//   RegisteredWithGoogle({required this.userRepo});
//
//   Future<Either<Failure,UserModel>> call(UserModel userModel) async {
//     return await userRepo.registeredWithGoogle(userModel);
//   }
// }
class ForgetPasswordUseCase {
  late UserRepo userRepo;
  ForgetPasswordUseCase({required this.userRepo});

  Future<Either<Failure,String>> call(String email) async {
    return await userRepo.forgetPassword(email);
  }
}
class UpdateUserProfileUseCase {
  late UserRepo userRepo;
  UpdateUserProfileUseCase({required this.userRepo});

  Future<Either<Failure,String>> call(String name) async {
    return await userRepo.updateProfile(name);
  }
}

class LogOutUseCase{
  late UserRepo userRepo;
  LogOutUseCase({required this.userRepo});

  Future<Either<Failure, String>> call() async {
    return await userRepo.logOut();
  }
}

class GetCurrentUserSession {
  late UserRepo userRepo;
  GetCurrentUserSession({required this.userRepo});

  Future<Either<Failure, UserModel>> call(UserModel userModel)async {
    return await userRepo.getCurrentUserSession(userModel);
  }
}
class VerifiedEmail{
  late UserRepo userRepo;
  VerifiedEmail({required this.userRepo});

  Future<Either<Failure, String>> call(String email) async {
    return await userRepo.verifyEmail(email);
  }
}
class ResendVerificationEmail{
  late UserRepo userRepo;
  ResendVerificationEmail({required this.userRepo});

  Future<Either<Failure, String>> call(String email) async {
    return await userRepo.resendVerificationLink(email);
  }
}

class DeleteAccount{
  late UserRepo userRepo;
  DeleteAccount({required this.userRepo});
  Future<Either<Failure, String>> call() async {
    return await userRepo.deleteAccount();
  }
}

