import 'package:flutter/material.dart';

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

  String _strengthText = '';
  Color _strengthColor = Colors.transparent;

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

    setState(() {
      if (password.isEmpty) {
        _strengthText = '';
        _strengthColor = Colors.transparent;
      } else if (password.length < 6) {
        _strengthText = 'Weak Password';
        _strengthColor = Colors.red;
      } else if (password.length < 10) {
        _strengthText = 'Medium Password';
        _strengthColor = Colors.orange;
      } else {
        _strengthText = 'Strong Password';
        _strengthColor = Colors.green;
      }
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password update service is not connected.',
          ),
        ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password updated successfully',
          ),
        ),
      );

      _currentController.clear();
      _newController.clear();
      _confirmController.clear();

      setState(() {
        _expanded = false;
        _strengthText = '';
        _strengthColor = Colors.transparent;
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
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeInOut,
      child: CustomCard(
        child: Column(
          children: [
            _buildHeader(context),
            _buildExpandedForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _loading ? null : _toggleCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          children: [
            _buildIconBox(context),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
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
                  const SizedBox(height: 4),
                  Text(
                    'Update your login password',
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
    );
  }

  Widget _buildExpandedForm() {
    return AnimatedCrossFade(
      duration: const Duration(
        milliseconds: 250,
      ),
      crossFadeState: _expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
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
                hintText:
                    'Current Password',
                prefixIcon:
                    Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  return Validators
                      .validatePassword(
                    value ?? '',
                  );
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _newController,
                hintText: 'New Password',
                prefixIcon:
                    Icons.lock_reset,
                isPassword: true,
                validator: (value) {
                  return Validators
                      .validatePassword(
                    value ?? '',
                  );
                },
              ),

              if (_strengthText.isNotEmpty)
                ...[
                  const SizedBox(height: 8),
                  _buildStrengthMessage(),
                ],

              const SizedBox(height: 16),

              CustomTextField(
                controller:
                    _confirmController,
                hintText:
                    'Confirm Password',
                prefixIcon: Icons
                    .lock_person_outlined,
                isPassword: true,
                validator: (value) {
                  return Validators
                      .validateConfirmPassword(
                    _newController.text,
                    value ?? '',
                  );
                },
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                title: 'Update Password',
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
      child: Row(
        children: [
          Icon(
            Icons.shield,
            color: _strengthColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _strengthText,
            style: TextStyle(
              color: _strengthColor,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
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
            .withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_outline,
        color: colorScheme.secondary,
      ),
    );
  }
}