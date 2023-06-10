part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserSigningIn extends UserState {}

class UserSignedIn extends UserState {
  final User? user;

  UserSignedIn(this.user);
}

class OtpLoading extends UserState {}
class OtpVerified extends UserState {
  final UserCredential userCredential;

  OtpVerified(this.userCredential);
}

class OtpFailed extends UserState {
  final String error;

  OtpFailed(this.error);
}


class OtpSent extends UserState {
  final String verificationId;
  final int? resendToken;

  OtpSent(this.verificationId, this.resendToken);
}

class UserSignInFailed extends UserState {
  final String error;

  UserSignInFailed(this.error);
}
