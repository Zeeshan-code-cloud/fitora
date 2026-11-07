import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoraa/features/auths_screens/data/user_model.dart';
import 'package:fitoraa/features/auths_screens/domain/repository/user_repo.dart';
import 'package:fitoraa/widgets/failure.dart';
import 'package:fpdart/fpdart.dart';

class UserRepoImple implements UserRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
   UserRepoImple({
    required this.auth,
    required this.firestore,
   });

  @override
  Future<Either<Failure, String>> forgetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return right("reset password link  send to the  email");
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUser(UserModel userModel) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      if (userCredential.user != null) {
        final doc = await firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .get();
        final updateModel = UserModel.fromJson(doc.data()!);
        return right(updateModel);
      } else {
        return left(Failure(errorMessage: "user not found"));
      }
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> registeredUser(UserModel userModel) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      if (userCredential.user != null) {
        userModel.id = userCredential.user!.uid;
        await userCredential.user!.sendEmailVerification();
        await firestore
            .collection("users")
            .doc(userModel.id)
            .set(userModel.toJson());
        return right(userModel);
      } else {
        return left(Failure(errorMessage: "user not found"));
      }
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile(String name) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(Failure(errorMessage: "user not found"));
      } else {
        final doc = await firestore
            .collection("users")
            .doc(currentUser.uid)
            .update({"full_name": name.trim()});
        return right("profile updated");
      }
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmail(String email) async {
    try {
      final currentUser = auth.currentUser;
      await currentUser?.reload();
      if (currentUser!.emailVerified == true) {
        return right("email verified");
      } else {
        return left(Failure(errorMessage: "not verified"));
      }
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logOut() async {
    try {
      await auth.signOut();
      return right("Logged out");
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUserSession(
    UserModel userModel,
  ) async {
    try {
      final currentUser = auth.currentUser;

      if (currentUser == null) {
        return left(
          Failure(
            errorMessage: "no active session",
            errorCode: "Session Sign out",
          ),
        );
      }
      if (currentUser.emailVerified == false) {
        return left(Failure(errorMessage: "user not found"));
      } else {
        final doc = await firestore
            .collection("users")
            .doc(currentUser.uid)
            .get();
        if (doc.exists) {
          final user = UserModel.fromJson(doc.data()!);
          return right(user);
        } else {
          return left(Failure(errorMessage: "user not found"));
        }
      }
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, UserModel>> registeredWithGoogle(UserModel userModel,) async {
  //   try {
  //
  //     // Override the default instance with the explicit serverClientId
  //     GoogleSignInAccount account = await googleSignIn.authenticate();
  //     final credential = GoogleAuthProvider.credential(
  //       idToken: account.authentication.idToken,
  //     );
  //     final userCredential = await auth.signInWithCredential(credential);
  //     if (userCredential.user == null) {
  //       return left(Failure(errorMessage: "user not found"));
  //     }
  //
  //     final updatedUser = UserModel(
  //       fullName: userCredential.user!.displayName.toString(),
  //       email: userCredential.user!.email.toString(),
  //       password: "",
  //       createdAt: DateTime.now(),
  //     );
  //
  //     await firestore.collection("users").doc(userCredential.user!.uid).set(
  //       updatedUser.toJson(),
  //     );
  //     return right(updatedUser);
  //   } catch (e, st) {
  //     print("GOOGLE ERROR TYPE: ${e.runtimeType}");
  //     print("GOOGLE ERROR: $e");
  //     print(st);
  //     return left(Failure(errorMessage: e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, String>> resendVerificationLink(String email) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return left(Failure(errorMessage: "user not found"));
      } else {
        await user.sendEmailVerification();
        return right("email sent");
      }
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount() async{
     try{
       final user = auth.currentUser;

       if (user == null) {
         return left(
           Failure(errorMessage: 'No user is currently signed in.'),
         );
       }

       final String uid = user.uid;

       // Delete the user's Firestore document.
       await FirebaseFirestore.instance
           .collection('users')
           .doc(uid)
           .delete();

       await auth.currentUser!.delete();
       return right("deleted");
     }
     catch (e){
       return left(Failure(errorMessage: e.toString()));
     }
  }

}
