import 'package:flutter/material.dart';

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
    final String fullName =
        _nameController.text.trim();

    final String bio =
        _bioController.text.trim();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your name',
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
            'Unable to update profile: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller:
                    _nameController,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon:
                      Icon(Icons.person),
                  border:
                      OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller:
                    _bioController,
                maxLines: 4,
                maxLength: 150,
                decoration:
                    const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon:
                      Icon(Icons.edit_note),
                  border:
                      OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      _isSaving
                          ? null
                          : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
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