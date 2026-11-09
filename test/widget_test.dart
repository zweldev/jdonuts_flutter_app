import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';
import 'package:jdonuts_flutter_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/auth_constants.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/session_store.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/user_store.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/result.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/validators/auth_validators.dart';
import 'package:jdonuts_flutter_app/features/members/domain/entities/member.dart';
import 'package:jdonuts_flutter_app/features/members/domain/repositories/member_store.dart';
import 'package:jdonuts_flutter_app/features/members/domain/tier_progress.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/registration_state.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:jdonuts_flutter_app/di/service_locator.dart';
import 'package:jdonuts_flutter_app/main.dart';

Future<void> _pumpAppWithRepository(
  WidgetTester tester,
  AuthRepository repository,
) async {
  getIt.pushNewScope(scopeName: 'widget-test');
  getIt.registerSingleton<AuthRepository>(repository);
  if (repository is _MemoryAuthRepository) {
    getIt.registerSingleton<UserStore>(repository.userStore);
    getIt.registerSingleton<MemberStore>(repository.memberStore);
    getIt.registerSingleton<SessionStore>(repository.sessionStore);
  }
  await tester.pumpWidget(const MyApp());
}

void main() {
  tearDown(() async {
    if (getIt.currentScopeName == 'widget-test') {
      await getIt.popScope();
    }
  });

  group('phone validation', () {
    test(
      'normalizes supported Myanmar phone formats and rejects edge cases',
      () {
        expect(normalizePhoneNumber('+95 0925-413-5592'), '9254135592');
        expect(
          '$phoneCountryPrefix${normalizePhoneNumber('09254135592')}',
          '+959254135592',
        );
        expect(normalizePhoneNumber('0 925-413-5592'), '9254135592');
        expect(validatePhoneNumber('+95 0925-413-5592'), isNull);
        expect(validatePhoneNumber('0925 413 5592'), isNull);
        expect(validatePhoneNumber('9254135592'), isNull);
        expect(validatePhoneNumber('009254135592'), PhoneError.invalid);
        expect(validatePhoneNumber('9254135'), PhoneError.invalid);
        expect(validatePhoneNumber('91234567890'), PhoneError.invalid);
        expect(validatePhoneNumber('92541abc592'), PhoneError.invalid);
        expect(validatePhoneNumber('   '), PhoneError.empty);
        expect(validatePhoneNumber('12345'), PhoneError.invalid);
      },
    );
  });

  group('registration validation', () {
    test('requires a valid name and allows Myanmar script', () {
      expect(validateName('  Ye Min  ', isRequired: true), isNull);
      expect(validateName('မောင်', isRequired: true), isNull);
      expect(
        validateName('Aung2', isRequired: true),
        NameError.invalidCharacters,
      );
      expect(
        validateName('Aung'.padRight(51, 'a'), isRequired: true),
        NameError.tooLong,
      );
      expect(validateName('   ', isRequired: true), NameError.required);
      expect(validateName('', isRequired: true), NameError.required);
      expect(validateName('', isRequired: false), isNull);
    });

    test('validates calendar dates, age, and leap years', () {
      expect(
        validateDateOfBirth(DateTime(2000, 2, 29), now: DateTime(2026, 1)),
        isNull,
      );
      expect(
        validateDateOfBirth(null, now: DateTime(2026, 1)),
        DobError.incomplete,
      );
      expect(
        validateDateOfBirth(DateTime(2015, 5, 1), now: DateTime(2026, 1)),
        DobError.tooYoung,
      );
      expect(
        validateDateOfBirth(DateTime(2013, 1, 1), now: DateTime(2026, 1, 1)),
        isNull,
      );
      expect(
        validateDateOfBirth(DateTime(2013, 1, 2), now: DateTime(2026, 1, 1)),
        DobError.tooYoung,
      );
      expect(
        validateDateOfBirth(DateTime(2027, 1, 2), now: DateTime(2026, 1, 1)),
        DobError.inFuture,
      );
    });
  });

  test(
    'registered users persist a user ID and restore their session',
    () async {
      final repository = _createRepository();
      final user = AuthUser(
        phoneNumber: '+959254135592',
        firstName: 'Ye Min',
        lastName: '',
        dateOfBirth: DateTime(2000, 5, 1),
      );
      expect(await repository.register(user), isA<Success<void>>());
      final registeredUser = await repository.userStore.findByPhone(
        user.phoneNumber,
      );
      expect(registeredUser?.copyWith(id: null), user);
      expect(await repository.sessionStore.readUserId(), registeredUser?.id);
      expect(await repository.requestOtp(), isA<Success<void>>());
      expect(
        await repository.verifyOtp('+959254135592', fakeOtpCode),
        isA<Success<void>>(),
      );
      expect(
        await repository.signIn('+959254135592'),
        isA<Success<AuthUser>>(),
      );
      expect(
        (await repository.restoreSession() as Success<bool>).value,
        isTrue,
      );

      expect(await repository.signOut(), isA<Success<void>>());
      expect(await repository.sessionStore.readUserId(), isNull);
      expect(
        (await repository.restoreSession() as Success<bool>).value,
        isFalse,
      );
    },
  );

  test('clears a session when its account no longer exists', () async {
    final repository = _createRepository(sessionPhone: '+959254135592');

    expect((await repository.restoreSession() as Success<bool>).value, isFalse);
    expect(await repository.sessionStore.readUserId(), isNull);
  });

  test(
    'fake login rejects unknown phone numbers after OTP verification',
    () async {
      final repository = _createRepository();

      expect(await repository.requestOtp(), isA<Success<void>>());
      expect(
        await repository.verifyOtp('+959254135592', fakeOtpCode),
        isA<Success<void>>(),
      );
      final result = await repository.signIn('+959254135592');

      expect(result, isA<Failure<AuthUser>>());
      expect((result as Failure<AuthUser>).error, isA<UserNotFound>());
    },
  );

  test('registration state supports value equality and clearing errors', () {
    const state = RegistrationState(phoneError: PhoneError.invalid);
    expect(state, const RegistrationState(phoneError: PhoneError.invalid));
    expect(state.copyWith(phoneError: null).phoneError, isNull);
  });

  test('OTP entry locks after three incorrect codes', () async {
    final repository = _createRepository();
    final sessionCubit = SessionCubit(repository);
    final registrationCubit = RegistrationCubit(repository, sessionCubit);
    registrationCubit.beginRegistration();
    registrationCubit.phoneChanged('09254135592');
    expect(await registrationCubit.submitPhone(), isTrue);
    final otpCubit = OtpCubit(repository, registrationCubit, sessionCubit);

    await otpCubit.submit('000000');
    await otpCubit.submit('000000');
    await otpCubit.submit('000000');

    expect(otpCubit.state.attempts, maxOtpAttempts);
    expect(otpCubit.state.isLocked, isTrue);
    expect(await otpCubit.submit(fakeOtpCode), isFalse);

    await otpCubit.close();
    await registrationCubit.close();
    await sessionCubit.close();
  });

  test(
    'login saves the existing user ID only after OTP verification',
    () async {
      final user = AuthUser(
        phoneNumber: '+959254135592',
        firstName: 'Ye Min',
        lastName: '',
        dateOfBirth: DateTime(2000, 5, 1),
      );
      final repository = _createRepository(initialUsers: [user]);

      expect(await repository.requestOtp(), isA<Success<void>>());
      expect(await repository.sessionStore.readUserId(), isNull);
      expect(
        await repository.verifyOtp(user.phoneNumber, fakeOtpCode),
        isA<Success<void>>(),
      );
      final result = await repository.signIn(user.phoneNumber);

      expect(result, isA<Success<AuthUser>>());
      expect(await repository.sessionStore.readUserId(), 'user-1');
    },
  );

  test('correct OTP is accepted during registration', () async {
    final repository = _createRepository();
    final sessionCubit = SessionCubit(repository);
    final registrationCubit = RegistrationCubit(repository, sessionCubit);
    registrationCubit.beginRegistration();
    registrationCubit.phoneChanged('09254135592');
    expect(await registrationCubit.submitPhone(), isTrue);
    final otpCubit = OtpCubit(repository, registrationCubit, sessionCubit);

    expect(await otpCubit.submit(fakeOtpCode), isTrue);
    expect(registrationCubit.state.failure, isNull);

    await otpCubit.close();
    await registrationCubit.close();
    await sessionCubit.close();
  });

  test('OTP countdown enables resend and resend unlocks attempts', () async {
    final repository = _createRepository();
    final sessionCubit = SessionCubit(repository);
    final registrationCubit = RegistrationCubit(repository, sessionCubit);
    registrationCubit.beginRegistration();
    registrationCubit.phoneChanged('09254135592');
    expect(await registrationCubit.submitPhone(), isTrue);
    final otpCubit = OtpCubit(
      repository,
      registrationCubit,
      sessionCubit,
      tickDuration: const Duration(milliseconds: 1),
    );
    await otpCubit.submit('000000');
    await otpCubit.submit('000000');
    await otpCubit.submit('000000');

    final countdownFinished = otpCubit.stream.firstWhere(
      (state) => state.secondsUntilResend == 0,
    );
    otpCubit.startCountdown();
    await countdownFinished.timeout(const Duration(seconds: 5));

    expect(otpCubit.state.secondsUntilResend, 0);
    expect(await otpCubit.resend(), isTrue);
    expect(otpCubit.state.attempts, 0);
    expect(otpCubit.state.isLocked, isFalse);
    expect(otpCubit.state.secondsUntilResend, otpResendSeconds);

    await otpCubit.close();
    await registrationCubit.close();
    await sessionCubit.close();
  });

  test('double phone submit sends one OTP request', () async {
    final repository = _BlockingAuthRepository();
    final sessionCubit = SessionCubit(repository);
    final registrationCubit = RegistrationCubit(repository, sessionCubit);
    registrationCubit.beginRegistration();
    registrationCubit.phoneChanged('09254135592');

    final firstRequest = registrationCubit.submitPhone();
    final secondRequest = registrationCubit.submitPhone();
    expect(repository.requestCalls, 1);
    repository.requestResult.complete(const Success<void>(null));
    await Future.wait([firstRequest, secondRequest]);

    expect(registrationCubit.state.isRegistration, isTrue);
    await registrationCubit.close();
    await sessionCubit.close();
  });

  test('name submission keeps the profile draft until date of birth', () async {
    final repository = _createRepository(
      latency: const Duration(milliseconds: 30),
    );
    final sessionCubit = SessionCubit(repository);
    final registrationCubit = RegistrationCubit(repository, sessionCubit);
    registrationCubit.beginRegistration();
    registrationCubit.phoneChanged('09254135592');
    registrationCubit.markOtpVerified();
    registrationCubit.nameChanged('Aung', 'Win');

    final submission = registrationCubit.submitName();
    expect(registrationCubit.state.isLoading, isFalse);
    expect(await registrationCubit.submitName(), isFalse);
    expect(await submission, isTrue);
    expect(registrationCubit.state.isLoading, isFalse);
    expect(registrationCubit.state.nameCompleted, isTrue);

    await registrationCubit.close();
    await sessionCubit.close();
  });

  test(
    'registration draft retains fields when moving back through steps',
    () async {
      final repository = _createRepository();
      final sessionCubit = SessionCubit(repository);
      final registrationCubit = RegistrationCubit(
        repository,
        sessionCubit,
        now: () => DateTime(2026, 1, 1),
      );
      final otpCubit = OtpCubit(repository, registrationCubit, sessionCubit);
      registrationCubit.beginRegistration();
      registrationCubit.phoneChanged('09254135592');
      expect(await registrationCubit.submitPhone(), isTrue);
      otpCubit.startCountdown();
      otpCubit.leaveStep();
      expect(registrationCubit.state.draft.phone, '09254135592');

      expect(await registrationCubit.submitPhone(), isTrue);
      otpCubit.startCountdown();
      await otpCubit.submit(fakeOtpCode);
      otpCubit.leaveStep();
      registrationCubit.nameChanged('Aung', 'Win');
      await registrationCubit.submitName();
      registrationCubit.dateOfBirthChanged(DateTime(2000, 5, 1));

      expect(registrationCubit.state.draft.firstName, 'Aung');
      expect(registrationCubit.state.draft.lastName, 'Win');
      expect(registrationCubit.state.draft.dateOfBirth, DateTime(2000, 5, 1));
      await otpCubit.close();
      await registrationCubit.close();
      await sessionCubit.close();
    },
  );

  testWidgets('onboarding shows the provided background and social icons', (
    tester,
  ) async {
    await _pumpAppWithRepository(tester, _createRepository());
    await tester.pumpAndSettle();

    expect(find.text('Round food for\nevery mood'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(3));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/onboarding/onboarding_bg.png',
      ),
      findsOneWidget,
    );
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
  });

  testWidgets('phone continue requires validity and blur shows an error', (
    tester,
  ) async {
    await _pumpAppWithRepository(tester, _createRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField).first, '123');
    await tester.pump();
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    expect(
      find.text('Enter a valid phone number after $phoneCountryPrefix.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField).first, '09254135592');
    await tester.pump();
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('registration continues through verification and profile setup', (
    tester,
  ) async {
    await _pumpAppWithRepository(tester, _createRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '09254135592');
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    expect(find.text('Verify your number'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      '09254135592',
    );
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(Pinput),
        matching: find.byType(EditableText),
      ),
      '123456',
    );
    await tester.pump();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();
    expect(find.text("What's your\nname?"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Pinput>(find.byType(Pinput)).controller!.text,
      fakeOtpCode,
    );
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONTINUE'));
    await tester.pump();
    expect(find.text('Please enter your first name.'), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField).at(0), 'Ye Min');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    expect(find.text("What's your\ndate of birth?"), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );

    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('dob_date_picker')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('dob_picker_select')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      isNotEmpty,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      isNotEmpty,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
      isNotEmpty,
    );
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to the\nworld of J’donuts'), findsOneWidget);
    await tester.tap(find.text("LET'S EXPLORE"));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Log out'), findsOneWidget);
    expect(find.text('Ye Min'), findsOneWidget);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Round food for\nevery mood'), findsOneWidget);
  });

  testWidgets('wrong OTP shows an error and clears the entry', (tester) async {
    await _pumpAppWithRepository(tester, _createRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '09254135592');
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(Pinput),
        matching: find.byType(EditableText),
      ),
      '000000',
    );
    await tester.pump();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();

    expect(
      find.text('That code is incorrect. Please try again.'),
      findsOneWidget,
    );
    expect(
      tester.widget<Pinput>(find.byType(Pinput)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('unknown login offers registration after OTP verification', (
    tester,
  ) async {
    await _pumpAppWithRepository(tester, _createRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '09254135592');
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    expect(find.text('Verify your number'), findsOneWidget);
    await tester.enterText(
      find.descendant(
        of: find.byType(Pinput),
        matching: find.byType(EditableText),
      ),
      fakeOtpCode,
    );
    await tester.pump();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();

    expect(
      find.text('No account found. Register to get started.'),
      findsOneWidget,
    );
    expect(find.text('Register a new account'), findsOneWidget);
    expect(find.text('Verify your number'), findsOneWidget);
  });

  testWidgets('registration starts OTP before looking up an existing user', (
    tester,
  ) async {
    final user = AuthUser(
      phoneNumber: '+959254135592',
      firstName: 'Ye Min',
      lastName: '',
      dateOfBirth: DateTime(2000, 5, 1),
    );
    await _pumpAppWithRepository(
      tester,
      _createRepository(initialUsers: [user]),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '09254135592');
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    expect(find.text('Verify your number'), findsOneWidget);
    await tester.enterText(
      find.descendant(
        of: find.byType(Pinput),
        matching: find.byType(EditableText),
      ),
      fakeOtpCode,
    );
    await tester.pump();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();
    expect(find.text("What's your\nname?"), findsOneWidget);
  });

  testWidgets('registered login skips registration profile steps', (
    tester,
  ) async {
    final user = AuthUser(
      phoneNumber: '+959254135592',
      firstName: 'Ye Min',
      lastName: '',
      dateOfBirth: DateTime(2000, 5, 1),
    );
    await _pumpAppWithRepository(
      tester,
      _createRepository(initialUsers: [user]),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '09254135592');
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(Pinput),
        matching: find.byType(EditableText),
      ),
      fakeOtpCode,
    );
    await tester.pump();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Log out'), findsOneWidget);
    expect(find.text("What's your\nname?"), findsNothing);
    expect(find.text("What's your\ndate of birth?"), findsNothing);
    expect(find.text('Welcome to the\nworld of J’donuts'), findsNothing);
  });

  testWidgets('restored login goes directly to Home', (tester) async {
    final user = AuthUser(
      phoneNumber: '+959254135592',
      firstName: 'Ye Min',
      lastName: '',
      dateOfBirth: DateTime(2000, 5, 1),
    );
    final repository = _createRepository(
      initialUsers: [user],
      sessionPhone: 'user-1',
    );

    await _pumpAppWithRepository(tester, repository);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Log out'), findsOneWidget);
    expect(find.text('Ye Min'), findsOneWidget);
    expect(find.text('Welcome to the\nworld of J’donuts'), findsNothing);
  });
}

