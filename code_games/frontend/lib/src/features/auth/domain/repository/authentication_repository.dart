abstract class AuthenticationRepository {
  //To create a new user with email and password
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {}

  //Make user login with valid email and password
  Future<void> loginWithTheEmailAndPassword(
      String email, String password) async {}

  //To logout the user
  Future<void> logout() async {}
}
