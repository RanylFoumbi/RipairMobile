import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oneHelp/utilities/config/server.dart';

class UserApi{

  Future<http.Response> verifyIfUserExist(phone)async{
    return await http.get((baseUrl + "/api/technician/login/${phone}"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
  }

  Future fetchFreeTechnicianByTown(town)async{
    var res = await http.get((baseUrl + "/api/technician/searchByTown/${town}"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
    Iterable list = json.decode(res.body)['technicians'];
    return list;
  }

  Future fetchFreeTechnicianByDomain(domain)async{
    var res = await http.get((baseUrl + "/api/technician/searchByProf/${domain}"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
    Iterable list = json.decode(res.body)['technicians'];
    return list;
  }

  Future fetchAllFreeTechnician()async{
    var res = await http.get((baseUrl + "/api/technician/allfree"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
    Iterable list = json.decode(res.body)['technicians'];
    return list;
  }

  Future fetchAllFreeTechByDomainTown(domain, town)async{
    var res = await http.get((baseUrl + "/api/technician/searchProfAndTown/${domain}/${town}"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
    Iterable list = json.decode(res.body)['technicians'];
    return list;
  }

  Future fetchBestTech(String town)async{
    var res = await http.get((baseUrl + "/api/technician/five-best-by-town/${town}"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
    Iterable list = json.decode(res.body)['technicians'];
    return list;
  }

  Future fetchMostRecentTech()async{
    var res = await http.get((baseUrl + "/api/technician/most-recent"),headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
    Iterable list = json.decode(res.body)['technicians'];
    return list;
  }

  Future<http.Response> saveCall(callInfo)async{
    const url = baseUrl + "/api/callhistoric/new";
    return await http.post(url, body: json.encode(callInfo), headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
  }

  Future<http.Response> rateTech(techId, star)async{
    var url = baseUrl + "/api/technician/rate-tech/${techId}";
    return await http.patch(url, body: json.encode({"star": star}), headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
  }

  Future<http.Response> callCounter(techId)async{
    var url = baseUrl + "/api/technician/nbrCall/${techId}";
    return await http.patch(url, body: json.encode({}), headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
  }

  Future<http.Response> commentCounter(techId)async{
    var url = baseUrl + "/api/technician/nbrComment/${techId}";
    return await http.patch(url, body: json.encode({}), headers: { 'Content-type': 'application/json',"Accept-Charset": "utf-8"});
  }


}