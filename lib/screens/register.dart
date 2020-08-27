import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uberr/router.dart';
import 'package:uberr/styles/colors.dart';
import 'package:uberr/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

// https://mehranishanian.com/userregister.php?=firstName'+firstName+'&lastName='+lastName+'&phone='+phone+'&email='+email+'&userName='+userName+'&userPass='+userPass+'
// firstName, lastName, phone, email, userName, userPass

class User {
  final String firstName;
  final String lastName;
   String phone;
   String email;
   String userName;
   String userPass;


  User(this.firstName, this.lastName, this.phone, this.email, this.userName,
      this.userPass);

  User.fromJson(Map<String, dynamic> json)
      :
        firstName= json['firstName'],
        lastName= json['lastName'];
//        phone= json['phone'],
//        email= json['email'];
//        userName= json['userName'],
//        userPass= json['userPass'];


  Map<String, dynamic> toJson()=>{
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'userName': userName,
    'userPass': userPass,

  };

}

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




  void fetchUser() async {
    String url='// https://mehranishanian.com/userregister.php?=firstName'+firstName+'&lastName='+lastName+'&phone='+phone+'&email='+email+'&userName='+userName+'&userPass='+userPass+'';
    final response =
    await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
//    print(json.decode(response.body));
      if(response!=null) {
        user = User.fromJson(json.decode(response.body));

        print(user.firstName);

      }else{
        user=null;
      }


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
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
                    fetchUser();

                    Navigator.of(context).pushNamed(OtpVerificationRoute);
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
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                hintText: "First name",

              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Last name",
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Email",
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[

//            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Phone number",
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Password",
        ),
        SizedBox(
          height: 25.0,
        ),
        Text(
          "By clicking \"Sign Up\" you agree to our terms and conditions as well as our pricacy policy",
          style: TextStyle(fontWeight: FontWeight.bold, color: dbasicDarkColor),
        )
      ],
    );
  }
}
