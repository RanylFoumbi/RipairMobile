

class Comment{
  String id;
  String date;
  String content;
  String authorId;
  String technicianId;

  Comment({
    this.id,
    this.date,
    this.content,
    this.authorId,
    this.technicianId,
  });


  Comment.fromJson(Map<String, dynamic> json) {
    id =  json['_id'];
    content = json['content'];
    authorId = json['authorId'] ;
    technicianId = json['technicianId'] ;
    date = json['date'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['content'] = this.content;
    data['authorId'] = this.authorId;
    data['technicianId'] = this.technicianId;
    data['date'] = this.date;
    return data;
  }
}