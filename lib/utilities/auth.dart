
  import 'package:shared_preferences/shared_preferences.dart';

  Future<bool> get isLogged async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.getString('user') != null)
      return true;
     else
      return false; 
  }