
import 'package:url_launcher/url_launcher.dart';

 class Utility{
  static Future<bool> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      return false ;
    }
  }

}