_MemoryAuthRepository _createRepository({
  List<AuthUser> initialUsers = const [],
  String? sessionPhone,
  Duration latency = Duration.zero,
}) {
  return _MemoryAuthRepository(
    initialUsers: initialUsers,
    sessionPhone: sessionPhone,
    latency: latency,
  );
}

class _MemoryAuthRepository extends FakeAuthRepository {
  factory _MemoryAuthRepository({
    List<AuthUser> initialUsers = const [],
    String? sessionPhone,
    Duration latency = Duration.zero,
  }) {
    final memberStore = _MemoryMemberStore();
    final userStore = _MemoryUserStore(initialUsers, memberStore);
    final sessionStore = _MemorySessionStore(sessionPhone);
    return _MemoryAuthRepository._(
      userStore,
      sessionStore,
      memberStore,
      latency,
    );
  }

  _MemoryAuthRepository._(
    this.userStore,
    this.sessionStore,
    this.memberStore,
    Duration latency,
  ) : super(userStore: userStore, sessionStore: sessionStore, latency: latency);

  final _MemoryUserStore userStore;
  final _MemorySessionStore sessionStore;
  final _MemoryMemberStore memberStore;
}

class _MemoryUserStore implements UserStore {
  _MemoryUserStore(Iterable<AuthUser> initialUsers, this._memberStore) {
    var index = 0;
    for (final user in initialUsers) {
      final phone = canonicalPhoneNumber(user.phoneNumber);
      final storedUser = user.copyWith(
        id: user.id ?? 'user-${++index}',
        phoneNumber: phone,
      );
      _storeUser(storedUser);
    }
  }

