import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../widgets/auth/auth_background.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetCode() async {
    final String email =
        emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your email address',
          ),
        ),
      );
      return;
    }

    if (!email.contains('@') ||
        !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid email address',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Supabase.instance.client.auth
          .resetPasswordForEmail(
        email,
        redirectTo:
            'focusglow://reset-password',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset link sent. Check your email.',
          ),
        ),
      );

      Navigator.pop(context);
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send reset link: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                child: Column(
                  children: [
                    Align(
                      alignment:
                          Alignment.centerLeft,
                      child: IconButton(
                        onPressed: isLoading
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
                      icon:
                          Icons.lock_reset_rounded,
                      title:
                          'Forgot Password',
                      subtitle:
                          'Enter your email address and we’ll send you a reset link',
                      isSmallScreen:
                          isSmallScreen,
                    ),

                    SizedBox(
                      height: isSmallScreen
                          ? 35
                          : 55,
                    ),

                    AuthTextField(
                      controller:
                          emailController,
                      hintText:
                          'Email address',
                      icon:
                          Icons.email_outlined,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    AuthButton(
                      title: isLoading
                          ? 'Sending...'
                          : 'Send Reset Link',
                      onPressed: isLoading
                          ? null
                          : sendResetCode,
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        const Text(
                          'Remember your password?',
                          style: TextStyle(
                            color: AppColors
                                .textGrey,
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors
                                  .secondary,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}