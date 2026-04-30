import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

class TaskRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  IntColumn get timeMinutes => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get priority => text()();
  TextColumn get category => text().withDefault(const Constant(''))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  TextColumn get repeatType => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get seedKind => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class HabitRecords extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant(''))();
  IntColumn get targetPerDay => integer().withDefault(const Constant(1))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get reminderMinutes => integer().nullable()();
  TextColumn get seedKind => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class HabitCheckInRecords extends Table {
  TextColumn get habitId => text().references(HabitRecords, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {habitId, date};
}

class NoteRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SettingsRecords extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get userName => text()();
  TextColumn get language => text()();
  TextColumn get themeMode => text()();
  TextColumn get city => text()();
  TextColumn get calculationMethod => text()();
  TextColumn get madhhab => text()();
  BoolColumn get useGeolocation => boolean()();
  BoolColumn get prayerNotificationsEnabled => boolean()();
  BoolColumn get soundEnabled => boolean()();
  BoolColumn get vibrationEnabled => boolean()();
  BoolColumn get adhanEnabled => boolean()();
  BoolColumn get manualPrayerOffsetsEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get fajrOffsetMinutes => integer().withDefault(const Constant(0))();
  IntColumn get sunriseOffsetMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get dhuhrOffsetMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get asrOffsetMinutes => integer().withDefault(const Constant(0))();
  IntColumn get maghribOffsetMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get ishaOffsetMinutes => integer().withDefault(const Constant(0))();
  TextColumn get aiMode => text()();
  BoolColumn get voiceInputEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get voiceReplyEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get autoSpeakAiReply =>
      boolean().withDefault(const Constant(false))();
  RealColumn get voiceRate => real().withDefault(const Constant(0.48))();
  RealColumn get voicePitch => real().withDefault(const Constant(1.0))();
  BoolColumn get activeMentorEnabled => boolean()();
  TextColumn get activeMentorMode => text()();
  IntColumn get maxFollowUpsPerItem => integer()();
  IntColumn get quietHoursStartMinutes => integer()();
  IntColumn get quietHoursEndMinutes => integer()();
  BoolColumn get notificationsEnabled => boolean()();
  BoolColumn get isOnboardingComplete => boolean()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppActivityRecords extends Table {
  DateTimeColumn get date => dateTime()();
  BoolColumn get appOpened => boolean().withDefault(const Constant(true))();
  IntColumn get tasksCompleted => integer().withDefault(const Constant(0))();
  IntColumn get habitsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get prayersCompleted => integer().withDefault(const Constant(0))();
  BoolColumn get perfectDay => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

class SemanticIndexItems extends Table {
  TextColumn get id => text()();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text()();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get embeddingJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    TaskRecords,
    HabitRecords,
    HabitCheckInRecords,
    NoteRecords,
    SettingsRecords,
    AppActivityRecords,
    SemanticIndexItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(
          settingsRecords,
          settingsRecords.manualPrayerOffsetsEnabled,
        );
        await m.addColumn(settingsRecords, settingsRecords.fajrOffsetMinutes);
        await m.addColumn(
          settingsRecords,
          settingsRecords.sunriseOffsetMinutes,
        );
        await m.addColumn(settingsRecords, settingsRecords.dhuhrOffsetMinutes);
        await m.addColumn(settingsRecords, settingsRecords.asrOffsetMinutes);
        await m.addColumn(
          settingsRecords,
          settingsRecords.maghribOffsetMinutes,
        );
        await m.addColumn(settingsRecords, settingsRecords.ishaOffsetMinutes);
        await m.addColumn(settingsRecords, settingsRecords.voiceInputEnabled);
        await m.addColumn(settingsRecords, settingsRecords.voiceReplyEnabled);
        await m.addColumn(settingsRecords, settingsRecords.autoSpeakAiReply);
        await m.addColumn(settingsRecords, settingsRecords.voiceRate);
        await m.addColumn(settingsRecords, settingsRecords.voicePitch);
      }
      if (from < 3) {
        await m.createTable(semanticIndexItems);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'baraka_ai.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

int? timeOfDayToMinutes(int? hour, int? minute) {
  if (hour == null || minute == null) {
    return null;
  }
  return hour * 60 + minute;
}
