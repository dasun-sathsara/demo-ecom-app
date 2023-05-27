import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopapp/providers.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_screen.dart';

enum AuthMode { signIn, signUp }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  var _authMode = AuthMode.signIn;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _formData = {'email': '', 'password': ''};
  var _isLoading = false;

  // late AnimationController _animationController;
  // late Animation<Size> _heightAnimation;

  @override
  void initState() {
    // _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    // _heightAnimation = Tween(begin: const Size(double.infinity, 280), end: const Size(double.infinity, 320))
    //     .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: const Text('An Error Occurred!'),
          icon: const Icon(
            Icons.error,
            size: 30,
          ),
          iconColor: Theme.of(context).colorScheme.error,
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                child: const Text(
                  'Okay',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ]),
    );
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_authMode == AuthMode.signIn) {
          await ref
              .read(authProvider.notifier)
              .login(email: _formData['email']!, password: _formData['password']!);
        } else {
          await ref
              .read(authProvider.notifier)
              .signup(email: _formData['email']!, password: _formData['password']!);
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed.';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address.';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        print(error);
        const errorMessage = 'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.isLoggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ProductsScreen()), (route) => true);
      }
    });
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo

                SizedBox(
                  height: 180,
                  child: FittedBox(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                //Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Email Field
                      CustomFormField(
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          obsucreText: false,
                          prefixIcon: const Icon(Icons.email),
                          controller: null,
                          validator: (value) {
                            var emailRegex =
                                RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');

                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            } else if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _formData['email'] = value!;
                          }),
                      const SizedBox(
                        height: 15,
                      ),

                      //Password Field
                      CustomFormField(
                          labelText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          obsucreText: true,
                          prefixIcon: const Icon(Icons.password),
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value.length < 6) {
                              return 'Password should be 6 characters or long';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _formData['password'] = value!;
                          }),
                      const SizedBox(
                        height: 15,
                      ),

                      //Confirm Password
                      if (_authMode == AuthMode.signUp)
                        CustomFormField(
                            labelText: 'Confirm Password',
                            keyboardType: TextInputType.visiblePassword,
                            obsucreText: true,
                            prefixIcon: const Icon(Icons.password),
                            controller: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm the typed password';
                              } else if (_passwordController.text != value) {
                                return 'Passwords do not match';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {}),
                      const SizedBox(
                        height: 15,
                      ),

                      //Login or Sign Up Button

                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.pink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                          shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          enableFeedback: true,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    height: 17,
                                    width: 17,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _authMode == AuthMode.signIn ? 'Log In' : 'Sign Up',
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                          ),
                        ),
                      ),

                      Container(
                          padding: const EdgeInsets.only(top: 12), child: const Text('OR')),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.signUp
                                ? AuthMode.signIn
                                : AuthMode.signUp;
                          });
                        },
                        style: TextButton.styleFrom(
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            minimumSize: const Size.fromHeight(45),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              _authMode == AuthMode.signIn
                                  ? 'Sign Up Instead'
                                  : 'Log In Instead',
                              style: TextStyle(
                                  fontSize: 15, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ])),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obsucreText;
  final Icon prefixIcon;
  final TextEditingController? controller;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.keyboardType,
    required this.obsucreText,
    required this.prefixIcon,
    required this.validator,
    required this.onSaved,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 17),
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorStyle: const TextStyle(fontSize: 15),
        labelText: labelText,
        floatingLabelStyle: const TextStyle(fontSize: 18),
        contentPadding: const EdgeInsets.all(8),
        border: const OutlineInputBorder(),
      ),
      obscureText: obsucreText,
      keyboardType: keyboardType,
    );
  }
}
