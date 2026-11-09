import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/repositories/member_store.dart';
import '../../domain/repositories/session_store.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/session_cubit.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({
    super.key,
    required this.memberStore,
    required this.sessionStore,
  });

  final MemberStore memberStore;
  final SessionStore sessionStore;

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  late final Future<Member?> _member = _loadMember();

  Future<Member?> _loadMember() async {
    final userId = await widget.sessionStore.readUserId();
    if (userId == null) return null;
    return widget.memberStore.findByUserId(userId);
  }

  Future<void> _signOut() async {
    context.read<OtpCubit>().reset();
    context.read<RegistrationCubit>().resetFlow();
    await context.read<SessionCubit>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder<Member?>(
          future: _member,
          builder: (context, snapshot) => _buildMemberContent(snapshot, l10n),
        ),
      ),
    );
  }

  Widget _buildMemberContent(
    AsyncSnapshot<Member?> snapshot,
    AppLocalizations l10n,
  ) {
    final name = snapshot.data?.name;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.homeTitle),
        if (snapshot.hasError)
          Text(l10n.storageFailure)
        else if (snapshot.connectionState == ConnectionState.done)
          Text(name ?? l10n.userNotFound),
        TextButton(onPressed: _signOut, child: Text(l10n.logout)),
      ],
    );
  }
}
