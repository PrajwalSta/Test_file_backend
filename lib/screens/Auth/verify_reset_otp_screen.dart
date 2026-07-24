import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../widgets/auth/auth_background.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_header.dart';
import 'reset_password_screen.dart';

class VerifyResetOtpScreen extends StatefulWidget {
  final String email;

  const VerifyResetOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyResetOtpScreen> createState() =>
      _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState
    extends State<VerifyResetOtpScreen> {
  final TextEditingController otpController =
      TextEditingController();

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  bool isVerifying = false;
  bool isResending = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyResetOtp() async {
    final String otp =
        otpController.text.trim();

    if (otp.isEmpty) {
      _showMessage(
        'Please enter the verification code',
      );
      return;
    }

    if (otp.length != 6) {
      _showMessage(
        'Please enter the complete 6-digit code',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isVerifying = true;
    });

    try {
      final AuthResponse response =
          await Supabase.instance.client.auth
              .verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.recovery,
      );

      if (!mounted) {
        return;
      }

      if (response.session == null) {
        _showMessage(
          'Unable to create a password recovery session.',
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const ResetPasswordScreen(),
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      String message = error.message;

      final String lowerMessage =
          error.message.toLowerCase();

      if (lowerMessage.contains('expired')) {
        message =
            'The verification code has expired. Please request a new code.';
      } else if (lowerMessage.contains(
            'invalid',
          ) ||
          lowerMessage.contains(
            'token',
          )) {
        message =
            'The verification code is incorrect.';
      }

      _showMessage(message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'OTP verification failed. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  Future<void> resendResetOtp() async {
    if (isResending) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isResending = true;
    });

    try {
      await Supabase.instance.client.auth
          .resetPasswordForEmail(
        widget.email,
      );

      if (!mounted) {
        return;
      }

      otpController.clear();

      _showMessage(
        'A new verification code was sent to your email.',
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to resend the verification code.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isResending = false;
        });
      }
    }
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final Size size =
        MediaQuery.of(context).size;

    final bool isSmallScreen =
        size.height < 700;

    final double horizontalPadding =
        size.width < 380 ? 20 : 28;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    horizontalPadding,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment:
                            Alignment.centerLeft,
                        child: IconButton(
                          onPressed:
                              isVerifying ||
                                      isResending
                                  ? null
                                  : () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                          icon: const Icon(
                            Icons
                                .arrow_back_ios_new_rounded,
                            color:
                                AppColors.textWhite,
                          ),
                        ),
                      ),

                      AuthHeader(
                        icon: Icons
                            .mark_email_read_outlined,
                        title:
                            'Verify Reset Code',
                        subtitle:
                            'Enter the 6-digit code sent to\n${widget.email}',
                        isSmallScreen:
                            isSmallScreen,
                      ),

                      SizedBox(
                        height: isSmallScreen
                            ? 35
                            : 55,
                      ),

                      TextFormField(
                        controller:
                            otpController,
                        keyboardType:
                            TextInputType.number,
                        textInputAction:
                            TextInputAction.done,
                        textAlign:
                            TextAlign.center,
                        maxLength: 6,
                        autofocus: true,
                        enabled:
                            !isVerifying &&
                                !isResending,
                        inputFormatters: <
                            TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                            6,
                          ),
                        ],
                        onFieldSubmitted:
                            (_) {
                          if (!isVerifying) {
                            verifyResetOtp();
                          }
                        },
                        style: const TextStyle(
                          color:
                              AppColors.textWhite,
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 12,
                        ),
                        decoration:
                            InputDecoration(
                          counterText: '',
                          hintText: '000000',
                          hintStyle:
                              TextStyle(
                            color: AppColors
                                .textGrey
                                .withValues(
                              alpha: 0.45,
                            ),
                            fontSize: 26,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing: 12,
                          ),
                          filled: true,
                          fillColor:
                              AppColors
                                  .darkInput,
                          contentPadding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                BorderSide.none,
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                BorderSide(
                              color: AppColors
                                  .textWhite
                                  .withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                const BorderSide(
                              color: AppColors
                                  .secondary,
                              width: 1.5,
                            ),
                          ),
                          errorBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                const BorderSide(
                              color:
                                  Colors.redAccent,
                            ),
                          ),
                          focusedErrorBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                const BorderSide(
                              color:
                                  Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator:
                            (String? value) {
                          final String otp =
                              value?.trim() ??
                                  '';

                          if (otp.isEmpty) {
                            return 'Enter the verification code';
                          }

                          if (otp.length !=
                              6) {
                            return 'Enter the complete 6-digit code';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      AuthButton(
                        title: isVerifying
                            ? 'Verifying...'
                            : 'Verify Code',
                        onPressed:
                            isVerifying ||
                                    isResending
                                ? null
                                : verifyResetOtp,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      const Text(
                        'Didn’t receive the code?',
                        style: TextStyle(
                          color:
                              AppColors.textGrey,
                        ),
                      ),

                      TextButton(
                        onPressed:
                            isResending ||
                                    isVerifying
                                ? null
                                : resendResetOtp,
                        child: Text(
                          isResending
                              ? 'Sending...'
                              : 'Resend Code',
                          style:
                              const TextStyle(
                            color: AppColors
                                .secondary,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      TextButton.icon(
                        onPressed:
                            isVerifying ||
                                    isResending
                                ? null
                                : () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                        icon: const Icon(
                          Icons
                              .edit_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          'Change Email Address',
                        ),
                        style:
                            TextButton.styleFrom(
                          foregroundColor:
                              AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}