import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../database/daos/cart_dao.dart';
import '../database/daos/home_dao.dart';
import '../database/daos/meta_dao.dart';
import '../database/daos/rewards_dao.dart';
import '../database/seed/seed_loader.dart';
import '../database/seed/seed_source.dart';
import '../features/auth/data/stores/secure_session_store.dart';
import '../features/auth/data/repositories/fake_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/repositories/session_store.dart';
import '../features/auth/domain/repositories/user_store.dart';
import '../features/members/domain/repositories/member_store.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(AppDatabase.new);
  }
  if (!getIt.isRegistered<MetaDao>()) {
    getIt.registerLazySingleton<MetaDao>(() => getIt<AppDatabase>().metaDao);
  }
  if (!getIt.isRegistered<HomeDao>()) {
    getIt.registerLazySingleton<HomeDao>(() => HomeDao(getIt<AppDatabase>()));
  }
  if (!getIt.isRegistered<CartDao>()) {
    getIt.registerLazySingleton<CartDao>(() => CartDao(getIt<AppDatabase>()));
  }
  if (!getIt.isRegistered<RewardsDao>()) {
    getIt.registerLazySingleton<RewardsDao>(
      () => RewardsDao(getIt<AppDatabase>()),
    );
  }
  if (!getIt.isRegistered<SeedSource>()) {
    getIt.registerLazySingleton<SeedSource>(() => const AssetSeedSource());
  }
  if (!getIt.isRegistered<SeedLoader>()) {
    getIt.registerLazySingleton<SeedLoader>(
      () => SeedLoader(
        getIt<AppDatabase>(),
        getIt<SeedSource>(),
        getIt<MetaDao>(),
      ),
    );
  }
  if (!getIt.isRegistered<UserStore>()) {
    getIt.registerLazySingleton<UserStore>(() => getIt<AppDatabase>().userDao);
  }
  if (!getIt.isRegistered<MemberStore>()) {
    getIt.registerLazySingleton<MemberStore>(
      () => getIt<AppDatabase>().memberDao,
    );
  }
  if (!getIt.isRegistered<SessionStore>()) {
    getIt.registerLazySingleton<SessionStore>(SecureSessionStore.new);
  }
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => FakeAuthRepository(
        userStore: getIt<UserStore>(),
        sessionStore: getIt<SessionStore>(),
      ),
    );
  }
}
