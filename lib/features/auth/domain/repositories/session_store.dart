abstract interface class SessionStore {
  Future<String?> readUserId();
  Future<void> writeUserId(String userId);
  Future<void> clear();
}
