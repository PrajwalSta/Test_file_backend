import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../services/MFA Auth/security_settings_service.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({
    super.key,
  });

  @override
  State<TwoFactorAuthScreen> createState() =>
      _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState
    extends State<TwoFactorAuthScreen> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  final SecuritySettingsService _securityService =
      SecuritySettingsService();

  final TextEditingController _codeController =
      TextEditingController();

  bool _isLoading = true;
  bool _isSending = false;
  bool _isVerifying = false;
  bool _isDisabling = false;

  bool _isEnabled = false;
  bool _otpSent = false;

  String? _email;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final User? user =
          _supabase.auth.currentUser;

      final String? email =
          user?.email?.trim().toLowerCase();

      if (user == null ||
          email == null ||
          email.isEmpty) {
        throw const _SessionExpiredException();
      }

      final Map<String, dynamic> settings =
          await _securityService.getSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        _email = email;

        _isEnabled =
            settings['two_factor_enabled']
                    as bool? ??
                false;

        _isLoading = false;
      });
    } on _SessionExpiredException {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations.sessionExpiredLoginAgain,
      );
    } catch (error) {
      debugPrint(
        'Unable to load email verification settings: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .unableToLoadEmailVerificationSettings,
      );
    }
  }

  Future<void> _sendOtp() async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final String? email =
        _email?.trim().toLowerCase();

    if (email == null || email.isEmpty) {
      _showMessage(
        localizations.noEmailConnected,
      );
      return;
    }

    if (_isSending) {
      return;
    }

    setState(() {
      _isSending = true;
      _otpSent = false;
    });

    try {
      _codeController.clear();

      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _otpSent = true;
      });

      _showMessage(
        localizations.verificationCodeSent,
      );
    } on AuthException catch (error) {
      debugPrint(
        'Unable to send verification code: ${error.message}',
      );

      if (!mounted) {
        return;
      }

      final String message =
          error.message.toLowerCase();

      if (message.contains('rate limit') ||
          message.contains(
            'security purposes',
          )) {
        _showMessage(
          localizations.waitBeforeRequestingCode,
        );
      } else {
        _showMessage(
          localizations
              .unableToSendVerificationCode,
        );
      }
    } catch (error) {
      debugPrint(
        'Unable to send verification code: $error',
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        localizations
            .unableToSendVerificationCode,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final String code =
        _codeController.text.trim();

    final String? email =
        _email?.trim().toLowerCase();

    if (email == null || email.isEmpty) {
      _showMessage(
        localizations.noEmailConnected,
      );
      return;
    }

    if (!_otpSent) {
      _showMessage(
        localizations.sendVerificationCodeFirst,
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      _showMessage(
        localizations.enterCompleteSixDigitCode,
      );
      return;
    }

    if (_isVerifying) {
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final AuthResponse response =
          await _supabase.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.email,
      );

      final User? verifiedUser =
          response.user;

      if (verifiedUser == null) {
        throw const _OtpConfirmationException();
      }

      final String? verifiedEmail =
          verifiedUser.email
              ?.trim()
              .toLowerCase();

      if (verifiedEmail != email) {
        throw const _EmailMismatchException();
      }

      await _securityService.updateTwoFactor(
        true,
      );

      _codeController.clear();

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } on AuthException catch (error) {
      debugPrint(
        'Unable to verify email code: ${error.message}',
      );

      if (!mounted) {
        return;
      }

      final String message =
          error.message.toLowerCase();

      final String errorCode =
          error.code?.toLowerCase() ?? '';

      if (errorCode == 'otp_expired' ||
          message.contains('expired')) {
        _codeController.clear();

        setState(() {
          _otpSent = false;
        });

        _showMessage(
          localizations.verificationCodeExpired,
        );
      } else if (message.contains('invalid') ||
          message.contains('token')) {
        _showMessage(
          localizations.verificationCodeIncorrect,
        );
      } else {
        _showMessage(
          localizations
              .unableToVerifyVerificationCode,
        );
      }
    } on _OtpConfirmationException {
      if (!mounted) {
        return;
      }

      _showMessage(
        localizations
            .verificationCodeNotConfirmed,
      );
    } on _EmailMismatchException {
      if (!mounted) {
        return;
      }

      _showMessage(
        localizations.verifiedEmailMismatch,
      );
    } catch (error) {
      debugPrint(
        'Unable to verify email code: $error',
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        localizations
            .unableToVerifyVerificationCode,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void>
      _disableEmailVerification() async {
    if (_isDisabling) {
      return;
    }

    setState(() {
      _isDisabling = true;
    });

    try {
      await _securityService.updateTwoFactor(
        false,
      );

      _codeController.clear();

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        false,
      );
    } catch (error) {
      debugPrint(
        'Unable to disable email verification: $error',
      );

      if (!mounted) {
        return;
      }

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .unableToDisableEmailVerification,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDisabling = false;
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

  String _maskedEmail(
    String email,
  ) {
    final List<String> parts =
        email.split('@');

    if (parts.length != 2) {
      return email;
    }

    final String name = parts.first;
    final String domain = parts.last;

    if (name.isEmpty) {
      return email;
    }

    if (name.length <= 2) {
      return '${name.substring(0, 1)}***@$domain';
    }

    return '${name.substring(0, 2)}***@$domain';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.emailVerification,
        ),
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.all(24),
                child: _isEnabled
                    ? _buildEnabledContent(
                        theme,
                        colorScheme,
                        localizations,
                      )
                    : _buildSetupContent(
                        theme,
                        colorScheme,
                        localizations,
                      ),
              ),
            ),
    );
  }

  Widget _buildEnabledContent(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations localizations,
  ) {
    final String description =
        _email == null
            ? localizations.emailVerified
            : localizations
                .verificationEnabledFor(
                _maskedEmail(_email!),
              );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 32,
        ),

        Icon(
          Icons.mark_email_read_outlined,
          size: 90,
          color: colorScheme.primary,
        ),

        const SizedBox(
          height: 24,
        ),

        Text(
          localizations
              .emailVerificationEnabled,
          textAlign: TextAlign.center,
          style: theme
              .textTheme.headlineSmall
              ?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          description,
          textAlign: TextAlign.center,
          style: theme
              .textTheme.bodyMedium
              ?.copyWith(
            color:
                colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),

        const SizedBox(
          height: 36,
        ),

        OutlinedButton.icon(
          onPressed: _isDisabling
              ? null
              : _disableEmailVerification,
          icon: _isDisabling
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.lock_open_outlined,
                ),
          label: Text(
            _isDisabling
                ? localizations.disabling
                : localizations
                    .disableEmailVerification,
          ),
        ),
      ],
    );
  }

  Widget _buildSetupContent(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations localizations,
  ) {
    final String description =
        _email == null
            ? localizations
                .verificationCodeWillBeSent
            : localizations
                .sixDigitCodeWillBeSentTo(
                _maskedEmail(_email!),
              );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.email_outlined,
          size: 72,
          color: colorScheme.primary,
        ),

        const SizedBox(
          height: 20,
        ),

        Text(
          localizations.verifyYourEmail,
          textAlign: TextAlign.center,
          style: theme
              .textTheme.headlineSmall
              ?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          description,
          textAlign: TextAlign.center,
          style: theme
              .textTheme.bodyMedium
              ?.copyWith(
            color:
                colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),

        const SizedBox(
          height: 28,
        ),

        FilledButton.icon(
          onPressed:
              _isSending ? null : _sendOtp,
          icon: _isSending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.send_outlined,
                ),
          label: Text(
            _isSending
                ? localizations.sending
                : _otpSent
                    ? localizations.resendCode
                    : localizations.sendCode,
          ),
        ),

        if (_otpSent) ...[
          const SizedBox(
            height: 28,
          ),

          TextField(
            controller: _codeController,
            keyboardType:
                TextInputType.number,
            textInputAction:
                TextInputAction.done,
            maxLength: 6,
            autofillHints: const <String>[
              AutofillHints.oneTimeCode,
            ],
            inputFormatters:
                <TextInputFormatter>[
              FilteringTextInputFormatter
                  .digitsOnly,
              LengthLimitingTextInputFormatter(
                6,
              ),
            ],
            decoration: InputDecoration(
              labelText: localizations
                  .sixDigitVerificationCode,
              hintText: '123456',
              border:
                  const OutlineInputBorder(),
              counterText: '',
              prefixIcon: const Icon(
                Icons.password_outlined,
              ),
            ),
            onSubmitted: (
              String value,
            ) {
              if (!_isVerifying) {
                _verifyOtp();
              }
            },
          ),

          const SizedBox(
            height: 16,
          ),

          FilledButton(
            onPressed: _isVerifying
                ? null
                : _verifyOtp,
            child: _isVerifying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    localizations
                        .verifyAndEnable,
                  ),
          ),
        ],
      ],
    );
  }
}

class _SessionExpiredException
    implements Exception {
  const _SessionExpiredException();
}

class _OtpConfirmationException
    implements Exception {
  const _OtpConfirmationException();
}

class _EmailMismatchException
    implements Exception {
  const _EmailMismatchException();
}