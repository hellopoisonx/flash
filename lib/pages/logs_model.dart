class LogModel {
  final String type;
  final String payload;

  LogModel({
    required this.type,
    required this.payload,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      type: json['type'] as String,
      payload: json['payload'] as String,
    );
  }
}
