import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/datasource/auth_local_datasource.dart';
import 'package:flutter_pos/presentation/checkout/auth/bloc/login/login_bloc.dart';
import 'package:flutter_pos/presentation/pos/pages/pos_page.dart';
import '../widgets/custom_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String getErrorMessage(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded['message'] ?? raw;
    } catch (e) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              color: Colors.grey[900],
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo di atas
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png', // pastikan sudah di `pubspec.yaml`
                          height: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomField(
                      controller: _emailController,
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    const SizedBox(height: 20),
                    CustomField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.key),
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          AuthLocalDatasource().saveAuthData(state.authResponseModel);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const PosPage()),
                          );
                        }

                        if (state is LoginFailure) {
                          final errorMessage = getErrorMessage(state.message);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(LoginButtonPressed(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    )
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
