import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MotoApp/router.dart';
import 'package:MotoApp/styles/colors.dart';
import 'package:MotoApp/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../styles/styles.dart';
import 'package:form_field_validator/form_field_validator.dart';
/*
Future<user.dart> updateUser(String title) async {
  final http.Response response = await http.put(
    'https://jsonplaceholder.typicode.com/Users/1',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return user.dart.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update user.dart.');
  }
}

class User {
  final String userId;
  final String fullName;

  User({this.userId, this.fullName});

  User.fromJson(Map<String, dynamic> json)
    :
      userId= json['userId'],
      fullName= json['fullName'];

  Map<String, dynamic> toJson()=>{
    'userId': userId,
    'fullName': fullName,
  };

}
*/

class MainMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User user;
  String username;
  String userpass;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<User> fetchUser() async {
    print("username=" + username);
    String url = 'https://mehranishanian.com/userlogin.php?u=' +
        username +
        '&p=' +
        userpass;
    print(url);
    final response = await http.get(url);
    //print(response);
//print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
//    print(json.decode(response.body));
      if (response.body != "") {
        print("get response --" + response.body + "--");
        user = User.fromJson(json.decode(response.body));
        print(user.firstName); //+ ' ' + user.lastName
      } else {
        print("No User Found!");
        user = null;
      }
      return user;
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
        elevation: 0.0,
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
              Navigator.of(context).pushNamed(RegisterRoute);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Sign Up",
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
                  "Log In",
                  style: _theme.textTheme.title.merge(
                    TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _loginForm(context),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Or connect using social account",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {},
                        color: facebookColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.facebookSquare,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Facebook",
                                textAlign: TextAlign.center,
                                style: _theme.textTheme.body1.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: _theme.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(3.0)),
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {},
                        color: _theme.scaffoldBackgroundColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: _theme.primaryColor,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Phone number",
                                textAlign: TextAlign.center,
                                style: _theme.textTheme.body1.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              username = value.trim();
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your username',
              labelText: "User name",
            ),
            validator: requiredValidator,
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              userpass = value.trim();
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your password',
              labelText: "Password",
            ),
            validator: requiredValidator,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Forgot password?",
            style: TextStyle(
                color: _theme.primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            child: FlatButton(
              color: _theme.primaryColor,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  User user = await fetchUser();
                  print(user);
                  // print("response=");

                  if (user != null) {
//                print(user.fullName);
                    String userId = user.userId;

                    // SharedPreferences prefs = SharedPreferences.getInstance();
                    // prefs.setString('userId', userId);

                    //print(user.fullName);

                    Navigator.of(context).pushReplacementNamed(HomepageRoute);
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Authentication Error"),
                          content: Text(
                              "Username or Password is wrong. Please try again."),
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
              },
              child: Text(
                "LOG IN",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
