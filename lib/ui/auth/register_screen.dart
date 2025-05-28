import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/model/position.dart';
import 'package:hoteque_app/core/data/networking/states/position_result_state.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/core/provider/position/position_provider.dart';
import 'package:hoteque_app/core/style/theme.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();
  bool _obscurePassword = true;
  Position? _selectedPosition;

  @override
  void initState() {
    super.initState();
    // Muat data posisi saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PositionProvider>().getAllPositions();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _submitRegisterForm() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final Employee employee = Employee(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        position: _selectedPosition!.positionName,
      );

      final result = await authProvider.register(employee);
      if (result.data != null && !result.data!.error) {
        widget.onRegister();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message ?? "Daftar akun berhasil")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? "Gagal Daftar Akun"),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } else if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mohon pilih posisi/jabatan Anda"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showPositionSearchDialog() {
    _searchController.text = "";

    // Reset state jika perlu
    context.read<PositionProvider>().resetState();

    // Muat data posisi
    context.read<PositionProvider>().getAllPositions();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Pilih Posisi / Jabatan'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari jabatan...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Update search query
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    Flexible(
                      child: Consumer<PositionProvider>(
                        builder: (context, provider, child) {
                          return Builder(
                            builder: (context) {
                              final state = provider.state;

                              // Handle different states
                              if (state is PositionInitialState) {
                                return Center(
                                  child: Text("Memuat data jabatan..."),
                                );
                              } else if (state is PositionLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is PositionErrorState) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        state.message,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          provider.getAllPositions();
                                        },
                                        child: Text("Coba Lagi"),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (state is PositionLoadedState) {
                                final filteredPositions = provider
                                    .searchPositions(_searchController.text);

                                if (filteredPositions.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          color: Colors.grey,
                                          size: 48,
                                        ),
                                        SizedBox(height: 16),
                                        Text("Jabatan tidak ditemukan"),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredPositions.length,
                                  itemBuilder: (context, index) {
                                    final position = filteredPositions[index];
                                    return ListTile(
                                      title: Text(position.positionName),
                                      subtitle: Text(position.departmentName),
                                      onTap: () {
                                        _selectedPosition = position;
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              }

                              // Fallback jika terjadi state yang tidak dihandle
                              return Center(child: Text("Terjadi kesalahan"));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('BATAL'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Trigger rebuild untuk memperbarui UI dengan posisi yang dipilih
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/icon/logo-hotelqu.png", height: 80),

                    SizedBox(height: 16.0),

                    Text(
                      "Registrasi Pegawai",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8.0),

                    Text(
                      "Silahkan buat akun Anda",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32.0),

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

                    SizedBox(height: 16.0),

                    TextFormField(
                      controller: _emailController,
                      decoration: customInputDecoration(
                        label: "Email",
                        prefixIcon: Icons.email_outlined,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mohon masukkan email Anda";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Mohon masukkan alamat email yang valid";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.0),

                    TextFormField(
                      controller: _passwordController,
                      decoration: customInputDecoration(
                        label: "Password",
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
                        if (value == null || value.isEmpty) {
                          return "Mohon masukkan nama Anda";
                        }
                        if (value.length < 6) {
                          return "Kata sandi harus minimal 6 karakter";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.0),

                    TextFormField(
                      controller: _phoneController,
                      decoration: customInputDecoration(
                        label: "No Handphone",
                        prefixIcon: Icons.phone,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mohon masukkan nomor handphone Anda";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.0),

                    // Posisi/Jabatan Input dengan Button yang membuka dialog
                    InkWell(
                      onTap: _showPositionSearchDialog,
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedPosition != null
                                    ? "${_selectedPosition!.positionName} (${_selectedPosition!.departmentName})"
                                    : "Pilih Posisi / Jabatan",
                                style: TextStyle(
                                  color:
                                      _selectedPosition != null
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.0),

                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return ElevatedButton(
                          onPressed:
                              authProvider.isLoadingRegister
                                  ? null
                                  : _submitRegisterForm,
                          child:
                              authProvider.isLoadingRegister
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    "DAFTAR",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        );
                      },
                    ),
                    SizedBox(height: 24.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun?",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        TextButton(
                          onPressed: widget.onLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(8.0),
                            minimumSize: Size(50.0, 30.0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text("Login"),
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
