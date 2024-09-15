// lib/models/flashcard_model.dart
class Flashcard {
  String front;
  String back;

  Flashcard({required this.front, required this.back});

  Map<String, dynamic> toJson() {
    return {
      'front': front,
      'back': back,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      front: json['front'],
      back: json['back'],
    );
  }
}
