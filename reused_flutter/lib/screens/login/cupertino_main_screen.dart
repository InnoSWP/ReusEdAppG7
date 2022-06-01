import 'package:flutter/cupertino.dart';

class CupertinoLoginScreen extends StatefulWidget {
  const CupertinoLoginScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoLoginScreen> createState() => _CupertinoLoginScreenState();
}

class _CupertinoLoginScreenState extends State<CupertinoLoginScreen> {
  String dropdownValue = 'Teacher';
  bool _isLogIn = true;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return CupertinoPageScaffold(
      child: Column(
        children: [
          SizedBox(height: mediaQuery.size.height / 6),
          const Text(
            'ReusEd',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          SizedBox(height: mediaQuery.size.height / 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (!_isLogIn)
                  CupertinoTextFormFieldRow(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: const ValueKey('username'),
                    // decoration: const InputDecoration(
                    //   labelText: 'Username',
                    // ),
                  ),
                CupertinoTextFormFieldRow(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('email'),
                  // decoration: const InputDecoration(
                  //   labelText: 'E-mail',
                  // ),
                ),
                CupertinoTextFormFieldRow(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('password'),
                  // decoration: const InputDecoration(
                  //   labelText: 'Password',
                  // ),
                ),
                // if (!_isLogIn)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       const Text('Role:'),
                //       const SizedBox(width: 16),
                //       DropdownButton<String>(
                //         value: dropdownValue,
                //         elevation: 16,
                //         style: const TextStyle(color: Colors.blue),
                //         underline: Container(
                //           height: 2,
                //           color: Colors.blue,
                //         ),
                //         items: <String>['Teacher', 'Student']
                //             .map<DropdownMenuItem<String>>((String value) {
                //           return DropdownMenuItem<String>(
                //             value: value,
                //             child: Text(value,
                //                 style: const TextStyle(color: Colors.black)),
                //           );
                //         }).toList(),
                //         onChanged: (newValue) {
                //           setState(() {
                //             dropdownValue = newValue!;
                //           });
                //         },
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
          CupertinoButton(
            child: _isLogIn ? const Text("Log In") : const Text("Sign Up"),
            onPressed: () {},
          ),
          if (!_isLogIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = true;
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
                CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = false;
                      });
                    },
                    child: const Text("Sign up")),
              ],
            ),
        ],
      ),
    );
  }
}
