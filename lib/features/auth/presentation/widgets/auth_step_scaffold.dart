import 'package:flutter/material.dart';

class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    required this.title,
    required this.progress,
    required this.child,
    required this.onBack,
    required this.continueLabel,
    required this.isContinueEnabled,
    required this.isLoading,
    required this.onContinue,
    super.key,
  });

  final String title;
  final double progress;
  final Widget child;
  final VoidCallback onBack;
  final String continueLabel;
  final bool isContinueEnabled;
  final bool isLoading;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F9),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFEAF2), Color(0xFFFFF9FB)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(9),
                        onTap: onBack,
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.arrow_back,
                            color: Color(0xFF282B33),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    AuthProgressBadge(progress: progress),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF282B33),
                    fontSize: 27,
                    height: 1.14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 16),
                child,
                const SizedBox(height: 28),
                AuthPrimaryButton(
                  label: continueLabel,
                  onPressed: isContinueEnabled ? onContinue : null,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF55C9E0),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF9BDDEA),
          disabledForegroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
      ),
    );
  }
}

class AuthProgressBadge extends StatelessWidget {
  const AuthProgressBadge({
    required this.progress,
    this.isComplete = false,
    super.key,
  });

  final double progress;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 29,
      height: 29,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: const Color(0xFF9BE5F0),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFEF4F9B)),
          ),
          if (isComplete || progress >= 1)
            const Icon(Icons.check, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}

InputDecoration authInputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9AA1AB), fontSize: 15),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFF8BDDEC), width: 1.3),
    ),
  );
}
