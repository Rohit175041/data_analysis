class GeoTempData {
  final dynamic date;
  // final dynamic place;
  final dynamic time;
  GeoTempData(this.date, this.time);
  factory GeoTempData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return GeoTempData(
      parsedJson['date'],
      //parsedJson['place'],
      parsedJson['time'],
    );
  }
}
