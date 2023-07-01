class BookingSlots {
  BookingSlots({
    this.id,
    this.period,
    this.startTime,
    this.endTime,
    this.pricing,
    this.selected,
  });

  BookingSlots.fromJson(dynamic json) {
    id = json['id'];
    period = json['period'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    pricing = json['pricing'];
    selected = json['selected'];
  }

  int? id;
  String? period;
  String? startTime;
  String? endTime;
  String? pricing;
  bool? selected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['period'] = period;
    map['endTime'] = endTime;
    map["startTime"] = startTime;
    map['pricing'] = pricing;
    map['selected'] = selected;
    return map;
  }
}
