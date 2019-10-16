class User{
  final String email;
  final String password;
  final String token;

  User({this.email, this.password, this.token});

  factory User.fromJson(Map<String, dynamic>json){
    return User(
      email: json['email'],
      password: json['password'],
      token: json['token']
    );
  }
}