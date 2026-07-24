import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../widgets/auth/auth_background.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_text_field.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController
      confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showMessage(
    String message, {
    bool isError = true,
  }) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.redAccent
              : Colors.green,
        ),
      );
  }

  bool validatePassword({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage(
        'Please complete all fields',
      );
      return false;
    }

    if (password.length < 8) {
      showMessage(
        'Password must be at least 8 characters',
      );
      return false;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      showMessage(
        'Password must contain an uppercase letter',
      );
      return false;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      showMessage(
        'Password must contain a lowercase letter',
      );
      return false;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      showMessage(
        'Password must contain a number',
      );
      return false;
    }

    if (password != confirmPassword) {
      showMessage(
        'Passwords do not match',
      );
      return false;
    }

    return true;
  }

  Future<void> updatePassword() async {
    if (isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    final String password =
        passwordController.text;

    final String confirmPassword =
        confirmPasswordController.text;

    final bool isValid = validatePassword(
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!isValid) {
      return;
    }

    final SupabaseClient supabase =
        Supabase.instance.client;

    /*
     * verifyOTP() with OtpType.recovery should
     * create a temporary authenticated session.
     *
     * updateUser() only works when a session exists.
     */
    final Session? currentSession =
        supabase.auth.currentSession;

    if (currentSession == null) {
      showMessage(
        'Your password recovery session has expired. '
        'Please request a new verification code.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserResponse response =
          await supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );

      if (response.user == null) {
        throw const AuthException(
          'Unable to update the password.',
        );
      }

      /*
       * Sign out from the temporary recovery
       * session after changing the password.
       */
      await supabase.auth.signOut();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Password updated successfully. '
              'Please log in with your new password.',
            ),
            backgroundColor: Colors.green,
          ),
        );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) =>
              const LoginScreen(),
        ),
        (
          Route<dynamic> route,
        ) =>
            false,
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      final String lowerMessage =
          error.message.toLowerCase();

      String message = error.message;

      if (lowerMessage.contains(
            'same password',
          ) ||
          lowerMessage.contains(
            'different from the old',
          )) {
        message =
            'Your new password must be different '
            'from your previous password.';
      } else if (lowerMessage.contains(
            'session',
          ) ||
          lowerMessage.contains(
            'jwt',
          )) {
        message =
            'Your password recovery session has '
            'expired. Please request a new code.';
      } else if (lowerMessage.contains(
        'password',
      )) {
        message =
            'The password does not meet the '
            'required security rules.';
      }

      showMessage(message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      showMessage(
        'Password update failed. Please try again.',
      );

      debugPrint(
        'Password update error: $error',
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
        MediaQuery.sizeOf(context);

    final bool isSmallScreen =
        size.height < 700;

    final double horizontalPadding =
        size.width < 380 ? 20 : 28;

    return PopScope(
      canPop: !isLoading,
      child: Scaffold(
        backgroundColor:
            Theme.of(context)
                .scaffoldBackgroundColor,
        body: AuthBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
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
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        AuthHeader(
                          icon:
                              Icons.password_rounded,
                          title:
                              'Create New Password',
                          subtitle:
                              'Enter and confirm your new password',
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
                              passwordController,
                          hintText:
                              'New password',
                          icon:
                              Icons.lock_outline,
                          obscureText:
                              hidePassword,
                          suffixIcon:
                              IconButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            hidePassword =
                                                !hidePassword;
                                          },
                                        );
                                      },
                            icon: Icon(
                              hidePassword
                                  ? Icons
                                      .visibility_off_outlined
                                  : Icons
                                      .visibility_outlined,
                              color: AppColors
                                  .textGrey,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        AuthTextField(
                          controller:
                              confirmPasswordController,
                          hintText:
                              'Confirm new password',
                          icon:
                              Icons.lock_outline,
                          obscureText:
                              hideConfirmPassword,
                          suffixIcon:
                              IconButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            hideConfirmPassword =
                                                !hideConfirmPassword;
                                          },
                                        );
                                      },
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons
                                      .visibility_off_outlined
                                  : Icons
                                      .visibility_outlined,
                              color: AppColors
                                  .textGrey,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        const Align(
                          alignment:
                              Alignment.centerLeft,
                          child: Text(
                            'Password must contain at least '
                            '8 characters, one uppercase letter, '
                            'one lowercase letter, and one number.',
                            style: TextStyle(
                              color:
                                  AppColors.textGrey,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        AuthButton(
                          title: isLoading
                              ? 'Updating...'
                              : 'Update Password',
                          onPressed: isLoading
                              ? null
                              : updatePassword,
                        ),
                      ],
                    ),
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