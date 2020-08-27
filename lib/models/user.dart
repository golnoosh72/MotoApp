class User {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String userName;
  final String userPass;
  final String userId;

  User(this.userId, this.firstName, this.lastName, this.phone, this.email, this.userName,
      this.userPass);

  User.fromJson(Map<String, dynamic> json)
      : userId=json['userId'],
        firstName= json['firstName'],
        lastName= json['lastName'],
        phone= json['phone'],
        email= json['email'],
        userName= json['userName'],
        userPass= json['userPass'];


  Map<String, dynamic> toJson()=>{
    'userId':userId,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'userName': userName,
    'userPass': userPass,

  };

}