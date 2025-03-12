

class CctvDateDate {
  String? date;
  int? filetype;
  CctvDateDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    filetype = json['filetype'];

  }
}
