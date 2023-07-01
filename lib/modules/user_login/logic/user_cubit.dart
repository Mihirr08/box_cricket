import 'package:bloc/bloc.dart';
import 'package:box_cricket/modules/owner/logic/owner_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'user_state.dart';

class UserAuthCubit extends Cubit<UserState> {
  UserAuthCubit() : super(UserInitial());

  Future<void> googleSignIn() async {
    emit(UserSigningIn());

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        emit(UserSignedIn(user));
      } else {
        emit(UserSignInFailed("Unable to sign in"));
      }
    } on FirebaseAuthException catch (e) {
      print("Error is ${e.toString()}");
      String errorString = e.message.toString();
      if (e.code == 'account-exists-with-different-credential') {
        errorString = "Account exists";
      } else if (e.code == 'invalid-credential') {
        errorString = "Invalid Credentials";
      }
      emit(UserSignInFailed(errorString));
    } catch (e) {
      print("Error is ${e.toString()}");
      emit(UserSignInFailed(e.toString()));
      // handle the error here
    }
  }


  Future isOwnerRegistered(String phoneNumber) async{
    emit(OtpLoading());
    bool isRegistered = await OwnerProvider().checkIsOwnerRegistered(phoneNumber) ?? false;
    emit(OtpRegisteredOrNot(isRegistered));
  }

  Future sendPhoneOtp(String phoneNumber, {int? resendToken}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    emit(OtpLoading());
    try {

      bool isRegistered =
          await OwnerProvider().checkIsOwnerRegistered(phoneNumber) ?? false;

      if (isRegistered) {
        throw Exception("User is already registered");
      }

      await auth.verifyPhoneNumber(
          forceResendingToken: resendToken,
          phoneNumber: "+91$phoneNumber",
          verificationCompleted: (PhoneAuthCredential cred) {},
          verificationFailed: (FirebaseAuthException error) {
            emit(OtpFailed(error?.message ?? ""));
          },
          codeSent: (String verificationId, int? resendToken) {
            emit(OtpSent(verificationId, resendToken));
          },
          codeAutoRetrievalTimeout: (value) {
            print("Time out is $value");
          });
    } catch (e) {
      emit(OtpFailed(e.toString()));
    }
  }

  Future verifyOtp(
      {required String verificationId,
      required String code}) async {
    emit(OtpLoading());
    try {

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      emit(OtpVerified(userCredential));
    } catch (e) {
      emit(OtpFailed(e.toString()));
    }
  }
}
