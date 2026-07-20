import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

      final String? email = user?.email;

      if (user == null || email == null) {
        throw Exception(
          'Your session has expired. Please log in again.',
        );
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
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        _cleanError(error),
      );
    }
  }

  Future<void> _sendOtp() async {
    final String? email = _email;

    if (email == null || email.isEmpty) {
      _showMessage(
        'No email address is connected to your account.',
      );
      return;
    }

    if (_isSending) {
      return;
    }

    setState(() {
      _isSending = true;
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
        'A new verification code was sent. Use only the newest code.',
      );
    } on AuthException catch (error) {
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
          'Please wait about 60 seconds before requesting another code.',
        );
      } else {
        _showMessage(
          error.message,
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _cleanError(error),
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
    final String code =
        _codeController.text.trim();

    final String? email = _email;

    if (email == null || email.isEmpty) {
      _showMessage(
        'No email address is connected to your account.',
      );
      return;
    }

    if (!_otpSent) {
      _showMessage(
        'Please send a verification code first.',
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      _showMessage(
        'Please enter the complete six-digit code.',
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

      if (response.user == null) {
        throw Exception(
          'The verification code could not be confirmed.',
        );
      }

      await _securityService.updateTwoFactor(
        true,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isEnabled = true;
        _otpSent = false;
      });

      _codeController.clear();

      _showMessage(
        'Email verification enabled successfully.',
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      final String message =
          error.message.toLowerCase();

      if (message.contains('expired')) {
        _codeController.clear();

        setState(() {
          _otpSent = false;
        });

        _showMessage(
          'This code is expired or was replaced. Press Send Code and use the newest email.',
        );
      } else if (message.contains('invalid') ||
          message.contains('token')) {
        _showMessage(
          'The verification code is incorrect. Check the newest email.',
        );
      } else {
        _showMessage(
          error.message,
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _cleanError(error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _disableEmailVerification() async {
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

      if (!mounted) {
        return;
      }

      setState(() {
        _isEnabled = false;
        _otpSent = false;
      });

      _codeController.clear();

      _showMessage(
        'Email verification disabled.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _cleanError(error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDisabling = false;
        });
      }
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
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

    if (name.length == 1) {
      return '${name.substring(0, 1)}***@$domain';
    }

    if (name.length == 2) {
      return '${name.substring(0, 1)}***@$domain';
    }

    return '${name.substring(0, 2)}***@$domain';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email Verification',
        ),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.all(24),
                child: _isEnabled
                    ? _buildEnabledContent(
                        colorScheme,
                      )
                    : _buildSetupContent(
                        colorScheme,
                      ),
              ),
            ),
    );
  }

  Widget _buildEnabledContent(
    ColorScheme colorScheme,
  ) {
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

        const Text(
          'Email verification is enabled',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          _email == null
              ? 'Your email has been verified.'
              : 'Verification is enabled for ${_maskedEmail(_email!)}.',
          textAlign: TextAlign.center,
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
                ? 'Disabling...'
                : 'Disable Email Verification',
          ),
        ),
      ],
    );
  }

  Widget _buildSetupContent(
    ColorScheme colorScheme,
  ) {
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

        const Text(
          'Verify your email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          _email == null
              ? 'A verification code will be sent to your email.'
              : 'We will send a six-digit code to ${_maskedEmail(_email!)}.',
          textAlign: TextAlign.center,
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
                ? 'Sending...'
                : _otpSent
                    ? 'Resend Code'
                    : 'Send Code',
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
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,
              LengthLimitingTextInputFormatter(
                6,
              ),
            ],
            decoration:
                const InputDecoration(
              labelText:
                  'Six-digit verification code',
              hintText: '123456',
              border:
                  OutlineInputBorder(),
              counterText: '',
              prefixIcon: Icon(
                Icons.password_outlined,
              ),
            ),
            onSubmitted: (_) {
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
                : const Text(
                    'Verify and Enable',
                  ),
          ),
        ],
      ],
    );
  }
}
