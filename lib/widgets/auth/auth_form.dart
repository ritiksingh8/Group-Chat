import 'dart:io';
import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool _isLoading;

  AuthForm(this.submitFn, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  var _userEmail = '';
  var _username = '';
  var _userPassword = '';
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Pick an image!',
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      print(_userEmail);
      print(_username);
      print(_userPassword);
    }
    widget.submitFn(
      _userEmail.trim(),
      _userPassword.trim(),
      _username.trim(),
      _userImageFile,
      _isLogin,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Username must be atleast 4 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create a New Account!'
                            : 'Already have an account?',
                      ),
                      textColor: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
