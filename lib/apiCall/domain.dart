

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oneHelp/models/domain.dart';
import 'package:oneHelp/utilities/config/server.dart';

class DomainApi{

  Future fetchAllDomain()async{
    var res = await http.get((baseUrl + "/api/profession/all"));
    Iterable list = json.decode(res.body)['professions'];
    return list.map((model) => Domain.fromJson(model)).toList();
  }
}