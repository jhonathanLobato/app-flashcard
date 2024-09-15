// lib/state/flashcard_state.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deck_model.dart';
import '../models/flashcard_model.dart';

class FlashcardState {
  List<Deck> _decks = [];

  // Carregar os baralhos do armazenamento local
  Future<void> loadDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDecks = prefs.getString('decks');

    if (savedDecks != null) {
      List<dynamic> decodedDecks = jsonDecode(savedDecks);
      _decks = decodedDecks.map((json) => Deck.fromJson(json)).toList();
    }
  }

  // Salvar os baralhos no armazenamento local
  Future<void> saveDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDecks =
        jsonEncode(_decks.map((deck) => deck.toJson()).toList());
    await prefs.setString('decks', encodedDecks);
  }

  // Obter a lista de baralhos
  List<Deck> get decks => _decks;

  // Adicionar um novo baralho
  Future<void> addDeck(String name) async {
    _decks.add(Deck(name: name));
    await saveDecks();
  }

  // Excluir um baralho
  Future<void> deleteDeck(int index) async {
    _decks.removeAt(index);
    await saveDecks();
  }

  // Renomear um baralho
  Future<void> renameDeck(int index, String newName) async {
    _decks[index].rename(newName);
    await saveDecks();
  }

  // Abrir um baralho específico
  Deck getDeck(int index) {
    return _decks[index];
  }

  // Adicionar um flashcard a um baralho
  Future<void> addFlashcardToDeck(int deckIndex, Flashcard flashcard) async {
    _decks[deckIndex].addFlashcard(flashcard);
    await saveDecks();
  }

  // Editar um flashcard dentro de um baralho
  Future<void> editFlashcardInDeck(
      int deckIndex, int flashcardIndex, Flashcard updatedFlashcard) async {
    _decks[deckIndex].editFlashcard(flashcardIndex, updatedFlashcard);
    await saveDecks();
  }

  // Excluir um flashcard de um baralho
  Future<void> deleteFlashcardFromDeck(
      int deckIndex, int flashcardIndex) async {
    _decks[deckIndex].removeFlashcard(flashcardIndex);
    await saveDecks();
  }
}
