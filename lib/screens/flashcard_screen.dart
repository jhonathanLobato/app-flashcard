// lib/screens/flashcard_screen.dart
import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../state/flashcard_state.dart';

class FlashcardScreen extends StatefulWidget {
  final int deckIndex;

  FlashcardScreen({required this.deckIndex});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final FlashcardState _flashcardState = FlashcardState();

  @override
  void initState() {
    super.initState();
    _loadDeck();
  }

  Future<void> _loadDeck() async {
    await _flashcardState.loadDecks();
    setState(() {});
  }

  void _addFlashcard() async {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Novo Flashcard'),
        content: Column(
          children: [
            TextField(
              controller: frontController,
              decoration: InputDecoration(hintText: 'Frente do Flashcard'),
            ),
            TextField(
              controller: backController,
              decoration: InputDecoration(hintText: 'Verso do Flashcard'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final front = frontController.text.trim();
              final back = backController.text.trim();
              if (front.isNotEmpty && back.isNotEmpty) {
                _flashcardState
                    .addFlashcardToDeck(
                        widget.deckIndex, Flashcard(front: front, back: back))
                    .then((_) => _loadDeck());
              }
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _editFlashcard(int flashcardIndex) async {
    final flashcard =
        _flashcardState.getDeck(widget.deckIndex).flashcards[flashcardIndex];
    final frontController = TextEditingController(text: flashcard.front);
    final backController = TextEditingController(text: flashcard.back);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Flashcard'),
        content: Column(
          children: [
            TextField(
              controller: frontController,
              decoration: InputDecoration(hintText: 'Frente do Flashcard'),
            ),
            TextField(
              controller: backController,
              decoration: InputDecoration(hintText: 'Verso do Flashcard'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final front = frontController.text.trim();
              final back = backController.text.trim();
              if (front.isNotEmpty && back.isNotEmpty) {
                _flashcardState
                    .editFlashcardInDeck(widget.deckIndex, flashcardIndex,
                        Flashcard(front: front, back: back))
                    .then((_) => _loadDeck());
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _deleteFlashcard(int flashcardIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Flashcard'),
        content: Text('Tem certeza que deseja excluir este flashcard?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _flashcardState
                  .deleteFlashcardFromDeck(widget.deckIndex, flashcardIndex)
                  .then((_) => _loadDeck());
            },
            child: Text('Excluir'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deck = _flashcardState.getDeck(widget.deckIndex);

    return Scaffold(
      appBar: AppBar(title: Text(deck.name)),
      body: ListView.builder(
        itemCount: deck.flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = deck.flashcards[index];
          return ListTile(
            title: Text(flashcard.front),
            subtitle: Text(flashcard.back),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editFlashcard(index);
                } else if (value == 'delete') {
                  _deleteFlashcard(index);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Excluir'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlashcard,
        child: Icon(Icons.add),
      ),
    );
  }
}
