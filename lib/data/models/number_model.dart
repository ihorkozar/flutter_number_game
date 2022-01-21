import 'package:flutter_number_game/domain/entities/number.dart';

class NumberModel extends Number {
  const NumberModel({
    required String text,
    required int number,
  }) : super(text: text, number: number);

  factory NumberModel.fromJson(Map<String, dynamic> json) {
    return NumberModel(
        text: json['text'],
        number: (json['number']).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "number": number,
    };
  }
}
