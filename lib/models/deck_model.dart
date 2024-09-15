// lib/models/deck_model.dart
import 'flashcard_model.dart';

class Deck {
  String name;
  List<Flashcard> flashcards;

  Deck({required this.name, List<Flashcard>? flashcards})
      : flashcards = flashcards ?? [];

  // Contagem de flashcards no baralho
  int get flashcardCount => flashcards.length;

  // Função para adicionar um flashcard ao baralho
  void addFlashcard(Flashcard flashcard) {
    flashcards.add(flashcard);
  }

  // Função para excluir um flashcard do baralho
  void removeFlashcard(int index) {
    flashcards.removeAt(index);
  }

  // Função para editar um flashcard
  void editFlashcard(int index, Flashcard updatedFlashcard) {
    flashcards[index] = updatedFlashcard;
  }

  // Função para renomear o baralho
  void rename(String newName) {
    name = newName;
  }

  // Função para converter para JSON (para salvar os dados)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'flashcards': flashcards.map((f) => f.toJson()).toList(),
    };
  }

  // Função para criar um baralho a partir de JSON
  factory Deck.fromJson(Map<String, dynamic> json) {
    var flashcardsFromJson = json['flashcards'] as List;
    List<Flashcard> flashcardList = flashcardsFromJson
        .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
        .toList();

    return Deck(name: json['name'], flashcards: flashcardList);
  }
}
