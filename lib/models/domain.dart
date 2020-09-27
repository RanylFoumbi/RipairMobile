


class Domain{
  String id;
  String name;

  Domain({
    this.id,
    this.name
  });


  Domain.fromJson(Map<String, dynamic> json) {
    id =  json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}