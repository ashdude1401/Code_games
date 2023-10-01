class FirestoreDbFailure implements Exception {
  final String message;

  FirestoreDbFailure(
      [this.message =
          "An error occured while signing up, create a group or join a group, please try again later"]);

  //Handling the firebasefirestore exception
  factory FirestoreDbFailure.code(String code) {
    //handling the firebasefirestore exception
    switch (code) {
      case "permission-denied":
        return FirestoreDbFailure(
            "The user does not have permission to access the requested resource");
      case "unavailable":
        return FirestoreDbFailure(
            "The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.");
      case "cancelled":
        return FirestoreDbFailure(
            "The operation was cancelled (typically by the caller).");
      case "unknown":
        return FirestoreDbFailure(
            "Unknown error or an error from a different error domain.");

      default:
        return FirestoreDbFailure();
    }
  }
}
