class TempData {
  final dynamic Depth;
  final dynamic Temp;
  TempData(this.Depth, this.Temp);
  factory TempData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return TempData(
      parsedJson['depth'],
      parsedJson['temp'],
    );
  }
}
