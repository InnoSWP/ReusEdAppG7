import 'package:flutter/material.dart';

class ResetForm extends StatefulWidget {
  const ResetForm({Key? key}) : super(key: key);

  // final void Function(
  //   BuildContext ctx,
  // ) submitFunction;
  // final bool isLoading;
  // const ResetForm(this.submitFunction, this.isLoading, {Key? key})
  //     : super(key: key);

  @override
  State<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _formKey = GlobalKey<FormState>();

  void _trySubmission() {
    // final isValid = _formKey.currentState!.validate();
    // FocusScope.of(context).unfocus();
    // if (isValid) {
    //   _formKey.currentState!.save();
    //   widget.submitFunction(
    //     _userEmail.trim(),
    //     _userPassword.trim(),
    //     _userName.trim(),
    //     _dropdownValue,
    //     _isLoginMode,
    //     context,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: Column(
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
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('email'),
                  onSaved: (value) {},
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
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _trySubmission,
          child: const Text("Send reset link"),
        ),
      ],
    ));
  }
}
