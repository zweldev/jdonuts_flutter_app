import 'package:get_it/get_it.dart';

import '../features/auth/data/repositories/fake_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
  }
}
