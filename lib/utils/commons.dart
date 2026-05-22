import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Commons {
  static launchMap(double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static launchShare(String info, double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    Share.share('$info\n$googleUrl');
  }
}
