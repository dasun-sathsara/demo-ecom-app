import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthStatus {
  final bool isLoggedIn;

  AuthStatus(this.isLoggedIn);
}

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    return AuthStatus(false);
  }

  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  String get token => _token!;
  String get userId => _userId!;

  Future<void> _authenticate({required String email, required String password, required String urlSegment}) async {
    final url =
        Uri.https('identitytoolkit.googleapis.com', urlSegment, {'key': 'AIzaSyANVMiwzGZEJ9SjfVpyw3zl-MXCXdFaJoA'});

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogout();
      state = AuthStatus(true);
    } catch (error) {
      rethrow;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _logoutTimer?.cancel();
    _logoutTimer = null;

    state = AuthStatus(false);
  }

  void _autoLogout() {
    _logoutTimer = Timer(Duration(seconds: _expiryDate!.difference(DateTime.now()).inSeconds), () {
      logout();
    });
  }

  Future<void> signup({required String email, required String password}) async {
    return _authenticate(email: email, password: password, urlSegment: '/v1/accounts:signUp');
  }

  Future<void> login({required String email, required String password}) async {
    return _authenticate(email: email, password: password, urlSegment: '/v1/accounts:signInWithPassword');
  }
}
