import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/auth/auth_background.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> createAccount() async {
    final String name =
        nameController.text.trim();

    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all fields',
          ),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 6 characters',
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
          await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
        },
      );

      final User? user = response.user;

      if (user == null) {
        throw const AuthException(
          'Account could not be created',
        );
      }

      debugPrint(
        'Created user: ${user.email}',
      );

      debugPrint(
        'Created user ID: ${user.id}',
      );

      /*
       * Supabase may automatically log in the user
       * when email confirmation is disabled.
       *
       * Sign out so the user is redirected to Login.
       */
      if (response.session != null) {
        await Supabase.instance.client.auth.signOut();
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.session == null
                ? 'Account created. Check your email to confirm your account, then log in.'
                : 'Account created successfully. Please log in.',
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
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
            'Sign-up failed: $error',
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
                    Align(
                      alignment:
                          Alignment.centerLeft,
                      child: IconButton(
                        onPressed: isLoading
                            ? null
                            : () =>
                                Navigator.pop(context),
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
                          .person_add_alt_1_rounded,
                      title: 'Create Account',
                      subtitle:
                          'Sign up to start your focus journey',
                      isSmallScreen:
                          isSmallScreen,
                    ),
                    SizedBox(
                      height:
                          isSmallScreen ? 30 : 45,
                    ),
                    AuthTextField(
                      controller:
                          nameController,
                      hintText: 'Full name',
                      icon:
                          Icons.person_outline,
                    ),
                    const SizedBox(height: 18),
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
                        onPressed: () {
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
                    const SizedBox(height: 28),
                    AuthButton(
                      title: isLoading
                          ? 'Creating account...'
                          : 'Sign Up',
                      onPressed: isLoading
                          ? null
                          : createAccount,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color:
                                AppColors.textGrey,
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator
                                      .pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                },
                          child: const Text(
                            'Login',
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
