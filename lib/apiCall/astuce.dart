
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oneHelp/utilities/config/server.dart';

class AstuceApi{

  Future<http.Response> fetchAstuceList()async{
      return  await http.get((baseUrl + "/api/course/all"));
  }

  Future fetchAstuce()async{
    var res = await http.get((baseUrl + "/api/course/all"));
    Iterable list = json.decode(res.body)['courses'];
    return list;
  }

  Future<http.Response> searchAstuce(String query)async{
    return  await http.get((baseUrl + "/api/course/search/${query}"));
  }

  Future<http.Response> rateAstuce(astuceId, star)async{
    var url = baseUrl + "/api/course/rate-course/${astuceId}";
    return await http.patch(url, body: json.encode({"star": star}), headers: { 'Content-type': 'application/json'});
  }
}