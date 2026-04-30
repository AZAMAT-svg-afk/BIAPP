import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/note.dart';

class NotesRepository {
  NotesRepository(this._database);

  final AppDatabase _database;

  Stream<List<NoteItem>> watchNotes() {
    return (_database.select(_database.noteRecords)..orderBy([
          (note) => OrderingTerm.desc(note.isPinned),
          (note) => OrderingTerm.desc(note.updatedAt),
        ]))
        .watch()
        .map((records) => records.map(_fromRecord).toList());
  }

  Future<List<NoteItem>> listNotes() async {
    final records =
        await (_database.select(_database.noteRecords)..orderBy([
              (note) => OrderingTerm.desc(note.isPinned),
              (note) => OrderingTerm.desc(note.updatedAt),
            ]))
            .get();
    return records.map(_fromRecord).toList();
  }

  Future<void> addNote(NoteItem note) {
    return _database
        .into(_database.noteRecords)
        .insertOnConflictUpdate(_toCompanion(note));
  }

  Future<void> updateNote(NoteItem note) {
    return _database
        .into(_database.noteRecords)
        .insertOnConflictUpdate(_toCompanion(note));
  }

  Future<void> deleteNote(String id) {
    return (_database.delete(
      _database.noteRecords,
    )..where((row) => row.id.equals(id))).go();
  }

  NoteRecordsCompanion _toCompanion(NoteItem note) {
    return NoteRecordsCompanion(
      id: Value(note.id),
      title: Value(note.title),
      content: Value(note.content),
      category: Value(note.category),
      tagsJson: Value(jsonEncode(note.tags)),
      isPinned: Value(note.isPinned),
      isFavorite: Value(note.isFavorite),
      createdAt: Value(note.createdAt),
      updatedAt: Value(note.updatedAt),
    );
  }

  NoteItem _fromRecord(NoteRecord record) {
    return NoteItem(
      id: record.id,
      title: record.title,
      content: record.content,
      category: record.category,
      tags: _decodeTags(record.tagsJson),
      isPinned: record.isPinned,
      isFavorite: record.isFavorite,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  List<String> _decodeTags(String tagsJson) {
    final decoded = jsonDecode(tagsJson);
    if (decoded is! List) {
      return const [];
    }
    return decoded.whereType<String>().toList();
  }
}
