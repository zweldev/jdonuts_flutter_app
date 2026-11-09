import 'package:flutter/widgets.dart';

class AppLocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (locale.languageCode != 'en' && locale.languageCode != 'my') {
      throw ArgumentError.value(locale, 'locale', 'Unsupported app locale.');
    }
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    super.key,
    required AppLocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
