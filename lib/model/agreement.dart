

class Agreement {
  int? id;
  String? name;
  String? description;
  String? effective_date;


  Agreement.fromJson(Map<String, dynamic> json) {
    id = json['agreement_id'];
    name = json['agreement_name'];
    description = json['agreement_detail'];
    effective_date = json['effective_date'];
  }
}
