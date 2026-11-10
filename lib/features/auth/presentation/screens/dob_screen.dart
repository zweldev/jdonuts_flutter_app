import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../domain/auth_constants.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../auth_failure_message.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import '../widgets/auth_step_scaffold.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({super.key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _year = TextEditingController();
  DateTime? _selectedDate;

  RegistrationCubit get _registration => context.read<RegistrationCubit>();

  @override
  void initState() {
    super.initState();
    final draft = context.read<RegistrationCubit>().state.draft;
    _selectedDate = draft.dateOfBirth;
    _setDateFields(_selectedDate);
  }

  @override
  void dispose() {
    _month.dispose();
    _day.dispose();
    _year.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    await _registration.submitDateOfBirth();
  }

  void _setDateFields(DateTime? date) {
    if (date == null) return;
    _month.text = date.month.toString();
    _day.text = date.day.toString();
    _year.text = date.year.toString();
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final latestAllowedDate = DateTime(now.year - minAge, now.month, now.day);
    final currentDate = _selectedDate;
    final initialDate =
        currentDate != null &&
            !currentDate.isAfter(latestAllowedDate) &&
            !currentDate.isBefore(DateTime(1900))
        ? currentDate
        : latestAllowedDate;
    var selectedDate = initialDate;
    final l10n = AppLocalizations.of(context);
    final date = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: SizedBox(
          height: 420,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.selectBirthday,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.close,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.iconPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  key: const ValueKey('dob_date_picker'),
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: DateTime(1900),
                  maximumDate: latestAllowedDate,
                  onDateTimeChanged: (value) => selectedDate = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    key: const ValueKey('dob_picker_select'),
                    onPressed: () => Navigator.pop(context, selectedDate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.select,
                      style: AppTextStyles.titleLarge.copyWith(
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || date == null) return;
    setState(() {
      _selectedDate = date;
      _setDateFields(date);
    });
    _registration.dateOfBirthChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final isValid =
            state.draft.dateOfBirth != null && state.dobError == null;
        return AuthStepScaffold(
          title: l10n.dobTitle,
          progress: 1,
          onBack: () => context.pop(),
          continueLabel: l10n.continueLabel,
          isContinueEnabled: isValid && !state.isLoading,
          isLoading: state.isLoading,
          onContinue: _continue,
          child: Column(
            children: [
              TextField(
                controller: _month,
                readOnly: true,
                onTap: _selectDateOfBirth,
                decoration: authInputDecoration(hint: l10n.dobMonthHint),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _day,
                readOnly: true,
                onTap: _selectDateOfBirth,
                decoration: authInputDecoration(hint: l10n.dobDayHint),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _year,
                readOnly: true,
                onTap: _selectDateOfBirth,
                decoration: authInputDecoration(hint: l10n.dobYearHint),
              ),
              if (state.dobError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _dobErrorText(l10n, state.dobError!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              if (state.failure != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      authFailureMessage(l10n, state.failure!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              if (state.failure is AlreadyRegistered)
                TextButton(
                  onPressed: () {
                    _registration.beginLogin();
                    context.go('/phone');
                  },
                  child: Text(l10n.logIn),
                ),
            ],
          ),
        );
      },
    );
  }
}

String _dobErrorText(AppLocalizations l10n, DobError error) => switch (error) {
  DobError.incomplete => l10n.dobIncomplete,
  DobError.inFuture => l10n.dobFuture,
  DobError.tooYoung => l10n.dobTooYoung(minAge),
};
