import 'package:flutter/material.dart';
import 'package:reused_flutter/screens/login/reset_form.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    String role,
    bool isLogin,
    BuildContext ctx,
  ) submitFunction;
  final bool isLoading;
  const AuthForm(this.submitFunction, this.isLoading, {Key? key})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginMode = true;
  String _dropdownValue = 'Teacher';
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmission() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFunction(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _dropdownValue,
        _isLoginMode,
        context,
      );
    }
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ResetForm()));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        SizedBox(height: mediaQuery.size.height / 5),
        const Text(
          'ReusEd',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: mediaQuery.size.height / 10),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!_isLoginMode)
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: const ValueKey('username'),
                    onSaved: (value) {
                      _userName = value as String;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username should not be empty';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('email'),
                  onSaved: (value) {
                    _userEmail = value as String;
                  },
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('password'),
                  onSaved: (value) {
                    _userPassword = value as String;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                if (!_isLoginMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Role:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _dropdownValue,
                        elevation: 16,
                        style: const TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 1,
                          color: Colors.blue,
                        ),
                        items: <String>['Teacher', 'Student']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (widget.isLoading)
          const CircularProgressIndicator()
        else
          ElevatedButton(
            onPressed: _trySubmission,
            child: _isLoginMode ? const Text("Log In") : const Text("Sign Up"),
          ),
        if (!_isLoginMode)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = true;
                    });
                  },
                  child: const Text("Log in")),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = false;
                    });
                  },
                  child: const Text("Sign up")),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Forgot password?"),
            TextButton(
                onPressed: () {
                  // Navigate to reset_form screen
                  _navigateToNextScreen(context);
                },
                child: const Text("Reset password")),
          ],
        )
      ],
    );
  }
}
