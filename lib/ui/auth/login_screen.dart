import 'package:flutter/material.dart';
import 'package:hoteque_app/core/style/theme.dart';
import 'package:provider/provider.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLoginForm() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final authProvider = context.read<AuthProvider>();
      final Employee employee = Employee(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final result = await authProvider.login(
        employee.email!,
        employee.password!,
      );

      if (result.data != null) {
        widget.onLogin();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              content: Text(result.message ?? "Login successful"),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                result.message ?? "Login failed. Please try again.",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset("assets/icon/logo-hotelqu.png", height: 80),

                        SizedBox(height: 16),

                        Text(
                          "Login Pegawai",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 8.0),

                        Text(
                          "Silakan login dengan akun Anda",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 32.0),

                        TextFormField(
                          enabled: !authProvider.isLoadingLogin,
                          controller: _emailController,
                          decoration: customInputDecoration(
                            label: "Email",
                            prefixIcon: Icons.email_outlined,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mohon masukkan alamat email Anda";
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
                          enabled: !authProvider.isLoadingLogin,
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
                              return "Mohon masukkan kata sandi Anda";
                            }
                            if (value.length < 6) {
                              return "Kata sandi harus minimal 6 karakter";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              minimumSize: Size(50.0, 30.0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed:
                                authProvider.isLoadingLogin
                                    ? null
                                    : () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Fitur ini hanya tampilan antarmuka",
                                          ),
                                        ),
                                      );
                                    },

                            child: Text("Lupa kata sandi?"),
                          ),
                        ),

                        SizedBox(height: 24.0),

                        ElevatedButton(
                          onPressed:
                              authProvider.isLoadingLogin
                                  ? null
                                  : _submitLoginForm,
                          child:
                              authProvider.isLoadingLogin
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
                                  : Text("MASUK"),
                        ),

                        SizedBox(height: 24.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum memiliki akun?",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextButton(
                              onPressed:
                                  authProvider.isLoadingLogin
                                      ? null
                                      : widget.onRegister,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(8.0),
                                minimumSize: Size(50.0, 30.0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text("Daftar"),
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
      },
    );
  }
}
