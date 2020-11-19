
class Astuce{

  String id;
  String name;
  List images;
  String date;
  List rating;
  String domain;
  String videoUrl;
  String firstContent;
  String secondContent;
  String thirdContent;

  Astuce({
    this.id,
    this.name,
    this.date,
    this.images,
    this.rating,
    this.domain,
    this.videoUrl,
    this.firstContent,
    this.secondContent,
    this.thirdContent,
  });

  factory Astuce.fromJson(Map json) {
    return Astuce(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      date: json['date'] ?? "",
      images: json['images'] ?? "",
      rating: json['rating'] ?? "",
      domain: json['domain'] ?? "",
      videoUrl: json['videoUrl'] ?? "",
      firstContent: json['firstContent'] ?? "",
      secondContent: json['secondContent'] ?? "",
      thirdContent: json['thirdContent'] ?? "",
    );
  }

  Map toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['date'] = this.date;
    data['images'] = this.images;
    data['rating'] = this.rating;
    data['domain'] = this.domain;
    data['videoUrl'] = this.videoUrl;
    data['firstContent'] = this.firstContent;
    data['secondContent'] = this.secondContent;
    data['thirdContent'] = this.thirdContent;
    return data;
  }

}

