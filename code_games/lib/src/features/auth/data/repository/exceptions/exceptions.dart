class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message =
          "An error occured while signing up, please try again later"]);

  //Handling the firebase exception
  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    //Handling Sign up with email and password failure
    switch (code) {
      case "weak-password":
        return const SignUpWithEmailAndPasswordFailure(
            "The password provided is too weak");
      case "invalid-email":
        return const SignUpWithEmailAndPasswordFailure(
            "The email provided is invalid");
      case "email-already-in-use":
        return const SignUpWithEmailAndPasswordFailure(
            "The email is already in use by another account");
      case "operation-not-allowed":
        return const SignUpWithEmailAndPasswordFailure(
            "Email/password accounts are not enabled");
      case "too-many-requests":
        return const SignUpWithEmailAndPasswordFailure(
            "Too many requests to log into this account");
      case "user-disabled":
        return const SignUpWithEmailAndPasswordFailure(
            "The user corresponding to the given email has been disabled");
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}

class GoogleSignInFailure {
  final String message;

  const GoogleSignInFailure(
      [this.message =
          "An error occured while signing up, please try again later"]);

  factory GoogleSignInFailure.code(String code) {
    //Handling Google Sign in failure

    switch (code) {
      case "account-exists-with-different-credential":
        return const GoogleSignInFailure(
            "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.");
      case "invalid-credential":
        return const GoogleSignInFailure(
            "The credential used to authenticate the Admin SDKs cannot be used to perform the desired action.");
      default:
        return const GoogleSignInFailure();
    }
  }
}
