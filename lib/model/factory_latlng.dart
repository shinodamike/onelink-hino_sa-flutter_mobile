
class FactoryLatLng {
  var lat;
  var lng;

  FactoryLatLng.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('lat')) {
      lat = json['lat'] ;
    }
    if (json.containsKey('lng')) {
      lng = json['lng'] ;
    }
  }
}
