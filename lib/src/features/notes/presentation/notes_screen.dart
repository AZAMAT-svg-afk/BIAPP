import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../tasks/application/tasks_controller.dart';
import '../application/notes_controller.dart';
import '../domain/note.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notes = ref.watch(notesControllerProvider).where((note) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) {
        return true;
      }
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          note.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
    final controller = ref.read(notesControllerProvider.notifier);

    return AppScaffold(
      title: l10n.notesTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteSheet(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addNote),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: l10n.search,
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 16),
          if (notes.isEmpty)
            AppEmptyState(message: l10n.emptyNotes, icon: Icons.notes)
          else
            ...notes.toList().asMap().entries.map((entry) {
              final note = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppMotion(
                  delay: Duration(milliseconds: 35 * entry.key),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              onPressed: () => controller.togglePinned(note.id),
                              icon: Icon(
                                note.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.toggleFavorite(note.id),
                              icon: Icon(
                                note.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                            ),
                          ],
                        ),
                        if (note.content.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(note.content),
                        ],
                        if (note.tags.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final tag in note.tags)
                                Chip(label: Text('#$tag')),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  _showNoteSheet(context, note: note),
                              icon: const Icon(Icons.edit),
                              label: Text(l10n.edit),
                            ),
                            TextButton.icon(
                              onPressed: () => _noteToTask(note),
                              icon: const Icon(Icons.task_alt),
                              label: Text(l10n.noteToTask),
                            ),
                            TextButton.icon(
                              onPressed: () => controller.deleteNote(note.id),
                              icon: const Icon(Icons.delete_outline),
                              label: Text(l10n.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showNoteSheet(BuildContext context, {NoteItem? note}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _NoteFormSheet(note: note),
    );
  }

  void _noteToTask(NoteItem note) {
    ref
        .read(tasksControllerProvider.notifier)
        .addTask(
          title: note.title,
          description: note.content,
          category: note.category,
        );
  }
}

class _NoteFormSheet extends ConsumerStatefulWidget {
  const _NoteFormSheet({this.note});

  final NoteItem? note;

  @override
  ConsumerState<_NoteFormSheet> createState() => _NoteFormSheetState();
}

class _NoteFormSheetState extends ConsumerState<_NoteFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _categoryController;
  late final TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _categoryController = TextEditingController(text: note?.category ?? '');
    _tagsController = TextEditingController(text: note?.tags.join(', ') ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note == null ? l10n.addNote : l10n.editNote,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.noteTitleField),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(labelText: l10n.noteContentField),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: l10n.category),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(labelText: l10n.tags),
            ),
            const SizedBox(height: 14),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    final controller = ref.read(notesControllerProvider.notifier);

    if (widget.note == null) {
      controller.addNote(
        title: title,
        content: _contentController.text,
        category: _categoryController.text,
        tags: tags,
      );
    } else {
      controller.updateNote(
        widget.note!.copyWith(
          title: title,
          content: _contentController.text,
          category: _categoryController.text,
          tags: tags,
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
