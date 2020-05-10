import 'package:flutter/material.dart';

import './services.dart';
import './appearance.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AddScreen extends StatefulWidget {
  Profile profile;

  AddScreen({this.profile});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool _isLoading = false;
  Services _services = Services();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.profile.name;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.profile.email;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.profile.age.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Add Data" : "Update Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldEmail(),
                _buildTextFieldAge(),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        if (_isFieldNameValid == null ||
                            _isFieldEmailValid == null ||
                            _isFieldAgeValid == null ||
                            !_isFieldNameValid ||
                            !_isFieldEmailValid ||
                            !_isFieldAgeValid) {
                          _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Please Fill All The Data"),
                            ),
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        String name = _controllerName.text.toString();
                        String email = _controllerEmail.text.toString();
                        int age = int.parse(_controllerAge.text.toString());
                        Profile profile =
                            Profile(name: name, email: email, age: age);
                        if (widget.profile == null) {
                          _services.createProfile(profile).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.pop(
                                  _scaffoldState.currentState.context);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Data Failed To Add"),
                              ));
                            }
                          });
                        } else {
                          profile.id = widget.profile.id;
                          _services.updateProfile(profile).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.pop(
                                  _scaffoldState.currentState.context);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Data Failed To Update"),
                              ));
                            }
                          });
                        }
                      },
                      child: Text(
                        widget.profile == null
                            ? "Save".toUpperCase()
                            : "Update".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blueGrey,
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full Name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full Name Mustn't Be Blank",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email Required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Age",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Age Required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }
}
