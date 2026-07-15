import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/auth/auth_background.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_divider.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_text_field.dart';
import '../widgets/auth/social_login_section.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter email and password',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final AuthResponse response =
          await Supabase.instance.client.auth
              .signInWithPassword(
        email: email,
        password: password,
      );

      final User? user = response.user;

      if (user == null) {
        throw const AuthException(
          'Login failed',
        );
      }

      debugPrint(
        'Logged-in user: ${user.email}',
      );

      debugPrint(
        'Logged-in user ID: ${user.id}',
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
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
            'Login failed: $error',
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
          Theme.of(context).scaffoldBackgroundColor,
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          isSmallScreen ? 10 : 35,
                    ),
                    AuthHeader(
                      icon: Icons.bolt_rounded,
                      title: 'Welcome Back',
                      subtitle:
                          'Login to continue your focus journey',
                      isSmallScreen:
                          isSmallScreen,
                    ),
                    SizedBox(
                      height:
                          isSmallScreen ? 30 : 45,
                    ),
                    AuthTextField(
                      controller:
                          emailController,
                      hintText:
                          'Email address',
                      icon:
                          Icons.email_outlined,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    AuthTextField(
                      controller:
                          passwordController,
                      hintText: 'Password',
                      icon:
                          Icons.lock_outline,
                      obscureText:
                          hidePassword,
                      suffixIcon: IconButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  hidePassword =
                                      !hidePassword;
                                });
                              },
                        icon: Icon(
                          hidePassword
                              ? Icons
                                  .visibility_off_outlined
                              : Icons
                                  .visibility_outlined,
                          color:
                              AppColors.textGrey,
                        ),
                      ),
                    ),
                    Align(
                      alignment:
                          Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color:
                                AppColors.secondary,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AuthButton(
                      title: isLoading
                          ? 'Logging in...'
                          : 'Login',
                      onPressed: isLoading
                          ? null
                          : loginUser,
                    ),
                    SizedBox(
                      height:
                          isSmallScreen ? 26 : 38,
                    ),
                    const AuthDivider(),
                    const SizedBox(height: 24),
                    const SocialLoginSection(),
                    SizedBox(
                      height:
                          isSmallScreen ? 25 : 40,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account?',
                          style: TextStyle(
                            color:
                                AppColors.textGrey,
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color:
                                  AppColors.secondary,
                              fontWeight:
                                  FontWeight.bold,
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