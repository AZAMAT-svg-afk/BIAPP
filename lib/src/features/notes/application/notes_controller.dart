import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../data/notes_repository.dart';
import '../domain/note.dart';

final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(ref.watch(appDatabaseProvider)),
);

final notesControllerProvider =
    NotifierProvider<NotesController, List<NoteItem>>(NotesController.new);

class NotesController extends Notifier<List<NoteItem>> {
  @override
  List<NoteItem> build() {
    final subscription = ref.read(notesRepositoryProvider).watchNotes().listen((
      notes,
    ) {
      state = notes;
    });
    ref.onDispose(subscription.cancel);
    return const [];
  }

  void addNote({
    required String title,
    required String content,
    String category = '',
    List<String> tags = const [],
  }) {
    final now = DateTime.now();
    final note = NoteItem(
      id: const Uuid().v4(),
      title: title.trim(),
      content: content.trim(),
      category: category.trim(),
      tags: tags,
      isPinned: false,
      isFavorite: false,
      createdAt: now,
      updatedAt: now,
    );
    unawaited(ref.read(notesRepositoryProvider).addNote(note));
  }

  void updateNote(NoteItem updated) {
    unawaited(
      ref
          .read(notesRepositoryProvider)
          .updateNote(updated.copyWith(updatedAt: DateTime.now())),
    );
  }

  void togglePinned(String id) {
    final note = _findNote(id);
    if (note == null) {
      return;
    }
    updateNote(note.copyWith(isPinned: !note.isPinned));
  }

  void toggleFavorite(String id) {
    final note = _findNote(id);
    if (note == null) {
      return;
    }
    updateNote(note.copyWith(isFavorite: !note.isFavorite));
  }

  void deleteNote(String id) {
    unawaited(ref.read(notesRepositoryProvider).deleteNote(id));
  }

  NoteItem? _findNote(String id) {
    for (final note in state) {
      if (note.id == id) {
        return note;
      }
    }
    return null;
  }
}