  final _MemoryMemberStore _memberStore;
  final Map<String, AuthUser> _usersById = {};
  final Map<String, AuthUser> _usersByPhone = {};

  @override
  Future<AuthUser?> findById(String userId) async => _usersById[userId];

  @override
  Future<AuthUser?> findByPhone(String phoneNumber) async =>
      _usersByPhone[canonicalPhoneNumber(phoneNumber)];

  @override
  Future<String> register(AuthUser user) async {
    if (_usersByPhone.containsKey(user.phoneNumber)) {
      throw const AlreadyRegisteredException();
    }
    final userId = 'user-${_usersById.length + 1}';
    _storeUser(user.copyWith(id: userId));
    return userId;
  }

  void _storeUser(AuthUser user) {
    final userId = user.id ?? (throw StateError('Test user needs an ID.'));
    _usersById[userId] = user;
    _usersByPhone[user.phoneNumber] = user;
    _saveMember(user, userId);
  }

  void _saveMember(AuthUser user, String userId) {
    _memberStore.members[userId] = Member(
      id: 'member-$userId',
      userId: userId,
      name: [
        user.firstName,
        user.lastName,
      ].where((part) => part.isNotEmpty).join(' '),
      tierId: 'silver',
      totalPoints: 0,
      rewardsBadgeCount: 0,
      tierProgress: calculateTierProgress(
        tierId: 'silver',
        totalPoints: 0,
        tiers: _testTiers,
      ),
    );
  }
}

