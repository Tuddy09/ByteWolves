import 'package:byte_wolves/screens/signup_screen.dart';
import 'package:byte_wolves/service/logging_service.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '/constants/constants.dart';
import 'levels_map.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogInScreen> {
  final TextEditingController _usernameTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();

  bool? _rememberMe = false;

  void _signUpButtonPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  Widget _buildUsernameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Username',
          style: CustomTextStyles.labelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: CustomBoxDecorations.boxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _usernameTextFieldController,
            keyboardType: TextInputType.name,
            style: CustomTextStyles.textFieldTextStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your username',
              hintStyle: CustomTextStyles.hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: CustomTextStyles.labelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: CustomBoxDecorations.boxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordTextFieldController,
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: CustomTextStyles.hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {}, // TODO
        child: const Text(
          'Forgot Password?',
          style: CustomTextStyles.labelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          const Text(
            'Remember me',
            style: CustomTextStyles.labelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLogInButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String username = _usernameTextFieldController.text;
          String password = _passwordTextFieldController.text;
          if (username.isEmpty || password.isEmpty) {
            // Show an error message if the fields are empty.
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please fill in all the fields.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            //send the user credentials to the server
            User user = User(
                id: 0,
                email: '$username@byte-wolves.com',
                username: username,
                password: password,
                lectures: 0,
                experience: 0,
                level: 1);
            signIn(user).then((value) {
              user = value;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LevelMapPage(
                      currentLevel: value.level.toDouble(), user: user)));
            }).catchError((error) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(error.toString()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            });
          }
        },
        child: const Text(
          'Log In',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 0.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildNewAccountButton() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
          width: double.infinity,
          child: Center(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an Account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _signUpButtonPressed,
            child: const Text(
              'Create new account',
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 0.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // When the keyboard is up, if the screen is pressed then the keyboard is closed.
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            CustomContainers.backgroundContainer,
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 60.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 10),
                            blurRadius: 6.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(ImagesConstants.logoImage),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Byte Wolves',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _buildUsernameTextField(),
                    const SizedBox(height: 20.0),
                    _buildPasswordTextField(),
                    _buildForgotPasswordButton(),
                    _buildRememberMeCheckbox(),
                    _buildLogInButton(),
                    _buildNewAccountButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
