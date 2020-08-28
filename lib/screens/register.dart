import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:MotoApp/router.dart';
import 'package:MotoApp/styles/colors.dart';
import 'package:MotoApp/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../styles/styles.dart';
import 'package:form_field_validator/form_field_validator.dart';

// firstName, lastName, phone, email, userName, userPass

class MainMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  User user;
  String firstName;
  String lastName;
  String phone;
  String email;
  String userName;
  String userPass;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void registerUser() async {
    print('FirstName=' + firstName);
    String url = 'https://mehranishanian.com/userregister.php?firstName=' +
        firstName +
        '&lastName=' +
        lastName +
        '&phone=' +
        phone +
        '&email=' +
        email +
        '&userName=' +
        email +
        '&userPass=' +
        userPass;
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
//    print(json.decode(response.body));
      if (response != null) {
        //   user = User.fromJson(json.decode(response.body));

        print(response.body);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Register Error"),
                content: Text("Registration is incorrect. Please try again."),
                actions: [
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user.dart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: _theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(LoginRoute);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: _theme.primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Sign Up",
                  style: _theme.textTheme.title.merge(
                    TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _signupForm(),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 30.0),
                height: 45.0,
                child: FlatButton(
                  color: _theme.primaryColor,
                  onPressed: () {
                    //////////////////////////////////////////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                    if (_formKey.currentState.validate()) {
////                    If the form is valid, display a Snackbar.
                      print("sign up pressed");
                      registerUser();
                    }

                    // registerUser();

                    //  Navigator.of(context).pushNamed(OtpVerificationRoute);
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                    onChanged: (value) {
                      firstName = value.trim();
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'First name',
                      labelText: "First name",
                    ),
                    validator: requiredValidator),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: TextFormField(
                    onChanged: (value) {
                      lastName = value.trim();
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Last name',
                      labelText: "Last name",
                    ),
                    validator: requiredValidator),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onChanged: (value) {
              phone = value.trim();
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Phone number',
              labelText: "Phone number",
            ),
            validator: requiredValidator,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            onChanged: (value) {
              email = value.trim();
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Email',
              labelText: "Email",
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: 'email is required'),
              EmailValidator(errorText: 'enter a valid email address'),
            ]),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            onChanged: (value) {
              userPass = value.trim();
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Password',
              labelText: "Password",
            ),
            obscureText: true,
            validator: MultiValidator([
              RequiredValidator(errorText: 'password is required'),
              MinLengthValidator(8,
                  errorText: 'password must be at least 8 digits long'),
            ]),
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            "By clicking \"Sign Up\" you agree to our terms and conditions as well as our pricacy policy",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: dbasicDarkColor),
          )
        ],
      ),
    );
  }
}
