import 'package:android_intent/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';

class PermissionHandler{
  LocationData currentLocation;
  String error;
  Location location = Location();

  final LocalStorage locationStorage = LocalStorage('location');

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  Future<Address> getUserLocation() async {
    try {
      if (await location.serviceEnabled() == false) {
        location.requestService();
      }else{
        currentLocation = await location.getLocation();
      }

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
        await location.requestPermission().then((value) =>   location.getLocation().then((value) => currentLocation = value));
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
        openLocationSetting();
      }
      currentLocation = null;
    }
    if(currentLocation != null){
      final coordinates = Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      return first;
    }else{
      return null;
    }
  }

}


