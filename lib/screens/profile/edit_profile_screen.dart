import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/profile/profile_model.dart';
import '../../services/profile/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final ProfileService _profileService =
      ProfileService();

  late final TextEditingController
      _nameController;

  late final TextEditingController
      _bioController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
      text: widget.profile.fullName,
    );

    _bioController =
        TextEditingController(
      text: widget.profile.bio,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final String fullName =
        _nameController.text.trim();

    final String bio =
        _bioController.text.trim();

    FocusScope.of(context).unfocus();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            localizations.pleaseEnterYourName,
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        _isSaving = true;
      });

      await _profileService.updateProfile(
        fullName: fullName,
        bio: bio,
        avatarUrl:
            widget.profile.avatarUrl,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (error) {
      debugPrint(
        'Unable to update profile: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .unableToUpdateProfile,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.editProfile,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller:
                    _nameController,
                textInputAction:
                    TextInputAction.next,
                textCapitalization:
                    TextCapitalization.words,
                autofillHints: const [
                  AutofillHints.name,
                ],
                decoration:
                    InputDecoration(
                  labelText:
                      localizations.fullName,
                  prefixIcon:
                      const Icon(
                    Icons.person,
                  ),
                  border:
                      const OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              TextField(
                controller:
                    _bioController,
                maxLines: 4,
                maxLength: 150,
                textInputAction:
                    TextInputAction.newline,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration:
                    InputDecoration(
                  labelText:
                      localizations.bio,
                  prefixIcon:
                      const Icon(
                    Icons.edit_note,
                  ),
                  border:
                      const OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      _isSaving
                          ? null
                          : _saveProfile,
                  child: _isSaving
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onPrimary,
                          ),
                        )
                      : Text(
                          localizations
                              .saveChanges,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}