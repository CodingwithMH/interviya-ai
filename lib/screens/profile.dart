import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/data/providers/user_provider.dart';
import 'package:interviya/data/services/auth_service.dart';
import 'package:interviya/data/services/cloudinary_service.dart';
import 'package:interviya/widgets/custom_appbar.dart';
import 'package:interviya/widgets/edit_profile_dialog.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final VoidCallback onBack;
  const Profile({super.key, required this.onBack});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoggingOut = false;
  final _picker = ImagePicker();

  void _handleLogout() async {
    setState(() => _isLoggingOut = true);

    String? result = await AuthService().signOutUser();

    if (mounted) setState(() => _isLoggingOut = false);

    if (result == "success") {
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/signin', (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout failed: $result"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _updateProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    String? imageUrl = await CloudinaryService.uploadImage(file);
    if (imageUrl == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to upload image")));
      }
      return;
    }

    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.updateAvatar(imageUrl);

    try {
      final uid = userProvider.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'avatarPath': imageUrl,
        });

        debugPrint("Avatar image updated successfully in database.");
      }
    } catch (e) {
      debugPrint("Failed to persist avatar selection path payload: $e");
    }
  }

  Future<void> _showEditProfileDialog(UserModel currentUser) async {
    final Map<String, String>? updatedData =
        await showDialog<Map<String, String>>(
          context: context,
          barrierDismissible: false,
          builder: (context) => EditProfileDialog(currentUser: currentUser),
        );

    if (updatedData != null && mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      userProvider.updateProfileFields(
        fullName: updatedData['fullName'],
        targetRole: updatedData['targetRole'],
        experienceLevel: updatedData['experienceLevel'],
      );

      try {
        final uid = currentUser.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'fullName': updatedData['fullName'],
            'targetRole': updatedData['targetRole'],
            'experienceLevel': updatedData['experienceLevel'],
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
          }
        }
      } catch (e) {
        debugPrint("Failed to sync edited profile fields with database: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: CustomAppbar(text: "Profile", onBack: widget.onBack),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),

            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0A898D), Color(0xFF032627)],
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            (user?.avatarPath != null &&
                                user!.avatarPath!.isNotEmpty)
                            ? NetworkImage(user.avatarPath!) as ImageProvider
                            : const AssetImage("assets/images/user.png"),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _updateProfilePicture,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.edit, color: Colors.orange, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Full Name:", user?.fullName ?? "N/A"),
                        _buildDetailRow(
                          "Target Role:",
                          user?.targetRole ?? "Not Set",
                        ),
                        _buildDetailRow(
                          "Experience Level:",
                          user?.experienceLevel ?? "Not Set",
                        ),
                        _buildDetailRow(
                          "Email:",
                          user?.email ?? "N/A",
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -25,
                    right: 20,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        if (user != null) {
                          _showEditProfileDialog(user);
                        }
                      },
                      backgroundColor: Color(0xFF0A898D),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55, // Premium modern form button height
                child: ElevatedButton.icon(
                  onPressed: _isLoggingOut ? null : _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E8F0),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.redAccent,
                          ),
                        )
                      : const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                        ),
                  label: Text(
                    _isLoggingOut ? "Logging out..." : "Log Out",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff1E293B),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
