class User{
  String name;
  String email;
  String phoneNumber;

  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String,dynamic> toJson() {
    final key = email.replaceAll('@eng.asu.edu.eg', '');
    return {
     key:{
        'email':email,
        'name':name,
        'phoneNumber':phoneNumber, 
     }
    };
  }

}