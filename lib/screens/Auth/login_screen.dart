import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/MFA Auth/biometric_auth_service.dart';
import '../../services/MFA Auth/biometric_setting_service.dart';
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
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final BiometricAuthService biometricAuthService =
      BiometricAuthService.instance;

  final BiometricSettingService
      biometricSettingService =
      BiometricSettingService.instance;

  bool hidePassword = true;
  bool isLoading = false;

  bool isCheckingBiometrics = true;
  bool isBiometricLoading = false;
  bool isBiometricAvailable = false;
  bool isBiometricEnabled = false;
  bool hasSavedSession = false;

  String biometricName = 'Biometric';

  @override
  void initState() {
    super.initState();

    _checkBiometricLogin();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    biometricAuthService
        .cancelAuthentication();

    super.dispose();
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================
  void _showMessage(
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
          content: Text(
            message,
          ),
          backgroundColor:
              isError
                  ? Colors.redAccent
                  : Colors.green,
        ),
      );
  }

  // ==========================================================
  // CHECK BIOMETRIC LOGIN
  // ==========================================================
  Future<void> _checkBiometricLogin() async {
    try {
      final bool enabled =
          await biometricSettingService
              .isEnabled();

      final bool available =
          await biometricAuthService
              .isBiometricAvailable();

      final String name =
          await biometricAuthService
              .getBiometricName();

      final Session? session =
          Supabase.instance.client.auth
              .currentSession;

      debugPrint(
        'Biometric enabled: $enabled',
      );

      debugPrint(
        'Biometric available: $available',
      );

      debugPrint(
        'Saved Supabase session: '
        '${session != null}',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        biometricName = name;
        isBiometricEnabled = enabled;
        isBiometricAvailable = available;
        hasSavedSession = session != null;
        isCheckingBiometrics = false;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Biometric login check failed: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isBiometricEnabled = false;
        isBiometricAvailable = false;
        hasSavedSession = false;
        isCheckingBiometrics = false;
      });
    }
  }

  // ==========================================================
  // EMAIL AND PASSWORD LOGIN
  // ==========================================================
  Future<void> loginUser() async {
    if (isLoading ||
        isBiometricLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text;

    if (email.isEmpty ||
        password.isEmpty) {
      _showMessage(
        'Please enter email and password',
      );

      return;
    }

    if (!email.contains('@') ||
        !email.contains('.')) {
      _showMessage(
        'Please enter a valid email address',
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

      final User? user =
          response.user;

      final Session? session =
          response.session;

      if (user == null ||
          session == null) {
        throw const AuthException(
          'Login failed. No valid session was created.',
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

      setState(() {
        hasSavedSession = true;
      });

      Navigator.of(context)
          .pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) =>
              const MainScreen(),
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

      String message =
          error.message;

      final String lowerMessage =
          error.message.toLowerCase();

      if (lowerMessage.contains(
            'invalid login credentials',
          ) ||
          lowerMessage.contains(
            'invalid credentials',
          )) {
        message =
            'Incorrect email or password.';
      } else if (lowerMessage.contains(
        'email not confirmed',
      )) {
        message =
            'Please confirm your email before logging in.';
      }

      _showMessage(
        message,
      );
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      debugPrint(
        'Login failed: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _showMessage(
        'Login failed. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // BIOMETRIC LOGIN
  // ==========================================================
  Future<void> _loginWithBiometrics() async {
    if (isBiometricLoading ||
        isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isBiometricLoading = true;
    });

    try {
      final bool enabled =
          await biometricSettingService
              .isEnabled();

      if (!enabled) {
        throw Exception(
          'Biometric login is disabled. '
          'Enable it from Privacy and Security settings.',
        );
      }

      final bool available =
          await biometricAuthService
              .isBiometricAvailable();

      if (!available) {
        throw Exception(
          'Face ID or fingerprint is not available. '
          'Check your device biometric settings.',
        );
      }

      final SupabaseClient supabase =
          Supabase.instance.client;

      final Session? savedSession =
          supabase.auth.currentSession;

      if (savedSession == null) {
        if (mounted) {
          setState(() {
            hasSavedSession = false;
          });
        }

        throw Exception(
          'No saved login session was found. '
          'Log in with email and password first, '
          'then use Lock App instead of Sign Out.',
        );
      }

      final bool authenticated =
          await biometricAuthService
              .authenticateForLogin();

      if (!authenticated) {
        throw Exception(
          '$biometricName authentication was '
          'cancelled or unsuccessful.',
        );
      }

      AuthResponse? refreshedResponse;

      try {
        refreshedResponse =
            await supabase.auth
                .refreshSession();
      } on AuthException catch (error) {
        debugPrint(
          'Session refresh failed: '
          '${error.message}',
        );

        /*
         * The locally restored session may
         * still be valid when the device is
         * temporarily offline.
         */
        if (supabase.auth.currentSession ==
                null ||
            supabase.auth.currentUser ==
                null) {
          rethrow;
        }
      }

      final Session? activeSession =
          refreshedResponse?.session ??
              supabase.auth.currentSession;

      final User? activeUser =
          refreshedResponse?.user ??
              supabase.auth.currentUser;

      if (activeSession == null ||
          activeUser == null) {
        throw const AuthException(
          'Your saved login session has expired.',
        );
      }

      debugPrint(
        'Biometric login successful: '
        '${activeUser.email}',
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context)
          .pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) =>
              const MainScreen(),
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

      setState(() {
        hasSavedSession = false;
      });

      _showMessage(
        '${error.message} '
        'Please log in with email and password.',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Biometric login error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        error
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isBiometricLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // BIOMETRIC ICON
  // ==========================================================
  IconData get _biometricIcon {
    final String name =
        biometricName.toLowerCase();

    if (name.contains('face')) {
      return Icons.face_rounded;
    }

    return Icons.fingerprint_rounded;
  }

  // ==========================================================
  // BIOMETRIC BUTTON
  // ==========================================================
  Widget _buildBiometricButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed:
                isLoading ||
                        isBiometricLoading
                    ? null
                    : _loginWithBiometrics,
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.secondary,
              disabledForegroundColor:
                  AppColors.textGrey,
              side: BorderSide(
                color: AppColors.secondary
                    .withValues(
                  alpha: 0.70,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
            ),
            icon: isBiometricLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                          AppColors.secondary,
                    ),
                  )
                : Icon(
                    _biometricIcon,
                    size: 28,
                  ),
            label: Text(
              isBiometricLoading
                  ? 'Authenticating...'
                  : 'Login with $biometricName',
              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),

        if (!hasSavedSession) ...[
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Log in normally once to activate biometric login.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  AppColors.textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final Size size =
        MediaQuery.sizeOf(context);

    final bool isSmallScreen =
        size.height < 700;

    final double horizontalPadding =
        size.width < 380
            ? 20
            : 28;

    final bool controlsDisabled =
        isLoading ||
            isBiometricLoading;

    return PopScope(
      canPop:
          !controlsDisabled,
      child: Scaffold(
        backgroundColor:
            Theme.of(context)
                .scaffoldBackgroundColor,
        body: AuthBackground(
          child: SafeArea(
            child: Center(
              child:
                  SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                padding:
                    EdgeInsets.symmetric(
                  horizontal:
                      horizontalPadding,
                  vertical: 20,
                ),
                child:
                    ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child:
                      AutofillGroup(
                    child: Column(
                      children: [
                        SizedBox(
                          height:
                              isSmallScreen
                                  ? 10
                                  : 35,
                        ),

                        AuthHeader(
                          icon:
                              Icons
                                  .bolt_rounded,
                          title:
                              'Welcome Back',
                          subtitle:
                              'Login to continue your focus journey',
                          isSmallScreen:
                              isSmallScreen,
                        ),

                        SizedBox(
                          height:
                              isSmallScreen
                                  ? 30
                                  : 45,
                        ),

                        AuthTextField(
                          controller:
                              emailController,
                          hintText:
                              'Email address',
                          icon:
                              Icons
                                  .email_outlined,
                          keyboardType:
                              TextInputType
                                  .emailAddress,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        AuthTextField(
                          controller:
                              passwordController,
                          hintText:
                              'Password',
                          icon:
                              Icons
                                  .lock_outline,
                          obscureText:
                              hidePassword,
                          suffixIcon:
                              IconButton(
                            onPressed:
                                controlsDisabled
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
                              color:
                                  AppColors.textGrey,
                            ),
                          ),
                        ),

                        Align(
                          alignment:
                              Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                controlsDisabled
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder:
                                                (_) =>
                                                    const ForgotPasswordScreen(),
                                          ),
                                        );
                                      },
                            child:
                                const Text(
                              'Forgot Password?',
                              style:
                                  TextStyle(
                                color:
                                    AppColors.secondary,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        AuthButton(
                          title: isLoading
                              ? 'Logging in...'
                              : 'Login',
                          onPressed:
                              controlsDisabled
                                  ? null
                                  : loginUser,
                        ),

                        /*
                         * Show biometric login when:
                         *
                         * 1. User enabled it in settings.
                         * 2. Device supports biometrics.
                         *
                         * The saved Supabase session is
                         * checked when the button is pressed.
                         */
                        if (!isCheckingBiometrics &&
                            isBiometricEnabled &&
                            isBiometricAvailable) ...[
                          const SizedBox(
                            height: 18,
                          ),
                          _buildBiometricButton(),
                        ],

                        if (isCheckingBiometrics) ...[
                          const SizedBox(
                            height: 18,
                          ),
                          const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ],

                        SizedBox(
                          height:
                              isSmallScreen
                                  ? 26
                                  : 38,
                        ),

                        const AuthDivider(),

                        const SizedBox(
                          height: 24,
                        ),

                        const SocialLoginSection(),

                        SizedBox(
                          height:
                              isSmallScreen
                                  ? 25
                                  : 40,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                'Don’t have an account?',
                                style:
                                    TextStyle(
                                  color:
                                      AppColors.textGrey,
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed:
                                  controlsDisabled
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder:
                                                  (_) =>
                                                      const SignupScreen(),
                                            ),
                                          );
                                        },
                              child:
                                  const Text(
                                'Sign Up',
                                style:
                                    TextStyle(
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
        ),
      ),
    );
  }
}