const _testTiers = [
  Tier(id: 'bronze', name: 'Bronze', minPoints: 0, sortOrder: 0),
  Tier(id: 'silver', name: 'Silver', minPoints: 500, sortOrder: 1),
  Tier(id: 'gold', name: 'Gold', minPoints: 1000, sortOrder: 2),
  Tier(id: 'platinum', name: 'Platinum', minPoints: 1500, sortOrder: 3),
];

class _MemoryMemberStore implements MemberStore {
  final Map<String, Member> members = {};

  @override
  Future<Member?> findByUserId(String userId) async => members[userId];
}

class _MemorySessionStore implements SessionStore {
  _MemorySessionStore(this.phoneNumber);

  String? phoneNumber;

  @override
  Future<String?> readUserId() async => phoneNumber;

  @override
  Future<void> writeUserId(String userId) async => phoneNumber = userId;

  @override
  Future<void> clear() async => phoneNumber = null;
}

class _BlockingAuthRepository extends FakeAuthRepository {
  _BlockingAuthRepository()
    : super(
        userStore: _MemoryUserStore(const [], _MemoryMemberStore()),
        sessionStore: _MemorySessionStore(null),
        latency: Duration.zero,
      );

  final requestResult = Completer<Result<void>>();
  int requestCalls = 0;

  @override
  Future<Result<void>> requestOtp() {
    requestCalls++;
    return requestResult.future;
  }
}
