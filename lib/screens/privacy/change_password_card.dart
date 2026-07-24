import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/validators.dart';
import '../widgets/privacy/common/custom_card.dart';
import '../widgets/privacy/common/custom_text_field.dart';
import '../widgets/privacy/common/primary_button.dart';

class ChangePasswordCard extends StatefulWidget {
  final Future<void> Function(
    String currentPassword,
    String newPassword,
  )? onUpdatePassword;

  const ChangePasswordCard({
    super.key,
    this.onUpdatePassword,
  });

  @override
  State<ChangePasswordCard> createState() =>
      _ChangePasswordCardState();
}

class _ChangePasswordCardState
    extends State<ChangePasswordCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _currentController =
      TextEditingController();

  final TextEditingController _newController =
      TextEditingController();

  final TextEditingController _confirmController =
      TextEditingController();

  late final AnimationController _arrowController;

  bool _expanded = false;
  bool _loading = false;

  PasswordStrength _passwordStrength =
      PasswordStrength.none;

  AppLocalizations get _localizations =>
      AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250,
      ),
    );

    _newController.addListener(
      _checkPasswordStrength,
    );
  }

  @override
  void dispose() {
    _newController.removeListener(
      _checkPasswordStrength,
    );

    _arrowController.dispose();
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      _expanded = !_expanded;
    });

    if (_expanded) {
      _arrowController.forward();
    } else {
      _arrowController.reverse();
    }
  }

  void _checkPasswordStrength() {
    final String password =
        _newController.text;

    if (!mounted) {
      return;
    }

    PasswordStrength strength;

    if (password.isEmpty) {
      strength = PasswordStrength.none;
    } else if (password.length < 6) {
      strength = PasswordStrength.weak;
    } else if (password.length < 10) {
      strength = PasswordStrength.medium;
    } else {
      strength = PasswordStrength.strong;
    }

    if (_passwordStrength == strength) {
      return;
    }

    setState(() {
      _passwordStrength = strength;
    });
  }

  String get _strengthText {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return _localizations.weakPassword;

      case PasswordStrength.medium:
        return _localizations.mediumPassword;

      case PasswordStrength.strong:
        return _localizations.strongPassword;

      case PasswordStrength.none:
        return '';
    }
  }

  Color get _strengthColor {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return Colors.red;

      case PasswordStrength.medium:
        return Colors.orange;

      case PasswordStrength.strong:
        return Colors.green;

      case PasswordStrength.none:
        return Colors.transparent;
    }
  }

  Future<void> _updatePassword() async {
    FocusScope.of(context).unfocus();

    final bool isValid =
        _formKey.currentState?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    if (widget.onUpdatePassword == null) {
      _showMessage(
        _localizations
            .passwordUpdateServiceNotConnected,
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await widget.onUpdatePassword!(
        _currentController.text.trim(),
        _newController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        _localizations
            .passwordUpdatedSuccessfully,
      );

      _currentController.clear();
      _newController.clear();
      _confirmController.clear();

      setState(() {
        _expanded = false;
        _passwordStrength =
            PasswordStrength.none;
      });

      _arrowController.reverse();
    } catch (error) {
      if (!mounted) {
        return;
      }

      final String message = error
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          )
          .trim();

      _showMessage(
        message.isEmpty
            ? _localizations
                .unableToUpdatePassword
            : message,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    final ScaffoldMessengerState messenger =
        ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Semantics(
      container: true,
      label: localizations.changePassword,
      child: AnimatedSize(
        duration: const Duration(
          milliseconds: 250,
        ),
        curve: Curves.easeInOut,
        child: CustomCard(
          child: Column(
            children: [
              _buildHeader(
                context,
                localizations,
              ),
              _buildExpandedForm(
                localizations,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Semantics(
      button: true,
      expanded: _expanded,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(14),
        onTap: _loading
            ? null
            : _toggleCard,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Row(
            children: [
              _buildIconBox(context),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations
                          .changePassword,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color:
                            colorScheme.onSurface,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      localizations
                          .updateLoginPassword,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              RotationTransition(
                turns: Tween<double>(
                  begin: 0,
                  end: 0.5,
                ).animate(
                  _arrowController,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedForm(
    AppLocalizations localizations,
  ) {
    return AnimatedCrossFade(
      duration: const Duration(
        milliseconds: 250,
      ),
      crossFadeState: _expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild:
          const SizedBox.shrink(),
      secondChild: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller:
                    _currentController,
                hintText: localizations
                    .currentPassword,
                prefixIcon:
                    Icons.lock_outline,
                isPassword: true,
                validator: (
                  String? value,
                ) {
                  return Validators
                      .validatePassword(
                    value ?? '',
                  );
                },
              ),

              const SizedBox(
                height: 16,
              ),

              CustomTextField(
                controller:
                    _newController,
                hintText:
                    localizations.newPassword,
                prefixIcon:
                    Icons.lock_reset,
                isPassword: true,
                validator: (
                  String? value,
                ) {
                  return Validators
                      .validatePassword(
                    value ?? '',
                  );
                },
              ),

              if (_passwordStrength !=
                  PasswordStrength.none) ...[
                const SizedBox(
                  height: 8,
                ),
                _buildStrengthMessage(),
              ],

              const SizedBox(
                height: 16,
              ),

              CustomTextField(
                controller:
                    _confirmController,
                hintText: localizations
                    .confirmPassword,
                prefixIcon: Icons
                    .lock_person_outlined,
                isPassword: true,
                validator: (
                  String? value,
                ) {
                  return Validators
                      .validateConfirmPassword(
                    _newController.text,
                    value ?? '',
                  );
                },
              ),

              const SizedBox(
                height: 24,
              ),

              PrimaryButton(
                title: localizations
                    .updatePassword,
                icon: Icons
                    .check_circle_outline,
                loading: _loading,
                onPressed: _loading
                    ? () {}
                    : () async {
                        await _updatePassword();
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        label: _strengthText,
        child: Row(
          children: [
            Icon(
              Icons.shield,
              color: _strengthColor,
              size: 16,
            ),

            const SizedBox(
              width: 6,
            ),

            Flexible(
              child: Text(
                _strengthText,
                style: TextStyle(
                  color: _strengthColor,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(
    BuildContext context,
  ) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: colorScheme.secondary
            .withValues(
          alpha: 0.15,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_outline,
        color: colorScheme.secondary,
      ),
    );
  }
}

enum PasswordStrength {
  none,
  weak,
  medium,
  strong,
}