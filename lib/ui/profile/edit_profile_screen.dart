import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/core/provider/profile/update_profile_provider.dart';
import 'package:hoteque_app/core/style/theme.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  bool _isInitialized = false;
  bool _isLoading = true;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (_isInitialized) return;

    final profileProvider = Provider.of<UpdateProfileProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    if (profileProvider.name.isEmpty) {
      // Jika profile belum diambil, ambil dulu dari API
      await profileProvider.getProfile(employee: authProvider.employee!);
    }

    // Isi data ke text controller
    _nameController.text = profileProvider.name;
    _phoneController.text = profileProvider.phone;
    // Password tidak diisi karena bersifat privasi

    setState(() {
      _isLoading = false;
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final profileProvider = Provider.of<UpdateProfileProvider>(
        context,
        listen: false,
      );

      // Ambil nilai dari controller
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final password =
          _passwordController.text.isEmpty ? null : _passwordController.text;

      // Update profile
      final success = await profileProvider.updateProfile(
        employee: authProvider.employee!,
        name: name,
        phone: phone,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        // Navigate back and refresh home screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile berhasil diperbarui")),
        );

        Navigator.pop(
          context,
          true,
        ); // Pass true sebagai indicator untuk refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal memperbarui profile: ${profileProvider.errorMessage}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFA87640),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final profileProvider = Provider.of<UpdateProfileProvider>(
              context,
              listen: false,
            );
            if (profileProvider.photoFile != null) {
              profileProvider.resetPhotoFile();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer2<UpdateProfileProvider, AuthProvider>(
                builder: (context, profileProvider, authProvider, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Avatar
                            _buildProfileAvatar(profileProvider),

                            // Change photo button
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await profileProvider.pickImage();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: customInputDecoration(
                                  label: "Nama Lengkap",
                                  prefixIcon: Icons.person_outline,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Mohon masukkan nama Anda";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordController,
                                decoration: customInputDecoration(
                                  label: "Password (Optional)",
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length < 6) {
                                    return "Password harus minimal 6 karakter";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: _phoneController,
                                decoration: customInputDecoration(
                                  label: "No Handphone",
                                  prefixIcon: Icons.phone,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Mohon masukkan nomor handphone Anda";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              profileProvider.isUpdating
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF86572D),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "Simpan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                        // Error message
                        if (profileProvider.isError)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              profileProvider.errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  // Widget untuk menampilkan avatar (foto profil)
  Widget _buildProfileAvatar(UpdateProfileProvider provider) {
    // Jika user memilih foto baru, tampilkan itu
    if (provider.photoFile != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(provider.photoFile!),
      );
    }

    // Jika user punya foto profil yang sudah ada
    if (provider.hasPhoto) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: const Color(0xFFD2B48C),
        backgroundImage: NetworkImage(provider.photoUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Handle error loading image
          debugPrint("Error loading profile image: $exception");
        },
      );
    }

    // Jika tidak ada foto, tampilkan ikon person
    return CircleAvatar(
      radius: 50,
      backgroundColor: const Color(0xFFD2B48C),
      child: Icon(Icons.person, size: 60, color: Colors.white),
    );
  }
}
