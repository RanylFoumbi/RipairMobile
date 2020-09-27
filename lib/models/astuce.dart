
class Astuce{

  String name;
  String content;
  String videoUrl;
  List images;
  String date;
  String domain;
  List rating;
  String id;

  Astuce({
    this.name,
    this.date,
    this.content,
    this.videoUrl,
    this.images,
    this.rating,
    this.domain,
    this.id
  });

  factory Astuce.fromJson(Map json) {
    return Astuce(
      name: json['name'] ?? '',
      content: json['content'] ?? "",
      id: json['_id'] ?? "",
      videoUrl: json['videoUrl'] ?? "",
      images: json['images'] ?? "",
      rating: json['rating'] ?? "",
      date: json['date'] ?? "",
      domain: json['domain'] ?? "",
    );
  }

  Map toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['content'] = this.content;
    data['_id'] = this.id;
    data['videoUrl'] = this.videoUrl;
    data['images'] = this.images;
    data['rating'] = this.rating;
    data['date'] = this.date;
    data['domain'] = this.domain;
    return data;
  }

//
//  static List<Astuce> astuceList = <Astuce>[
//    Astuce(
//      name: "Comment réparer une fuite d'eau en 11 étapes.",
//      content: "1 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "2 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul "
//      "3 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul "
//      "4 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul "
//      "5 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul ",
//      date: "Mardi 12 Aout 2020",
//      hasVideo: true,
//      nbrOfLike: 2,
//      previewImg: "assets/images/ranolf.jpeg",
//      videoUrl: "",
//      domain: "Electicite"
//    ),
//      Astuce(
//      name: "Comment réparer une fuite d'eau en 11 étapes.",
//      content: "1 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul ",
//      date: "Mardi 12 Aout 2020",
//      hasVideo: true,
//      nbrOfLike: 2,
//      previewImg: "assets/images/ranolf.jpeg",
//      videoUrl: "",
//      domain: "Plomberie"
//    ),
//      Astuce(
//      name: "Comment réparer une fuite d'eau en 11 étapes.",
//      content: "1 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul ",
//      date: "Mardi 12 Aout 2020",
//      hasVideo: true,
//      nbrOfLike: 4,
//      previewImg: "assets/images/ranolf.jpeg",
//      videoUrl: "",
//      domain: "Menuiserie"
//    ),
//      Astuce(
//      name: "Comment réparer une fuite d'eau en 11 étapes.",
//      content: "1 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul ",
//      date: "Mardi 12 Aout 2020",
//      hasVideo: true,
//      nbrOfLike: 2,
//      previewImg: "assets/images/ranolf.jpeg",
//      videoUrl: "",
//      domain: "Electicite"
//    ),
//     Astuce(
//      name: "Comment réparer une fuite d'eau en 11 étapes.",
//      content: "1 - Coupez l'arrivée générale de l'eau"
//      "Première étape : commencez par couper l’arrivée d’eau"
//      "générale de votre logement afin de stopper l’écoulement de la fuite d’eau."
//      "Si votre fuite d’eau se situe sur une canalisation enterrée ou encastrée, seul ",
//      date: "Mardi 12 Aout 2020",
//      hasVideo: true,
//      nbrOfLike: 2,
//      previewImg: "assets/images/ranolf.jpeg",
//      videoUrl: "",
//      domain: "Plomberie"
//    ),
//  ];

}

