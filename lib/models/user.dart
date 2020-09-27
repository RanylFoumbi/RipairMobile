


class User{

  String id;
  String name;
  String lastname;
  String email;
  String sexe;
  String town;
  String role;
  String date;
  List phone;
  List languages;
  String techPic;
  String quarter;
  String birthday;
  List professions;
  List rating;
  int nbrOfCall;
  int nbrOfComment;
  String description;
  bool isSuspended;
  String profileImage;
  int numberOfStars;

  User({
    this.id,
    this.name,
    this.lastname,
    this.sexe,
    this.town,
    this.role,
    this.email,
    this.phone,
    this.techPic,
    this.quarter,
    this.birthday,
    this.languages,
    this.professions,
    this.description,
    this.isSuspended,
    this.profileImage,
    this.rating,
    this.nbrOfCall,
    this.nbrOfComment,
    this.date
  });


  factory User.fromJson(Map json) {
    return User(
      id: json['_id'] as String,
      name: json['name'] as String,
      lastname: json['lastname'] as String,
      sexe: json['sexe'] as String,
      email: json['email'] as String,
      quarter: json['quarter'] as String,
      town: json['town'] as String,
      role: json['role'] as String,
      phone: json['phone'] as List,
      techPic: json['techPic'] as String,
      birthday: json['birthday'] as String,
      languages: json['languages'] as List,
      professions: json['professions'] as List,
      description: json['description'] as String,
      isSuspended: json['isSuspended'] as bool,
      profileImage: json['profileImage'] as String,
      rating: json['rating'] as List,
      nbrOfCall: json['nbrOfCall'] as int,
      nbrOfComment: json['nbrOfComment'] as int,
      date: json['date'] as String,
    );
  }


//  Map toJson() {
//    final Map<String,dynamic> data = new Map<String,dynamic>();
//    data['_id'] = this.id;
//    data['name'] = this.name;
//    data['lastname'] = this.lastname;
//    data['sexe'] = this.sexe;
//    data['phone'] = this.phone;
//    data['role'] = this.role;
//    data['email'] = this.email;
//    data['quarter'] = this.quarter;
//    data['date'] = this.date;
//    data['town'] = this.town;
//    data['professions'] = this.professions;
//    data['languages'] = this.languages;
//    data['birthday'] = this.birthday;
//    data['techPic'] = this.techPic;
//    data['description'] = this.description;
//    data['isSuspended'] = this.isSuspended;
//    data['profileImage'] = this.profileImage;
//    data['numberOfStars'] = this.numberOfStars;
//    return data;
//  }

}

