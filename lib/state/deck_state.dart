// lib/state/deck_state.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deck_model.dart';
import '../models/flashcard_model.dart';

class DeckState {
  List<Deck> _decks = [];

  // Função para carregar os baralhos do armazenamento local
  Future<void> loadDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDecks = prefs.getString('decks');

    if (savedDecks != null) {
      List<dynamic> decodedDecks = jsonDecode(savedDecks);
      _decks = decodedDecks.map((json) => Deck.fromJson(json)).toList();
    }
  }

  // Função para salvar os baralhos no armazenamento local
  Future<void> _saveDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDecks =
        jsonEncode(_decks.map((deck) => deck.toJson()).toList());
    await prefs.setString('decks', encodedDecks);
  }

  // Função para obter a lista de baralhos
  List<Deck> get decks => _decks;

  // Função para obter um baralho pelo índice
  Deck getDeck(int index) {
    return _decks[index];
  }

  // Função para adicionar um novo baralho
  Future<void> addDeck(String name) async {
    _decks.add(Deck(name: name));
    await _saveDecks();
  }

  // Função para excluir um baralho
  Future<void> deleteDeck(int index) async {
    _decks.removeAt(index);
    await _saveDecks();
  }

  // Função para renomear um baralho
  Future<void> renameDeck(int index, String newName) async {
    _decks[index].rename(newName);
    await _saveDecks();
  }

  // Função para adicionar um flashcard a um baralho específico
  Future<void> addFlashcardToDeck(int deckIndex, Flashcard flashcard) async {
    _decks[deckIndex].addFlashcard(flashcard);
    await _saveDecks();
  }

  // Função para editar um flashcard em um baralho específico
  Future<void> editFlashcardInDeck(
      int deckIndex, int flashcardIndex, Flashcard updatedFlashcard) async {
    _decks[deckIndex].editFlashcard(flashcardIndex, updatedFlashcard);
    await _saveDecks();
  }

  // Função para excluir um flashcard de um baralho específico
  Future<void> deleteFlashcardFromDeck(
      int deckIndex, int flashcardIndex) async {
    _decks[deckIndex].removeFlashcard(flashcardIndex);
    await _saveDecks();
  }
}
