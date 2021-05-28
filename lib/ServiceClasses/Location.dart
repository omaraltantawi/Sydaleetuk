import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude , longitude ;
  Future<bool> getCurrentLocation () async
  {
    try {
        Position position = await Geolocator().getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        this.latitude = position.latitude;
        this.longitude = position.longitude;
        print("Location ${this.latitude} : ${this.longitude}");
        // final coordinates = new Coordinates(this.latitude,this.longitude);
        // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        // addresses.forEach((element) {
        //   print("${element.featureName} : ${element.addressLine}");
        // });
        // // var first = addresses.first;
        // // print("${first.featureName} : ${first.addressLine}");
        // print("geocoding");
        // try {
        //   List<geocoding.Placemark> placemarks = await placemarkFromCoordinates(
        //     position.latitude,
        //     position.longitude,
        //   );
        //   placemarks.forEach((element) {
        //       print("${element.country} : ${element.name}  ${element.street}");
        //     });
        //   print(placemarks[0]);
        // }catch(err){}

        return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }
  }

  static Future<double> getDistance ({@required double startLatitude, @required double startLongitude, @required double endLatitude, @required double endLongitude})
  async {
    try {
        return await Geolocator().distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    }
    catch(e)
    {
      print(e);
      return 0;
    }
  }
  //
  // Future<bool> getCurrentLocation () async
  // {
  //   try {
  //     var permission = await Geolocator.checkPermission();
  //     if ( permission == LocationPermission.whileInUse || permission == LocationPermission.always  ) {
  //       Position position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.medium);
  //       this.latitude = position.latitude;
  //       this.longitude = position.longitude;
  //       return true;
  //     }
  //     else{
  //       var permission = await Geolocator.requestPermission();
  //       if ( permission == LocationPermission.whileInUse || permission == LocationPermission.always  ) {
  //         Position position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.best);
  //         this.latitude = position.latitude;
  //         this.longitude = position.longitude;
  //         return true;
  //       }
  //       return false;
  //     }
  //   }
  //   catch(e)
  //   {
  //     print(e);
  //     return false;
  //   }
  // }

}