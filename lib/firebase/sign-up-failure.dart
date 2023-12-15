class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message = "An unknown error has occurred"]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
            'Please enter a stronger password');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure('Invalid email');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure('Email already in use');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure('Operation not allowed');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure('User is disabled');
      case '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
