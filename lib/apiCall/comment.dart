import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oneHelp/utilities/config/server.dart';

class CommentApi{

  Future fetchComment(String techId) async {
    var result = await http.get((baseUrl + "/api/comment/${techId}/all"));
    print(result.body);
    return json.decode(result.body)['comments'].toList();
  }


  Future<http.Response> postComment(comment)async{
    const url = baseUrl + "/api/comment/new";
    return await http.post(url, body: json.encode(comment), headers: { 'Content-type': 'application/json','Accept': 'application/json',"Authorization": "Some token"});
  }

}