// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskRecordsTable extends TaskRecords
    with TableInfo<$TaskRecordsTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMinutesMeta = const VerificationMeta(
    'timeMinutes',
  );
  @override
  late final GeneratedColumn<int> timeMinutes = GeneratedColumn<int>(
    'time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatTypeMeta = const VerificationMeta(
    'repeatType',
  );
  @override
  late final GeneratedColumn<String> repeatType = GeneratedColumn<String>(
    'repeat_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seedKindMeta = const VerificationMeta(
    'seedKind',
  );
  @override
  late final GeneratedColumn<String> seedKind = GeneratedColumn<String>(
    'seed_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    date,
    timeMinutes,
    isCompleted,
    priority,
    category,
    reminderEnabled,
    reminderTime,
    repeatType,
    completedAt,
    seedKind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time_minutes')) {
      context.handle(
        _timeMinutesMeta,
        timeMinutes.isAcceptableOrUnknown(
          data['time_minutes']!,
          _timeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('repeat_type')) {
      context.handle(
        _repeatTypeMeta,
        repeatType.isAcceptableOrUnknown(data['repeat_type']!, _repeatTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatTypeMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('seed_kind')) {
      context.handle(
        _seedKindMeta,
        seedKind.isAcceptableOrUnknown(data['seed_kind']!, _seedKindMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      timeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_minutes'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_time'],
      ),
      repeatType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_type'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      seedKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_kind'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int? timeMinutes;
  final bool isCompleted;
  final String priority;
  final String category;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final String repeatType;
  final DateTime? completedAt;
  final String? seedKind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.timeMinutes,
    required this.isCompleted,
    required this.priority,
    required this.category,
    required this.reminderEnabled,
    this.reminderTime,
    required this.repeatType,
    this.completedAt,
    this.seedKind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || timeMinutes != null) {
      map['time_minutes'] = Variable<int>(timeMinutes);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['priority'] = Variable<String>(priority);
    map['category'] = Variable<String>(category);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<DateTime>(reminderTime);
    }
    map['repeat_type'] = Variable<String>(repeatType);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || seedKind != null) {
      map['seed_kind'] = Variable<String>(seedKind);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      date: Value(date),
      timeMinutes: timeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(timeMinutes),
      isCompleted: Value(isCompleted),
      priority: Value(priority),
      category: Value(category),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      repeatType: Value(repeatType),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      seedKind: seedKind == null && nullToAbsent
          ? const Value.absent()
          : Value(seedKind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      timeMinutes: serializer.fromJson<int?>(json['timeMinutes']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      priority: serializer.fromJson<String>(json['priority']),
      category: serializer.fromJson<String>(json['category']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<DateTime?>(json['reminderTime']),
      repeatType: serializer.fromJson<String>(json['repeatType']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      seedKind: serializer.fromJson<String?>(json['seedKind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'timeMinutes': serializer.toJson<int?>(timeMinutes),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'priority': serializer.toJson<String>(priority),
      'category': serializer.toJson<String>(category),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<DateTime?>(reminderTime),
      'repeatType': serializer.toJson<String>(repeatType),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'seedKind': serializer.toJson<String?>(seedKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRecord copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    Value<int?> timeMinutes = const Value.absent(),
    bool? isCompleted,
    String? priority,
    String? category,
    bool? reminderEnabled,
    Value<DateTime?> reminderTime = const Value.absent(),
    String? repeatType,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> seedKind = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    date: date ?? this.date,
    timeMinutes: timeMinutes.present ? timeMinutes.value : this.timeMinutes,
    isCompleted: isCompleted ?? this.isCompleted,
    priority: priority ?? this.priority,
    category: category ?? this.category,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    repeatType: repeatType ?? this.repeatType,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    seedKind: seedKind.present ? seedKind.value : this.seedKind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      timeMinutes: data.timeMinutes.present
          ? data.timeMinutes.value
          : this.timeMinutes,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      priority: data.priority.present ? data.priority.value : this.priority,
      category: data.category.present ? data.category.value : this.category,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      repeatType: data.repeatType.present
          ? data.repeatType.value
          : this.repeatType,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      seedKind: data.seedKind.present ? data.seedKind.value : this.seedKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('timeMinutes: $timeMinutes, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('category: $category, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('repeatType: $repeatType, ')
          ..write('completedAt: $completedAt, ')
          ..write('seedKind: $seedKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    date,
    timeMinutes,
    isCompleted,
    priority,
    category,
    reminderEnabled,
    reminderTime,
    repeatType,
    completedAt,
    seedKind,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date &&
          other.timeMinutes == this.timeMinutes &&
          other.isCompleted == this.isCompleted &&
          other.priority == this.priority &&
          other.category == this.category &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.repeatType == this.repeatType &&
          other.completedAt == this.completedAt &&
          other.seedKind == this.seedKind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<int?> timeMinutes;
  final Value<bool> isCompleted;
  final Value<String> priority;
  final Value<String> category;
  final Value<bool> reminderEnabled;
  final Value<DateTime?> reminderTime;
  final Value<String> repeatType;
  final Value<DateTime?> completedAt;
  final Value<String?> seedKind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.timeMinutes = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.category = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.repeatType = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.seedKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime date,
    this.timeMinutes = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required String priority,
    this.category = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    required String repeatType,
    this.completedAt = const Value.absent(),
    this.seedKind = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       date = Value(date),
       priority = Value(priority),
       repeatType = Value(repeatType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<int>? timeMinutes,
    Expression<bool>? isCompleted,
    Expression<String>? priority,
    Expression<String>? category,
    Expression<bool>? reminderEnabled,
    Expression<DateTime>? reminderTime,
    Expression<String>? repeatType,
    Expression<DateTime>? completedAt,
    Expression<String>? seedKind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (timeMinutes != null) 'time_minutes': timeMinutes,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (priority != null) 'priority': priority,
      if (category != null) 'category': category,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (repeatType != null) 'repeat_type': repeatType,
      if (completedAt != null) 'completed_at': completedAt,
      if (seedKind != null) 'seed_kind': seedKind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<DateTime>? date,
    Value<int?>? timeMinutes,
    Value<bool>? isCompleted,
    Value<String>? priority,
    Value<String>? category,
    Value<bool>? reminderEnabled,
    Value<DateTime?>? reminderTime,
    Value<String>? repeatType,
    Value<DateTime?>? completedAt,
    Value<String?>? seedKind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      timeMinutes: timeMinutes ?? this.timeMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      repeatType: repeatType ?? this.repeatType,
      completedAt: completedAt ?? this.completedAt,
      seedKind: seedKind ?? this.seedKind,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (timeMinutes.present) {
      map['time_minutes'] = Variable<int>(timeMinutes.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (repeatType.present) {
      map['repeat_type'] = Variable<String>(repeatType.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (seedKind.present) {
      map['seed_kind'] = Variable<String>(seedKind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('timeMinutes: $timeMinutes, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('category: $category, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('repeatType: $repeatType, ')
          ..write('completedAt: $completedAt, ')
          ..write('seedKind: $seedKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitRecordsTable extends HabitRecords
    with TableInfo<$HabitRecordsTable, HabitRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _targetPerDayMeta = const VerificationMeta(
    'targetPerDay',
  );
  @override
  late final GeneratedColumn<int> targetPerDay = GeneratedColumn<int>(
    'target_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seedKindMeta = const VerificationMeta(
    'seedKind',
  );
  @override
  late final GeneratedColumn<String> seedKind = GeneratedColumn<String>(
    'seed_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    targetPerDay,
    reminderEnabled,
    reminderMinutes,
    seedKind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('target_per_day')) {
      context.handle(
        _targetPerDayMeta,
        targetPerDay.isAcceptableOrUnknown(
          data['target_per_day']!,
          _targetPerDayMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('seed_kind')) {
      context.handle(
        _seedKindMeta,
        seedKind.isAcceptableOrUnknown(data['seed_kind']!, _seedKindMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      targetPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_per_day'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      ),
      seedKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_kind'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HabitRecordsTable createAlias(String alias) {
    return $HabitRecordsTable(attachedDatabase, alias);
  }
}

class HabitRecord extends DataClass implements Insertable<HabitRecord> {
  final String id;
  final String name;
  final String category;
  final int targetPerDay;
  final bool reminderEnabled;
  final int? reminderMinutes;
  final String? seedKind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HabitRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.targetPerDay,
    required this.reminderEnabled,
    this.reminderMinutes,
    this.seedKind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['target_per_day'] = Variable<int>(targetPerDay);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderMinutes != null) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes);
    }
    if (!nullToAbsent || seedKind != null) {
      map['seed_kind'] = Variable<String>(seedKind);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HabitRecordsCompanion toCompanion(bool nullToAbsent) {
    return HabitRecordsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      targetPerDay: Value(targetPerDay),
      reminderEnabled: Value(reminderEnabled),
      reminderMinutes: reminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutes),
      seedKind: seedKind == null && nullToAbsent
          ? const Value.absent()
          : Value(seedKind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      targetPerDay: serializer.fromJson<int>(json['targetPerDay']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderMinutes: serializer.fromJson<int?>(json['reminderMinutes']),
      seedKind: serializer.fromJson<String?>(json['seedKind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'targetPerDay': serializer.toJson<int>(targetPerDay),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderMinutes': serializer.toJson<int?>(reminderMinutes),
      'seedKind': serializer.toJson<String?>(seedKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HabitRecord copyWith({
    String? id,
    String? name,
    String? category,
    int? targetPerDay,
    bool? reminderEnabled,
    Value<int?> reminderMinutes = const Value.absent(),
    Value<String?> seedKind = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HabitRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    targetPerDay: targetPerDay ?? this.targetPerDay,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderMinutes: reminderMinutes.present
        ? reminderMinutes.value
        : this.reminderMinutes,
    seedKind: seedKind.present ? seedKind.value : this.seedKind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HabitRecord copyWithCompanion(HabitRecordsCompanion data) {
    return HabitRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      targetPerDay: data.targetPerDay.present
          ? data.targetPerDay.value
          : this.targetPerDay,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      seedKind: data.seedKind.present ? data.seedKind.value : this.seedKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetPerDay: $targetPerDay, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('seedKind: $seedKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    targetPerDay,
    reminderEnabled,
    reminderMinutes,
    seedKind,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.targetPerDay == this.targetPerDay &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderMinutes == this.reminderMinutes &&
          other.seedKind == this.seedKind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HabitRecordsCompanion extends UpdateCompanion<HabitRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> targetPerDay;
  final Value<bool> reminderEnabled;
  final Value<int?> reminderMinutes;
  final Value<String?> seedKind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HabitRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.targetPerDay = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.seedKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitRecordsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    this.targetPerDay = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.seedKind = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HabitRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? targetPerDay,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderMinutes,
    Expression<String>? seedKind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (targetPerDay != null) 'target_per_day': targetPerDay,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (seedKind != null) 'seed_kind': seedKind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? targetPerDay,
    Value<bool>? reminderEnabled,
    Value<int?>? reminderMinutes,
    Value<String?>? seedKind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HabitRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      seedKind: seedKind ?? this.seedKind,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetPerDay.present) {
      map['target_per_day'] = Variable<int>(targetPerDay.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (seedKind.present) {
      map['seed_kind'] = Variable<String>(seedKind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetPerDay: $targetPerDay, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('seedKind: $seedKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitCheckInRecordsTable extends HabitCheckInRecords
    with TableInfo<$HabitCheckInRecordsTable, HabitCheckInRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCheckInRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habit_records (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [habitId, date, count, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_check_in_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitCheckInRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, date};
  @override
  HabitCheckInRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCheckInRecord(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HabitCheckInRecordsTable createAlias(String alias) {
    return $HabitCheckInRecordsTable(attachedDatabase, alias);
  }
}

class HabitCheckInRecord extends DataClass
    implements Insertable<HabitCheckInRecord> {
  final String habitId;
  final DateTime date;
  final int count;
  final DateTime updatedAt;
  const HabitCheckInRecord({
    required this.habitId,
    required this.date,
    required this.count,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['date'] = Variable<DateTime>(date);
    map['count'] = Variable<int>(count);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HabitCheckInRecordsCompanion toCompanion(bool nullToAbsent) {
    return HabitCheckInRecordsCompanion(
      habitId: Value(habitId),
      date: Value(date),
      count: Value(count),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitCheckInRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCheckInRecord(
      habitId: serializer.fromJson<String>(json['habitId']),
      date: serializer.fromJson<DateTime>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<String>(habitId),
      'date': serializer.toJson<DateTime>(date),
      'count': serializer.toJson<int>(count),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HabitCheckInRecord copyWith({
    String? habitId,
    DateTime? date,
    int? count,
    DateTime? updatedAt,
  }) => HabitCheckInRecord(
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    count: count ?? this.count,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HabitCheckInRecord copyWithCompanion(HabitCheckInRecordsCompanion data) {
    return HabitCheckInRecord(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCheckInRecord(')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(habitId, date, count, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCheckInRecord &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.count == this.count &&
          other.updatedAt == this.updatedAt);
}

class HabitCheckInRecordsCompanion extends UpdateCompanion<HabitCheckInRecord> {
  final Value<String> habitId;
  final Value<DateTime> date;
  final Value<int> count;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HabitCheckInRecordsCompanion({
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCheckInRecordsCompanion.insert({
    required String habitId,
    required DateTime date,
    this.count = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<HabitCheckInRecord> custom({
    Expression<String>? habitId,
    Expression<DateTime>? date,
    Expression<int>? count,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCheckInRecordsCompanion copyWith({
    Value<String>? habitId,
    Value<DateTime>? date,
    Value<int>? count,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HabitCheckInRecordsCompanion(
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      count: count ?? this.count,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCheckInRecordsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteRecordsTable extends NoteRecords
    with TableInfo<$NoteRecordsTable, NoteRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    category,
    tagsJson,
    isPinned,
    isFavorite,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NoteRecordsTable createAlias(String alias) {
    return $NoteRecordsTable(attachedDatabase, alias);
  }
}

class NoteRecord extends DataClass implements Insertable<NoteRecord> {
  final String id;
  final String title;
  final String content;
  final String category;
  final String tagsJson;
  final bool isPinned;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoteRecord({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.tagsJson,
    required this.isPinned,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    map['tags_json'] = Variable<String>(tagsJson);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NoteRecordsCompanion toCompanion(bool nullToAbsent) {
    return NoteRecordsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      tagsJson: Value(tagsJson),
      isPinned: Value(isPinned),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoteRecord copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? tagsJson,
    bool? isPinned,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoteRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    category: category ?? this.category,
    tagsJson: tagsJson ?? this.tagsJson,
    isPinned: isPinned ?? this.isPinned,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NoteRecord copyWithCompanion(NoteRecordsCompanion data) {
    return NoteRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    content,
    category,
    tagsJson,
    isPinned,
    isFavorite,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.tagsJson == this.tagsJson &&
          other.isPinned == this.isPinned &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NoteRecordsCompanion extends UpdateCompanion<NoteRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> category;
  final Value<String> tagsJson;
  final Value<bool> isPinned;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NoteRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteRecordsCompanion.insert({
    required String id,
    required String title,
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isFavorite = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NoteRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? category,
    Expression<String>? tagsJson,
    Expression<bool>? isPinned,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<String>? category,
    Value<String>? tagsJson,
    Value<bool>? isPinned,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NoteRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tagsJson: tagsJson ?? this.tagsJson,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsRecordsTable extends SettingsRecords
    with TableInfo<$SettingsRecordsTable, SettingsRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculationMethodMeta = const VerificationMeta(
    'calculationMethod',
  );
  @override
  late final GeneratedColumn<String> calculationMethod =
      GeneratedColumn<String>(
        'calculation_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _madhhabMeta = const VerificationMeta(
    'madhhab',
  );
  @override
  late final GeneratedColumn<String> madhhab = GeneratedColumn<String>(
    'madhhab',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useGeolocationMeta = const VerificationMeta(
    'useGeolocation',
  );
  @override
  late final GeneratedColumn<bool> useGeolocation = GeneratedColumn<bool>(
    'use_geolocation',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_geolocation" IN (0, 1))',
    ),
  );
  static const VerificationMeta _prayerNotificationsEnabledMeta =
      const VerificationMeta('prayerNotificationsEnabled');
  @override
  late final GeneratedColumn<bool> prayerNotificationsEnabled =
      GeneratedColumn<bool>(
        'prayer_notifications_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("prayer_notifications_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _vibrationEnabledMeta = const VerificationMeta(
    'vibrationEnabled',
  );
  @override
  late final GeneratedColumn<bool> vibrationEnabled = GeneratedColumn<bool>(
    'vibration_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibration_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _adhanEnabledMeta = const VerificationMeta(
    'adhanEnabled',
  );
  @override
  late final GeneratedColumn<bool> adhanEnabled = GeneratedColumn<bool>(
    'adhan_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adhan_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _manualPrayerOffsetsEnabledMeta =
      const VerificationMeta('manualPrayerOffsetsEnabled');
  @override
  late final GeneratedColumn<bool> manualPrayerOffsetsEnabled =
      GeneratedColumn<bool>(
        'manual_prayer_offsets_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("manual_prayer_offsets_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _fajrOffsetMinutesMeta = const VerificationMeta(
    'fajrOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> fajrOffsetMinutes = GeneratedColumn<int>(
    'fajr_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sunriseOffsetMinutesMeta =
      const VerificationMeta('sunriseOffsetMinutes');
  @override
  late final GeneratedColumn<int> sunriseOffsetMinutes = GeneratedColumn<int>(
    'sunrise_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dhuhrOffsetMinutesMeta =
      const VerificationMeta('dhuhrOffsetMinutes');
  @override
  late final GeneratedColumn<int> dhuhrOffsetMinutes = GeneratedColumn<int>(
    'dhuhr_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _asrOffsetMinutesMeta = const VerificationMeta(
    'asrOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> asrOffsetMinutes = GeneratedColumn<int>(
    'asr_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maghribOffsetMinutesMeta =
      const VerificationMeta('maghribOffsetMinutes');
  @override
  late final GeneratedColumn<int> maghribOffsetMinutes = GeneratedColumn<int>(
    'maghrib_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ishaOffsetMinutesMeta = const VerificationMeta(
    'ishaOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> ishaOffsetMinutes = GeneratedColumn<int>(
    'isha_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aiModeMeta = const VerificationMeta('aiMode');
  @override
  late final GeneratedColumn<String> aiMode = GeneratedColumn<String>(
    'ai_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voiceInputEnabledMeta = const VerificationMeta(
    'voiceInputEnabled',
  );
  @override
  late final GeneratedColumn<bool> voiceInputEnabled = GeneratedColumn<bool>(
    'voice_input_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("voice_input_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _voiceReplyEnabledMeta = const VerificationMeta(
    'voiceReplyEnabled',
  );
  @override
  late final GeneratedColumn<bool> voiceReplyEnabled = GeneratedColumn<bool>(
    'voice_reply_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("voice_reply_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoSpeakAiReplyMeta = const VerificationMeta(
    'autoSpeakAiReply',
  );
  @override
  late final GeneratedColumn<bool> autoSpeakAiReply = GeneratedColumn<bool>(
    'auto_speak_ai_reply',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_speak_ai_reply" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _voiceRateMeta = const VerificationMeta(
    'voiceRate',
  );
  @override
  late final GeneratedColumn<double> voiceRate = GeneratedColumn<double>(
    'voice_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.48),
  );
  static const VerificationMeta _voicePitchMeta = const VerificationMeta(
    'voicePitch',
  );
  @override
  late final GeneratedColumn<double> voicePitch = GeneratedColumn<double>(
    'voice_pitch',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _activeMentorEnabledMeta =
      const VerificationMeta('activeMentorEnabled');
  @override
  late final GeneratedColumn<bool> activeMentorEnabled = GeneratedColumn<bool>(
    'active_mentor_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active_mentor_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _activeMentorModeMeta = const VerificationMeta(
    'activeMentorMode',
  );
  @override
  late final GeneratedColumn<String> activeMentorMode = GeneratedColumn<String>(
    'active_mentor_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxFollowUpsPerItemMeta =
      const VerificationMeta('maxFollowUpsPerItem');
  @override
  late final GeneratedColumn<int> maxFollowUpsPerItem = GeneratedColumn<int>(
    'max_follow_ups_per_item',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quietHoursStartMinutesMeta =
      const VerificationMeta('quietHoursStartMinutes');
  @override
  late final GeneratedColumn<int> quietHoursStartMinutes = GeneratedColumn<int>(
    'quiet_hours_start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quietHoursEndMinutesMeta =
      const VerificationMeta('quietHoursEndMinutes');
  @override
  late final GeneratedColumn<int> quietHoursEndMinutes = GeneratedColumn<int>(
    'quiet_hours_end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isOnboardingCompleteMeta =
      const VerificationMeta('isOnboardingComplete');
  @override
  late final GeneratedColumn<bool> isOnboardingComplete = GeneratedColumn<bool>(
    'is_onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_onboarding_complete" IN (0, 1))',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userName,
    language,
    themeMode,
    city,
    calculationMethod,
    madhhab,
    useGeolocation,
    prayerNotificationsEnabled,
    soundEnabled,
    vibrationEnabled,
    adhanEnabled,
    manualPrayerOffsetsEnabled,
    fajrOffsetMinutes,
    sunriseOffsetMinutes,
    dhuhrOffsetMinutes,
    asrOffsetMinutes,
    maghribOffsetMinutes,
    ishaOffsetMinutes,
    aiMode,
    voiceInputEnabled,
    voiceReplyEnabled,
    autoSpeakAiReply,
    voiceRate,
    voicePitch,
    activeMentorEnabled,
    activeMentorMode,
    maxFollowUpsPerItem,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    notificationsEnabled,
    isOnboardingComplete,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('calculation_method')) {
      context.handle(
        _calculationMethodMeta,
        calculationMethod.isAcceptableOrUnknown(
          data['calculation_method']!,
          _calculationMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculationMethodMeta);
    }
    if (data.containsKey('madhhab')) {
      context.handle(
        _madhhabMeta,
        madhhab.isAcceptableOrUnknown(data['madhhab']!, _madhhabMeta),
      );
    } else if (isInserting) {
      context.missing(_madhhabMeta);
    }
    if (data.containsKey('use_geolocation')) {
      context.handle(
        _useGeolocationMeta,
        useGeolocation.isAcceptableOrUnknown(
          data['use_geolocation']!,
          _useGeolocationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_useGeolocationMeta);
    }
    if (data.containsKey('prayer_notifications_enabled')) {
      context.handle(
        _prayerNotificationsEnabledMeta,
        prayerNotificationsEnabled.isAcceptableOrUnknown(
          data['prayer_notifications_enabled']!,
          _prayerNotificationsEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prayerNotificationsEnabledMeta);
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_soundEnabledMeta);
    }
    if (data.containsKey('vibration_enabled')) {
      context.handle(
        _vibrationEnabledMeta,
        vibrationEnabled.isAcceptableOrUnknown(
          data['vibration_enabled']!,
          _vibrationEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vibrationEnabledMeta);
    }
    if (data.containsKey('adhan_enabled')) {
      context.handle(
        _adhanEnabledMeta,
        adhanEnabled.isAcceptableOrUnknown(
          data['adhan_enabled']!,
          _adhanEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adhanEnabledMeta);
    }
    if (data.containsKey('manual_prayer_offsets_enabled')) {
      context.handle(
        _manualPrayerOffsetsEnabledMeta,
        manualPrayerOffsetsEnabled.isAcceptableOrUnknown(
          data['manual_prayer_offsets_enabled']!,
          _manualPrayerOffsetsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('fajr_offset_minutes')) {
      context.handle(
        _fajrOffsetMinutesMeta,
        fajrOffsetMinutes.isAcceptableOrUnknown(
          data['fajr_offset_minutes']!,
          _fajrOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sunrise_offset_minutes')) {
      context.handle(
        _sunriseOffsetMinutesMeta,
        sunriseOffsetMinutes.isAcceptableOrUnknown(
          data['sunrise_offset_minutes']!,
          _sunriseOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('dhuhr_offset_minutes')) {
      context.handle(
        _dhuhrOffsetMinutesMeta,
        dhuhrOffsetMinutes.isAcceptableOrUnknown(
          data['dhuhr_offset_minutes']!,
          _dhuhrOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('asr_offset_minutes')) {
      context.handle(
        _asrOffsetMinutesMeta,
        asrOffsetMinutes.isAcceptableOrUnknown(
          data['asr_offset_minutes']!,
          _asrOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('maghrib_offset_minutes')) {
      context.handle(
        _maghribOffsetMinutesMeta,
        maghribOffsetMinutes.isAcceptableOrUnknown(
          data['maghrib_offset_minutes']!,
          _maghribOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('isha_offset_minutes')) {
      context.handle(
        _ishaOffsetMinutesMeta,
        ishaOffsetMinutes.isAcceptableOrUnknown(
          data['isha_offset_minutes']!,
          _ishaOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('ai_mode')) {
      context.handle(
        _aiModeMeta,
        aiMode.isAcceptableOrUnknown(data['ai_mode']!, _aiModeMeta),
      );
    } else if (isInserting) {
      context.missing(_aiModeMeta);
    }
    if (data.containsKey('voice_input_enabled')) {
      context.handle(
        _voiceInputEnabledMeta,
        voiceInputEnabled.isAcceptableOrUnknown(
          data['voice_input_enabled']!,
          _voiceInputEnabledMeta,
        ),
      );
    }
    if (data.containsKey('voice_reply_enabled')) {
      context.handle(
        _voiceReplyEnabledMeta,
        voiceReplyEnabled.isAcceptableOrUnknown(
          data['voice_reply_enabled']!,
          _voiceReplyEnabledMeta,
        ),
      );
    }
    if (data.containsKey('auto_speak_ai_reply')) {
      context.handle(
        _autoSpeakAiReplyMeta,
        autoSpeakAiReply.isAcceptableOrUnknown(
          data['auto_speak_ai_reply']!,
          _autoSpeakAiReplyMeta,
        ),
      );
    }
    if (data.containsKey('voice_rate')) {
      context.handle(
        _voiceRateMeta,
        voiceRate.isAcceptableOrUnknown(data['voice_rate']!, _voiceRateMeta),
      );
    }
    if (data.containsKey('voice_pitch')) {
      context.handle(
        _voicePitchMeta,
        voicePitch.isAcceptableOrUnknown(data['voice_pitch']!, _voicePitchMeta),
      );
    }
    if (data.containsKey('active_mentor_enabled')) {
      context.handle(
        _activeMentorEnabledMeta,
        activeMentorEnabled.isAcceptableOrUnknown(
          data['active_mentor_enabled']!,
          _activeMentorEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeMentorEnabledMeta);
    }
    if (data.containsKey('active_mentor_mode')) {
      context.handle(
        _activeMentorModeMeta,
        activeMentorMode.isAcceptableOrUnknown(
          data['active_mentor_mode']!,
          _activeMentorModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeMentorModeMeta);
    }
    if (data.containsKey('max_follow_ups_per_item')) {
      context.handle(
        _maxFollowUpsPerItemMeta,
        maxFollowUpsPerItem.isAcceptableOrUnknown(
          data['max_follow_ups_per_item']!,
          _maxFollowUpsPerItemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxFollowUpsPerItemMeta);
    }
    if (data.containsKey('quiet_hours_start_minutes')) {
      context.handle(
        _quietHoursStartMinutesMeta,
        quietHoursStartMinutes.isAcceptableOrUnknown(
          data['quiet_hours_start_minutes']!,
          _quietHoursStartMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quietHoursStartMinutesMeta);
    }
    if (data.containsKey('quiet_hours_end_minutes')) {
      context.handle(
        _quietHoursEndMinutesMeta,
        quietHoursEndMinutes.isAcceptableOrUnknown(
          data['quiet_hours_end_minutes']!,
          _quietHoursEndMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quietHoursEndMinutesMeta);
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationsEnabledMeta);
    }
    if (data.containsKey('is_onboarding_complete')) {
      context.handle(
        _isOnboardingCompleteMeta,
        isOnboardingComplete.isAcceptableOrUnknown(
          data['is_onboarding_complete']!,
          _isOnboardingCompleteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isOnboardingCompleteMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      calculationMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_method'],
      )!,
      madhhab: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}madhhab'],
      )!,
      useGeolocation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_geolocation'],
      )!,
      prayerNotificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prayer_notifications_enabled'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      vibrationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibration_enabled'],
      )!,
      adhanEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adhan_enabled'],
      )!,
      manualPrayerOffsetsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}manual_prayer_offsets_enabled'],
      )!,
      fajrOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fajr_offset_minutes'],
      )!,
      sunriseOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sunrise_offset_minutes'],
      )!,
      dhuhrOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dhuhr_offset_minutes'],
      )!,
      asrOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}asr_offset_minutes'],
      )!,
      maghribOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maghrib_offset_minutes'],
      )!,
      ishaOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isha_offset_minutes'],
      )!,
      aiMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_mode'],
      )!,
      voiceInputEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}voice_input_enabled'],
      )!,
      voiceReplyEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}voice_reply_enabled'],
      )!,
      autoSpeakAiReply: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_speak_ai_reply'],
      )!,
      voiceRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}voice_rate'],
      )!,
      voicePitch: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}voice_pitch'],
      )!,
      activeMentorEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active_mentor_enabled'],
      )!,
      activeMentorMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_mentor_mode'],
      )!,
      maxFollowUpsPerItem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_follow_ups_per_item'],
      )!,
      quietHoursStartMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_start_minutes'],
      )!,
      quietHoursEndMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_end_minutes'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      isOnboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_onboarding_complete'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsRecordsTable createAlias(String alias) {
    return $SettingsRecordsTable(attachedDatabase, alias);
  }
}

class SettingsRecord extends DataClass implements Insertable<SettingsRecord> {
  final int id;
  final String userName;
  final String language;
  final String themeMode;
  final String city;
  final String calculationMethod;
  final String madhhab;
  final bool useGeolocation;
  final bool prayerNotificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool adhanEnabled;
  final bool manualPrayerOffsetsEnabled;
  final int fajrOffsetMinutes;
  final int sunriseOffsetMinutes;
  final int dhuhrOffsetMinutes;
  final int asrOffsetMinutes;
  final int maghribOffsetMinutes;
  final int ishaOffsetMinutes;
  final String aiMode;
  final bool voiceInputEnabled;
  final bool voiceReplyEnabled;
  final bool autoSpeakAiReply;
  final double voiceRate;
  final double voicePitch;
  final bool activeMentorEnabled;
  final String activeMentorMode;
  final int maxFollowUpsPerItem;
  final int quietHoursStartMinutes;
  final int quietHoursEndMinutes;
  final bool notificationsEnabled;
  final bool isOnboardingComplete;
  final DateTime updatedAt;
  const SettingsRecord({
    required this.id,
    required this.userName,
    required this.language,
    required this.themeMode,
    required this.city,
    required this.calculationMethod,
    required this.madhhab,
    required this.useGeolocation,
    required this.prayerNotificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.adhanEnabled,
    required this.manualPrayerOffsetsEnabled,
    required this.fajrOffsetMinutes,
    required this.sunriseOffsetMinutes,
    required this.dhuhrOffsetMinutes,
    required this.asrOffsetMinutes,
    required this.maghribOffsetMinutes,
    required this.ishaOffsetMinutes,
    required this.aiMode,
    required this.voiceInputEnabled,
    required this.voiceReplyEnabled,
    required this.autoSpeakAiReply,
    required this.voiceRate,
    required this.voicePitch,
    required this.activeMentorEnabled,
    required this.activeMentorMode,
    required this.maxFollowUpsPerItem,
    required this.quietHoursStartMinutes,
    required this.quietHoursEndMinutes,
    required this.notificationsEnabled,
    required this.isOnboardingComplete,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['language'] = Variable<String>(language);
    map['theme_mode'] = Variable<String>(themeMode);
    map['city'] = Variable<String>(city);
    map['calculation_method'] = Variable<String>(calculationMethod);
    map['madhhab'] = Variable<String>(madhhab);
    map['use_geolocation'] = Variable<bool>(useGeolocation);
    map['prayer_notifications_enabled'] = Variable<bool>(
      prayerNotificationsEnabled,
    );
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['vibration_enabled'] = Variable<bool>(vibrationEnabled);
    map['adhan_enabled'] = Variable<bool>(adhanEnabled);
    map['manual_prayer_offsets_enabled'] = Variable<bool>(
      manualPrayerOffsetsEnabled,
    );
    map['fajr_offset_minutes'] = Variable<int>(fajrOffsetMinutes);
    map['sunrise_offset_minutes'] = Variable<int>(sunriseOffsetMinutes);
    map['dhuhr_offset_minutes'] = Variable<int>(dhuhrOffsetMinutes);
    map['asr_offset_minutes'] = Variable<int>(asrOffsetMinutes);
    map['maghrib_offset_minutes'] = Variable<int>(maghribOffsetMinutes);
    map['isha_offset_minutes'] = Variable<int>(ishaOffsetMinutes);
    map['ai_mode'] = Variable<String>(aiMode);
    map['voice_input_enabled'] = Variable<bool>(voiceInputEnabled);
    map['voice_reply_enabled'] = Variable<bool>(voiceReplyEnabled);
    map['auto_speak_ai_reply'] = Variable<bool>(autoSpeakAiReply);
    map['voice_rate'] = Variable<double>(voiceRate);
    map['voice_pitch'] = Variable<double>(voicePitch);
    map['active_mentor_enabled'] = Variable<bool>(activeMentorEnabled);
    map['active_mentor_mode'] = Variable<String>(activeMentorMode);
    map['max_follow_ups_per_item'] = Variable<int>(maxFollowUpsPerItem);
    map['quiet_hours_start_minutes'] = Variable<int>(quietHoursStartMinutes);
    map['quiet_hours_end_minutes'] = Variable<int>(quietHoursEndMinutes);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['is_onboarding_complete'] = Variable<bool>(isOnboardingComplete);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsRecordsCompanion toCompanion(bool nullToAbsent) {
    return SettingsRecordsCompanion(
      id: Value(id),
      userName: Value(userName),
      language: Value(language),
      themeMode: Value(themeMode),
      city: Value(city),
      calculationMethod: Value(calculationMethod),
      madhhab: Value(madhhab),
      useGeolocation: Value(useGeolocation),
      prayerNotificationsEnabled: Value(prayerNotificationsEnabled),
      soundEnabled: Value(soundEnabled),
      vibrationEnabled: Value(vibrationEnabled),
      adhanEnabled: Value(adhanEnabled),
      manualPrayerOffsetsEnabled: Value(manualPrayerOffsetsEnabled),
      fajrOffsetMinutes: Value(fajrOffsetMinutes),
      sunriseOffsetMinutes: Value(sunriseOffsetMinutes),
      dhuhrOffsetMinutes: Value(dhuhrOffsetMinutes),
      asrOffsetMinutes: Value(asrOffsetMinutes),
      maghribOffsetMinutes: Value(maghribOffsetMinutes),
      ishaOffsetMinutes: Value(ishaOffsetMinutes),
      aiMode: Value(aiMode),
      voiceInputEnabled: Value(voiceInputEnabled),
      voiceReplyEnabled: Value(voiceReplyEnabled),
      autoSpeakAiReply: Value(autoSpeakAiReply),
      voiceRate: Value(voiceRate),
      voicePitch: Value(voicePitch),
      activeMentorEnabled: Value(activeMentorEnabled),
      activeMentorMode: Value(activeMentorMode),
      maxFollowUpsPerItem: Value(maxFollowUpsPerItem),
      quietHoursStartMinutes: Value(quietHoursStartMinutes),
      quietHoursEndMinutes: Value(quietHoursEndMinutes),
      notificationsEnabled: Value(notificationsEnabled),
      isOnboardingComplete: Value(isOnboardingComplete),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingsRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRecord(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      language: serializer.fromJson<String>(json['language']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      city: serializer.fromJson<String>(json['city']),
      calculationMethod: serializer.fromJson<String>(json['calculationMethod']),
      madhhab: serializer.fromJson<String>(json['madhhab']),
      useGeolocation: serializer.fromJson<bool>(json['useGeolocation']),
      prayerNotificationsEnabled: serializer.fromJson<bool>(
        json['prayerNotificationsEnabled'],
      ),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      vibrationEnabled: serializer.fromJson<bool>(json['vibrationEnabled']),
      adhanEnabled: serializer.fromJson<bool>(json['adhanEnabled']),
      manualPrayerOffsetsEnabled: serializer.fromJson<bool>(
        json['manualPrayerOffsetsEnabled'],
      ),
      fajrOffsetMinutes: serializer.fromJson<int>(json['fajrOffsetMinutes']),
      sunriseOffsetMinutes: serializer.fromJson<int>(
        json['sunriseOffsetMinutes'],
      ),
      dhuhrOffsetMinutes: serializer.fromJson<int>(json['dhuhrOffsetMinutes']),
      asrOffsetMinutes: serializer.fromJson<int>(json['asrOffsetMinutes']),
      maghribOffsetMinutes: serializer.fromJson<int>(
        json['maghribOffsetMinutes'],
      ),
      ishaOffsetMinutes: serializer.fromJson<int>(json['ishaOffsetMinutes']),
      aiMode: serializer.fromJson<String>(json['aiMode']),
      voiceInputEnabled: serializer.fromJson<bool>(json['voiceInputEnabled']),
      voiceReplyEnabled: serializer.fromJson<bool>(json['voiceReplyEnabled']),
      autoSpeakAiReply: serializer.fromJson<bool>(json['autoSpeakAiReply']),
      voiceRate: serializer.fromJson<double>(json['voiceRate']),
      voicePitch: serializer.fromJson<double>(json['voicePitch']),
      activeMentorEnabled: serializer.fromJson<bool>(
        json['activeMentorEnabled'],
      ),
      activeMentorMode: serializer.fromJson<String>(json['activeMentorMode']),
      maxFollowUpsPerItem: serializer.fromJson<int>(
        json['maxFollowUpsPerItem'],
      ),
      quietHoursStartMinutes: serializer.fromJson<int>(
        json['quietHoursStartMinutes'],
      ),
      quietHoursEndMinutes: serializer.fromJson<int>(
        json['quietHoursEndMinutes'],
      ),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      isOnboardingComplete: serializer.fromJson<bool>(
        json['isOnboardingComplete'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'language': serializer.toJson<String>(language),
      'themeMode': serializer.toJson<String>(themeMode),
      'city': serializer.toJson<String>(city),
      'calculationMethod': serializer.toJson<String>(calculationMethod),
      'madhhab': serializer.toJson<String>(madhhab),
      'useGeolocation': serializer.toJson<bool>(useGeolocation),
      'prayerNotificationsEnabled': serializer.toJson<bool>(
        prayerNotificationsEnabled,
      ),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'vibrationEnabled': serializer.toJson<bool>(vibrationEnabled),
      'adhanEnabled': serializer.toJson<bool>(adhanEnabled),
      'manualPrayerOffsetsEnabled': serializer.toJson<bool>(
        manualPrayerOffsetsEnabled,
      ),
      'fajrOffsetMinutes': serializer.toJson<int>(fajrOffsetMinutes),
      'sunriseOffsetMinutes': serializer.toJson<int>(sunriseOffsetMinutes),
      'dhuhrOffsetMinutes': serializer.toJson<int>(dhuhrOffsetMinutes),
      'asrOffsetMinutes': serializer.toJson<int>(asrOffsetMinutes),
      'maghribOffsetMinutes': serializer.toJson<int>(maghribOffsetMinutes),
      'ishaOffsetMinutes': serializer.toJson<int>(ishaOffsetMinutes),
      'aiMode': serializer.toJson<String>(aiMode),
      'voiceInputEnabled': serializer.toJson<bool>(voiceInputEnabled),
      'voiceReplyEnabled': serializer.toJson<bool>(voiceReplyEnabled),
      'autoSpeakAiReply': serializer.toJson<bool>(autoSpeakAiReply),
      'voiceRate': serializer.toJson<double>(voiceRate),
      'voicePitch': serializer.toJson<double>(voicePitch),
      'activeMentorEnabled': serializer.toJson<bool>(activeMentorEnabled),
      'activeMentorMode': serializer.toJson<String>(activeMentorMode),
      'maxFollowUpsPerItem': serializer.toJson<int>(maxFollowUpsPerItem),
      'quietHoursStartMinutes': serializer.toJson<int>(quietHoursStartMinutes),
      'quietHoursEndMinutes': serializer.toJson<int>(quietHoursEndMinutes),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'isOnboardingComplete': serializer.toJson<bool>(isOnboardingComplete),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SettingsRecord copyWith({
    int? id,
    String? userName,
    String? language,
    String? themeMode,
    String? city,
    String? calculationMethod,
    String? madhhab,
    bool? useGeolocation,
    bool? prayerNotificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? adhanEnabled,
    bool? manualPrayerOffsetsEnabled,
    int? fajrOffsetMinutes,
    int? sunriseOffsetMinutes,
    int? dhuhrOffsetMinutes,
    int? asrOffsetMinutes,
    int? maghribOffsetMinutes,
    int? ishaOffsetMinutes,
    String? aiMode,
    bool? voiceInputEnabled,
    bool? voiceReplyEnabled,
    bool? autoSpeakAiReply,
    double? voiceRate,
    double? voicePitch,
    bool? activeMentorEnabled,
    String? activeMentorMode,
    int? maxFollowUpsPerItem,
    int? quietHoursStartMinutes,
    int? quietHoursEndMinutes,
    bool? notificationsEnabled,
    bool? isOnboardingComplete,
    DateTime? updatedAt,
  }) => SettingsRecord(
    id: id ?? this.id,
    userName: userName ?? this.userName,
    language: language ?? this.language,
    themeMode: themeMode ?? this.themeMode,
    city: city ?? this.city,
    calculationMethod: calculationMethod ?? this.calculationMethod,
    madhhab: madhhab ?? this.madhhab,
    useGeolocation: useGeolocation ?? this.useGeolocation,
    prayerNotificationsEnabled:
        prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    adhanEnabled: adhanEnabled ?? this.adhanEnabled,
    manualPrayerOffsetsEnabled:
        manualPrayerOffsetsEnabled ?? this.manualPrayerOffsetsEnabled,
    fajrOffsetMinutes: fajrOffsetMinutes ?? this.fajrOffsetMinutes,
    sunriseOffsetMinutes: sunriseOffsetMinutes ?? this.sunriseOffsetMinutes,
    dhuhrOffsetMinutes: dhuhrOffsetMinutes ?? this.dhuhrOffsetMinutes,
    asrOffsetMinutes: asrOffsetMinutes ?? this.asrOffsetMinutes,
    maghribOffsetMinutes: maghribOffsetMinutes ?? this.maghribOffsetMinutes,
    ishaOffsetMinutes: ishaOffsetMinutes ?? this.ishaOffsetMinutes,
    aiMode: aiMode ?? this.aiMode,
    voiceInputEnabled: voiceInputEnabled ?? this.voiceInputEnabled,
    voiceReplyEnabled: voiceReplyEnabled ?? this.voiceReplyEnabled,
    autoSpeakAiReply: autoSpeakAiReply ?? this.autoSpeakAiReply,
    voiceRate: voiceRate ?? this.voiceRate,
    voicePitch: voicePitch ?? this.voicePitch,
    activeMentorEnabled: activeMentorEnabled ?? this.activeMentorEnabled,
    activeMentorMode: activeMentorMode ?? this.activeMentorMode,
    maxFollowUpsPerItem: maxFollowUpsPerItem ?? this.maxFollowUpsPerItem,
    quietHoursStartMinutes:
        quietHoursStartMinutes ?? this.quietHoursStartMinutes,
    quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SettingsRecord copyWithCompanion(SettingsRecordsCompanion data) {
    return SettingsRecord(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      language: data.language.present ? data.language.value : this.language,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      city: data.city.present ? data.city.value : this.city,
      calculationMethod: data.calculationMethod.present
          ? data.calculationMethod.value
          : this.calculationMethod,
      madhhab: data.madhhab.present ? data.madhhab.value : this.madhhab,
      useGeolocation: data.useGeolocation.present
          ? data.useGeolocation.value
          : this.useGeolocation,
      prayerNotificationsEnabled: data.prayerNotificationsEnabled.present
          ? data.prayerNotificationsEnabled.value
          : this.prayerNotificationsEnabled,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      vibrationEnabled: data.vibrationEnabled.present
          ? data.vibrationEnabled.value
          : this.vibrationEnabled,
      adhanEnabled: data.adhanEnabled.present
          ? data.adhanEnabled.value
          : this.adhanEnabled,
      manualPrayerOffsetsEnabled: data.manualPrayerOffsetsEnabled.present
          ? data.manualPrayerOffsetsEnabled.value
          : this.manualPrayerOffsetsEnabled,
      fajrOffsetMinutes: data.fajrOffsetMinutes.present
          ? data.fajrOffsetMinutes.value
          : this.fajrOffsetMinutes,
      sunriseOffsetMinutes: data.sunriseOffsetMinutes.present
          ? data.sunriseOffsetMinutes.value
          : this.sunriseOffsetMinutes,
      dhuhrOffsetMinutes: data.dhuhrOffsetMinutes.present
          ? data.dhuhrOffsetMinutes.value
          : this.dhuhrOffsetMinutes,
      asrOffsetMinutes: data.asrOffsetMinutes.present
          ? data.asrOffsetMinutes.value
          : this.asrOffsetMinutes,
      maghribOffsetMinutes: data.maghribOffsetMinutes.present
          ? data.maghribOffsetMinutes.value
          : this.maghribOffsetMinutes,
      ishaOffsetMinutes: data.ishaOffsetMinutes.present
          ? data.ishaOffsetMinutes.value
          : this.ishaOffsetMinutes,
      aiMode: data.aiMode.present ? data.aiMode.value : this.aiMode,
      voiceInputEnabled: data.voiceInputEnabled.present
          ? data.voiceInputEnabled.value
          : this.voiceInputEnabled,
      voiceReplyEnabled: data.voiceReplyEnabled.present
          ? data.voiceReplyEnabled.value
          : this.voiceReplyEnabled,
      autoSpeakAiReply: data.autoSpeakAiReply.present
          ? data.autoSpeakAiReply.value
          : this.autoSpeakAiReply,
      voiceRate: data.voiceRate.present ? data.voiceRate.value : this.voiceRate,
      voicePitch: data.voicePitch.present
          ? data.voicePitch.value
          : this.voicePitch,
      activeMentorEnabled: data.activeMentorEnabled.present
          ? data.activeMentorEnabled.value
          : this.activeMentorEnabled,
      activeMentorMode: data.activeMentorMode.present
          ? data.activeMentorMode.value
          : this.activeMentorMode,
      maxFollowUpsPerItem: data.maxFollowUpsPerItem.present
          ? data.maxFollowUpsPerItem.value
          : this.maxFollowUpsPerItem,
      quietHoursStartMinutes: data.quietHoursStartMinutes.present
          ? data.quietHoursStartMinutes.value
          : this.quietHoursStartMinutes,
      quietHoursEndMinutes: data.quietHoursEndMinutes.present
          ? data.quietHoursEndMinutes.value
          : this.quietHoursEndMinutes,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      isOnboardingComplete: data.isOnboardingComplete.present
          ? data.isOnboardingComplete.value
          : this.isOnboardingComplete,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRecord(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('language: $language, ')
          ..write('themeMode: $themeMode, ')
          ..write('city: $city, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('madhhab: $madhhab, ')
          ..write('useGeolocation: $useGeolocation, ')
          ..write('prayerNotificationsEnabled: $prayerNotificationsEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('adhanEnabled: $adhanEnabled, ')
          ..write('manualPrayerOffsetsEnabled: $manualPrayerOffsetsEnabled, ')
          ..write('fajrOffsetMinutes: $fajrOffsetMinutes, ')
          ..write('sunriseOffsetMinutes: $sunriseOffsetMinutes, ')
          ..write('dhuhrOffsetMinutes: $dhuhrOffsetMinutes, ')
          ..write('asrOffsetMinutes: $asrOffsetMinutes, ')
          ..write('maghribOffsetMinutes: $maghribOffsetMinutes, ')
          ..write('ishaOffsetMinutes: $ishaOffsetMinutes, ')
          ..write('aiMode: $aiMode, ')
          ..write('voiceInputEnabled: $voiceInputEnabled, ')
          ..write('voiceReplyEnabled: $voiceReplyEnabled, ')
          ..write('autoSpeakAiReply: $autoSpeakAiReply, ')
          ..write('voiceRate: $voiceRate, ')
          ..write('voicePitch: $voicePitch, ')
          ..write('activeMentorEnabled: $activeMentorEnabled, ')
          ..write('activeMentorMode: $activeMentorMode, ')
          ..write('maxFollowUpsPerItem: $maxFollowUpsPerItem, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('isOnboardingComplete: $isOnboardingComplete, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userName,
    language,
    themeMode,
    city,
    calculationMethod,
    madhhab,
    useGeolocation,
    prayerNotificationsEnabled,
    soundEnabled,
    vibrationEnabled,
    adhanEnabled,
    manualPrayerOffsetsEnabled,
    fajrOffsetMinutes,
    sunriseOffsetMinutes,
    dhuhrOffsetMinutes,
    asrOffsetMinutes,
    maghribOffsetMinutes,
    ishaOffsetMinutes,
    aiMode,
    voiceInputEnabled,
    voiceReplyEnabled,
    autoSpeakAiReply,
    voiceRate,
    voicePitch,
    activeMentorEnabled,
    activeMentorMode,
    maxFollowUpsPerItem,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    notificationsEnabled,
    isOnboardingComplete,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRecord &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.language == this.language &&
          other.themeMode == this.themeMode &&
          other.city == this.city &&
          other.calculationMethod == this.calculationMethod &&
          other.madhhab == this.madhhab &&
          other.useGeolocation == this.useGeolocation &&
          other.prayerNotificationsEnabled == this.prayerNotificationsEnabled &&
          other.soundEnabled == this.soundEnabled &&
          other.vibrationEnabled == this.vibrationEnabled &&
          other.adhanEnabled == this.adhanEnabled &&
          other.manualPrayerOffsetsEnabled == this.manualPrayerOffsetsEnabled &&
          other.fajrOffsetMinutes == this.fajrOffsetMinutes &&
          other.sunriseOffsetMinutes == this.sunriseOffsetMinutes &&
          other.dhuhrOffsetMinutes == this.dhuhrOffsetMinutes &&
          other.asrOffsetMinutes == this.asrOffsetMinutes &&
          other.maghribOffsetMinutes == this.maghribOffsetMinutes &&
          other.ishaOffsetMinutes == this.ishaOffsetMinutes &&
          other.aiMode == this.aiMode &&
          other.voiceInputEnabled == this.voiceInputEnabled &&
          other.voiceReplyEnabled == this.voiceReplyEnabled &&
          other.autoSpeakAiReply == this.autoSpeakAiReply &&
          other.voiceRate == this.voiceRate &&
          other.voicePitch == this.voicePitch &&
          other.activeMentorEnabled == this.activeMentorEnabled &&
          other.activeMentorMode == this.activeMentorMode &&
          other.maxFollowUpsPerItem == this.maxFollowUpsPerItem &&
          other.quietHoursStartMinutes == this.quietHoursStartMinutes &&
          other.quietHoursEndMinutes == this.quietHoursEndMinutes &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.isOnboardingComplete == this.isOnboardingComplete &&
          other.updatedAt == this.updatedAt);
}

class SettingsRecordsCompanion extends UpdateCompanion<SettingsRecord> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> language;
  final Value<String> themeMode;
  final Value<String> city;
  final Value<String> calculationMethod;
  final Value<String> madhhab;
  final Value<bool> useGeolocation;
  final Value<bool> prayerNotificationsEnabled;
  final Value<bool> soundEnabled;
  final Value<bool> vibrationEnabled;
  final Value<bool> adhanEnabled;
  final Value<bool> manualPrayerOffsetsEnabled;
  final Value<int> fajrOffsetMinutes;
  final Value<int> sunriseOffsetMinutes;
  final Value<int> dhuhrOffsetMinutes;
  final Value<int> asrOffsetMinutes;
  final Value<int> maghribOffsetMinutes;
  final Value<int> ishaOffsetMinutes;
  final Value<String> aiMode;
  final Value<bool> voiceInputEnabled;
  final Value<bool> voiceReplyEnabled;
  final Value<bool> autoSpeakAiReply;
  final Value<double> voiceRate;
  final Value<double> voicePitch;
  final Value<bool> activeMentorEnabled;
  final Value<String> activeMentorMode;
  final Value<int> maxFollowUpsPerItem;
  final Value<int> quietHoursStartMinutes;
  final Value<int> quietHoursEndMinutes;
  final Value<bool> notificationsEnabled;
  final Value<bool> isOnboardingComplete;
  final Value<DateTime> updatedAt;
  const SettingsRecordsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.language = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.city = const Value.absent(),
    this.calculationMethod = const Value.absent(),
    this.madhhab = const Value.absent(),
    this.useGeolocation = const Value.absent(),
    this.prayerNotificationsEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.adhanEnabled = const Value.absent(),
    this.manualPrayerOffsetsEnabled = const Value.absent(),
    this.fajrOffsetMinutes = const Value.absent(),
    this.sunriseOffsetMinutes = const Value.absent(),
    this.dhuhrOffsetMinutes = const Value.absent(),
    this.asrOffsetMinutes = const Value.absent(),
    this.maghribOffsetMinutes = const Value.absent(),
    this.ishaOffsetMinutes = const Value.absent(),
    this.aiMode = const Value.absent(),
    this.voiceInputEnabled = const Value.absent(),
    this.voiceReplyEnabled = const Value.absent(),
    this.autoSpeakAiReply = const Value.absent(),
    this.voiceRate = const Value.absent(),
    this.voicePitch = const Value.absent(),
    this.activeMentorEnabled = const Value.absent(),
    this.activeMentorMode = const Value.absent(),
    this.maxFollowUpsPerItem = const Value.absent(),
    this.quietHoursStartMinutes = const Value.absent(),
    this.quietHoursEndMinutes = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.isOnboardingComplete = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SettingsRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userName,
    required String language,
    required String themeMode,
    required String city,
    required String calculationMethod,
    required String madhhab,
    required bool useGeolocation,
    required bool prayerNotificationsEnabled,
    required bool soundEnabled,
    required bool vibrationEnabled,
    required bool adhanEnabled,
    this.manualPrayerOffsetsEnabled = const Value.absent(),
    this.fajrOffsetMinutes = const Value.absent(),
    this.sunriseOffsetMinutes = const Value.absent(),
    this.dhuhrOffsetMinutes = const Value.absent(),
    this.asrOffsetMinutes = const Value.absent(),
    this.maghribOffsetMinutes = const Value.absent(),
    this.ishaOffsetMinutes = const Value.absent(),
    required String aiMode,
    this.voiceInputEnabled = const Value.absent(),
    this.voiceReplyEnabled = const Value.absent(),
    this.autoSpeakAiReply = const Value.absent(),
    this.voiceRate = const Value.absent(),
    this.voicePitch = const Value.absent(),
    required bool activeMentorEnabled,
    required String activeMentorMode,
    required int maxFollowUpsPerItem,
    required int quietHoursStartMinutes,
    required int quietHoursEndMinutes,
    required bool notificationsEnabled,
    required bool isOnboardingComplete,
    required DateTime updatedAt,
  }) : userName = Value(userName),
       language = Value(language),
       themeMode = Value(themeMode),
       city = Value(city),
       calculationMethod = Value(calculationMethod),
       madhhab = Value(madhhab),
       useGeolocation = Value(useGeolocation),
       prayerNotificationsEnabled = Value(prayerNotificationsEnabled),
       soundEnabled = Value(soundEnabled),
       vibrationEnabled = Value(vibrationEnabled),
       adhanEnabled = Value(adhanEnabled),
       aiMode = Value(aiMode),
       activeMentorEnabled = Value(activeMentorEnabled),
       activeMentorMode = Value(activeMentorMode),
       maxFollowUpsPerItem = Value(maxFollowUpsPerItem),
       quietHoursStartMinutes = Value(quietHoursStartMinutes),
       quietHoursEndMinutes = Value(quietHoursEndMinutes),
       notificationsEnabled = Value(notificationsEnabled),
       isOnboardingComplete = Value(isOnboardingComplete),
       updatedAt = Value(updatedAt);
  static Insertable<SettingsRecord> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? language,
    Expression<String>? themeMode,
    Expression<String>? city,
    Expression<String>? calculationMethod,
    Expression<String>? madhhab,
    Expression<bool>? useGeolocation,
    Expression<bool>? prayerNotificationsEnabled,
    Expression<bool>? soundEnabled,
    Expression<bool>? vibrationEnabled,
    Expression<bool>? adhanEnabled,
    Expression<bool>? manualPrayerOffsetsEnabled,
    Expression<int>? fajrOffsetMinutes,
    Expression<int>? sunriseOffsetMinutes,
    Expression<int>? dhuhrOffsetMinutes,
    Expression<int>? asrOffsetMinutes,
    Expression<int>? maghribOffsetMinutes,
    Expression<int>? ishaOffsetMinutes,
    Expression<String>? aiMode,
    Expression<bool>? voiceInputEnabled,
    Expression<bool>? voiceReplyEnabled,
    Expression<bool>? autoSpeakAiReply,
    Expression<double>? voiceRate,
    Expression<double>? voicePitch,
    Expression<bool>? activeMentorEnabled,
    Expression<String>? activeMentorMode,
    Expression<int>? maxFollowUpsPerItem,
    Expression<int>? quietHoursStartMinutes,
    Expression<int>? quietHoursEndMinutes,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? isOnboardingComplete,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (language != null) 'language': language,
      if (themeMode != null) 'theme_mode': themeMode,
      if (city != null) 'city': city,
      if (calculationMethod != null) 'calculation_method': calculationMethod,
      if (madhhab != null) 'madhhab': madhhab,
      if (useGeolocation != null) 'use_geolocation': useGeolocation,
      if (prayerNotificationsEnabled != null)
        'prayer_notifications_enabled': prayerNotificationsEnabled,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (adhanEnabled != null) 'adhan_enabled': adhanEnabled,
      if (manualPrayerOffsetsEnabled != null)
        'manual_prayer_offsets_enabled': manualPrayerOffsetsEnabled,
      if (fajrOffsetMinutes != null) 'fajr_offset_minutes': fajrOffsetMinutes,
      if (sunriseOffsetMinutes != null)
        'sunrise_offset_minutes': sunriseOffsetMinutes,
      if (dhuhrOffsetMinutes != null)
        'dhuhr_offset_minutes': dhuhrOffsetMinutes,
      if (asrOffsetMinutes != null) 'asr_offset_minutes': asrOffsetMinutes,
      if (maghribOffsetMinutes != null)
        'maghrib_offset_minutes': maghribOffsetMinutes,
      if (ishaOffsetMinutes != null) 'isha_offset_minutes': ishaOffsetMinutes,
      if (aiMode != null) 'ai_mode': aiMode,
      if (voiceInputEnabled != null) 'voice_input_enabled': voiceInputEnabled,
      if (voiceReplyEnabled != null) 'voice_reply_enabled': voiceReplyEnabled,
      if (autoSpeakAiReply != null) 'auto_speak_ai_reply': autoSpeakAiReply,
      if (voiceRate != null) 'voice_rate': voiceRate,
      if (voicePitch != null) 'voice_pitch': voicePitch,
      if (activeMentorEnabled != null)
        'active_mentor_enabled': activeMentorEnabled,
      if (activeMentorMode != null) 'active_mentor_mode': activeMentorMode,
      if (maxFollowUpsPerItem != null)
        'max_follow_ups_per_item': maxFollowUpsPerItem,
      if (quietHoursStartMinutes != null)
        'quiet_hours_start_minutes': quietHoursStartMinutes,
      if (quietHoursEndMinutes != null)
        'quiet_hours_end_minutes': quietHoursEndMinutes,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (isOnboardingComplete != null)
        'is_onboarding_complete': isOnboardingComplete,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SettingsRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userName,
    Value<String>? language,
    Value<String>? themeMode,
    Value<String>? city,
    Value<String>? calculationMethod,
    Value<String>? madhhab,
    Value<bool>? useGeolocation,
    Value<bool>? prayerNotificationsEnabled,
    Value<bool>? soundEnabled,
    Value<bool>? vibrationEnabled,
    Value<bool>? adhanEnabled,
    Value<bool>? manualPrayerOffsetsEnabled,
    Value<int>? fajrOffsetMinutes,
    Value<int>? sunriseOffsetMinutes,
    Value<int>? dhuhrOffsetMinutes,
    Value<int>? asrOffsetMinutes,
    Value<int>? maghribOffsetMinutes,
    Value<int>? ishaOffsetMinutes,
    Value<String>? aiMode,
    Value<bool>? voiceInputEnabled,
    Value<bool>? voiceReplyEnabled,
    Value<bool>? autoSpeakAiReply,
    Value<double>? voiceRate,
    Value<double>? voicePitch,
    Value<bool>? activeMentorEnabled,
    Value<String>? activeMentorMode,
    Value<int>? maxFollowUpsPerItem,
    Value<int>? quietHoursStartMinutes,
    Value<int>? quietHoursEndMinutes,
    Value<bool>? notificationsEnabled,
    Value<bool>? isOnboardingComplete,
    Value<DateTime>? updatedAt,
  }) {
    return SettingsRecordsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      city: city ?? this.city,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhhab: madhhab ?? this.madhhab,
      useGeolocation: useGeolocation ?? this.useGeolocation,
      prayerNotificationsEnabled:
          prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      adhanEnabled: adhanEnabled ?? this.adhanEnabled,
      manualPrayerOffsetsEnabled:
          manualPrayerOffsetsEnabled ?? this.manualPrayerOffsetsEnabled,
      fajrOffsetMinutes: fajrOffsetMinutes ?? this.fajrOffsetMinutes,
      sunriseOffsetMinutes: sunriseOffsetMinutes ?? this.sunriseOffsetMinutes,
      dhuhrOffsetMinutes: dhuhrOffsetMinutes ?? this.dhuhrOffsetMinutes,
      asrOffsetMinutes: asrOffsetMinutes ?? this.asrOffsetMinutes,
      maghribOffsetMinutes: maghribOffsetMinutes ?? this.maghribOffsetMinutes,
      ishaOffsetMinutes: ishaOffsetMinutes ?? this.ishaOffsetMinutes,
      aiMode: aiMode ?? this.aiMode,
      voiceInputEnabled: voiceInputEnabled ?? this.voiceInputEnabled,
      voiceReplyEnabled: voiceReplyEnabled ?? this.voiceReplyEnabled,
      autoSpeakAiReply: autoSpeakAiReply ?? this.autoSpeakAiReply,
      voiceRate: voiceRate ?? this.voiceRate,
      voicePitch: voicePitch ?? this.voicePitch,
      activeMentorEnabled: activeMentorEnabled ?? this.activeMentorEnabled,
      activeMentorMode: activeMentorMode ?? this.activeMentorMode,
      maxFollowUpsPerItem: maxFollowUpsPerItem ?? this.maxFollowUpsPerItem,
      quietHoursStartMinutes:
          quietHoursStartMinutes ?? this.quietHoursStartMinutes,
      quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (calculationMethod.present) {
      map['calculation_method'] = Variable<String>(calculationMethod.value);
    }
    if (madhhab.present) {
      map['madhhab'] = Variable<String>(madhhab.value);
    }
    if (useGeolocation.present) {
      map['use_geolocation'] = Variable<bool>(useGeolocation.value);
    }
    if (prayerNotificationsEnabled.present) {
      map['prayer_notifications_enabled'] = Variable<bool>(
        prayerNotificationsEnabled.value,
      );
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (vibrationEnabled.present) {
      map['vibration_enabled'] = Variable<bool>(vibrationEnabled.value);
    }
    if (adhanEnabled.present) {
      map['adhan_enabled'] = Variable<bool>(adhanEnabled.value);
    }
    if (manualPrayerOffsetsEnabled.present) {
      map['manual_prayer_offsets_enabled'] = Variable<bool>(
        manualPrayerOffsetsEnabled.value,
      );
    }
    if (fajrOffsetMinutes.present) {
      map['fajr_offset_minutes'] = Variable<int>(fajrOffsetMinutes.value);
    }
    if (sunriseOffsetMinutes.present) {
      map['sunrise_offset_minutes'] = Variable<int>(sunriseOffsetMinutes.value);
    }
    if (dhuhrOffsetMinutes.present) {
      map['dhuhr_offset_minutes'] = Variable<int>(dhuhrOffsetMinutes.value);
    }
    if (asrOffsetMinutes.present) {
      map['asr_offset_minutes'] = Variable<int>(asrOffsetMinutes.value);
    }
    if (maghribOffsetMinutes.present) {
      map['maghrib_offset_minutes'] = Variable<int>(maghribOffsetMinutes.value);
    }
    if (ishaOffsetMinutes.present) {
      map['isha_offset_minutes'] = Variable<int>(ishaOffsetMinutes.value);
    }
    if (aiMode.present) {
      map['ai_mode'] = Variable<String>(aiMode.value);
    }
    if (voiceInputEnabled.present) {
      map['voice_input_enabled'] = Variable<bool>(voiceInputEnabled.value);
    }
    if (voiceReplyEnabled.present) {
      map['voice_reply_enabled'] = Variable<bool>(voiceReplyEnabled.value);
    }
    if (autoSpeakAiReply.present) {
      map['auto_speak_ai_reply'] = Variable<bool>(autoSpeakAiReply.value);
    }
    if (voiceRate.present) {
      map['voice_rate'] = Variable<double>(voiceRate.value);
    }
    if (voicePitch.present) {
      map['voice_pitch'] = Variable<double>(voicePitch.value);
    }
    if (activeMentorEnabled.present) {
      map['active_mentor_enabled'] = Variable<bool>(activeMentorEnabled.value);
    }
    if (activeMentorMode.present) {
      map['active_mentor_mode'] = Variable<String>(activeMentorMode.value);
    }
    if (maxFollowUpsPerItem.present) {
      map['max_follow_ups_per_item'] = Variable<int>(maxFollowUpsPerItem.value);
    }
    if (quietHoursStartMinutes.present) {
      map['quiet_hours_start_minutes'] = Variable<int>(
        quietHoursStartMinutes.value,
      );
    }
    if (quietHoursEndMinutes.present) {
      map['quiet_hours_end_minutes'] = Variable<int>(
        quietHoursEndMinutes.value,
      );
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (isOnboardingComplete.present) {
      map['is_onboarding_complete'] = Variable<bool>(
        isOnboardingComplete.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('language: $language, ')
          ..write('themeMode: $themeMode, ')
          ..write('city: $city, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('madhhab: $madhhab, ')
          ..write('useGeolocation: $useGeolocation, ')
          ..write('prayerNotificationsEnabled: $prayerNotificationsEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('adhanEnabled: $adhanEnabled, ')
          ..write('manualPrayerOffsetsEnabled: $manualPrayerOffsetsEnabled, ')
          ..write('fajrOffsetMinutes: $fajrOffsetMinutes, ')
          ..write('sunriseOffsetMinutes: $sunriseOffsetMinutes, ')
          ..write('dhuhrOffsetMinutes: $dhuhrOffsetMinutes, ')
          ..write('asrOffsetMinutes: $asrOffsetMinutes, ')
          ..write('maghribOffsetMinutes: $maghribOffsetMinutes, ')
          ..write('ishaOffsetMinutes: $ishaOffsetMinutes, ')
          ..write('aiMode: $aiMode, ')
          ..write('voiceInputEnabled: $voiceInputEnabled, ')
          ..write('voiceReplyEnabled: $voiceReplyEnabled, ')
          ..write('autoSpeakAiReply: $autoSpeakAiReply, ')
          ..write('voiceRate: $voiceRate, ')
          ..write('voicePitch: $voicePitch, ')
          ..write('activeMentorEnabled: $activeMentorEnabled, ')
          ..write('activeMentorMode: $activeMentorMode, ')
          ..write('maxFollowUpsPerItem: $maxFollowUpsPerItem, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('isOnboardingComplete: $isOnboardingComplete, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppActivityRecordsTable extends AppActivityRecords
    with TableInfo<$AppActivityRecordsTable, AppActivityRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppActivityRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appOpenedMeta = const VerificationMeta(
    'appOpened',
  );
  @override
  late final GeneratedColumn<bool> appOpened = GeneratedColumn<bool>(
    'app_opened',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("app_opened" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _tasksCompletedMeta = const VerificationMeta(
    'tasksCompleted',
  );
  @override
  late final GeneratedColumn<int> tasksCompleted = GeneratedColumn<int>(
    'tasks_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _habitsCompletedMeta = const VerificationMeta(
    'habitsCompleted',
  );
  @override
  late final GeneratedColumn<int> habitsCompleted = GeneratedColumn<int>(
    'habits_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _prayersCompletedMeta = const VerificationMeta(
    'prayersCompleted',
  );
  @override
  late final GeneratedColumn<int> prayersCompleted = GeneratedColumn<int>(
    'prayers_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _perfectDayMeta = const VerificationMeta(
    'perfectDay',
  );
  @override
  late final GeneratedColumn<bool> perfectDay = GeneratedColumn<bool>(
    'perfect_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("perfect_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    appOpened,
    tasksCompleted,
    habitsCompleted,
    prayersCompleted,
    perfectDay,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_activity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppActivityRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('app_opened')) {
      context.handle(
        _appOpenedMeta,
        appOpened.isAcceptableOrUnknown(data['app_opened']!, _appOpenedMeta),
      );
    }
    if (data.containsKey('tasks_completed')) {
      context.handle(
        _tasksCompletedMeta,
        tasksCompleted.isAcceptableOrUnknown(
          data['tasks_completed']!,
          _tasksCompletedMeta,
        ),
      );
    }
    if (data.containsKey('habits_completed')) {
      context.handle(
        _habitsCompletedMeta,
        habitsCompleted.isAcceptableOrUnknown(
          data['habits_completed']!,
          _habitsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('prayers_completed')) {
      context.handle(
        _prayersCompletedMeta,
        prayersCompleted.isAcceptableOrUnknown(
          data['prayers_completed']!,
          _prayersCompletedMeta,
        ),
      );
    }
    if (data.containsKey('perfect_day')) {
      context.handle(
        _perfectDayMeta,
        perfectDay.isAcceptableOrUnknown(data['perfect_day']!, _perfectDayMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  AppActivityRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppActivityRecord(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      appOpened: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}app_opened'],
      )!,
      tasksCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tasks_completed'],
      )!,
      habitsCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habits_completed'],
      )!,
      prayersCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prayers_completed'],
      )!,
      perfectDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}perfect_day'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppActivityRecordsTable createAlias(String alias) {
    return $AppActivityRecordsTable(attachedDatabase, alias);
  }
}

class AppActivityRecord extends DataClass
    implements Insertable<AppActivityRecord> {
  final DateTime date;
  final bool appOpened;
  final int tasksCompleted;
  final int habitsCompleted;
  final int prayersCompleted;
  final bool perfectDay;
  final DateTime updatedAt;
  const AppActivityRecord({
    required this.date,
    required this.appOpened,
    required this.tasksCompleted,
    required this.habitsCompleted,
    required this.prayersCompleted,
    required this.perfectDay,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['app_opened'] = Variable<bool>(appOpened);
    map['tasks_completed'] = Variable<int>(tasksCompleted);
    map['habits_completed'] = Variable<int>(habitsCompleted);
    map['prayers_completed'] = Variable<int>(prayersCompleted);
    map['perfect_day'] = Variable<bool>(perfectDay);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppActivityRecordsCompanion toCompanion(bool nullToAbsent) {
    return AppActivityRecordsCompanion(
      date: Value(date),
      appOpened: Value(appOpened),
      tasksCompleted: Value(tasksCompleted),
      habitsCompleted: Value(habitsCompleted),
      prayersCompleted: Value(prayersCompleted),
      perfectDay: Value(perfectDay),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppActivityRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppActivityRecord(
      date: serializer.fromJson<DateTime>(json['date']),
      appOpened: serializer.fromJson<bool>(json['appOpened']),
      tasksCompleted: serializer.fromJson<int>(json['tasksCompleted']),
      habitsCompleted: serializer.fromJson<int>(json['habitsCompleted']),
      prayersCompleted: serializer.fromJson<int>(json['prayersCompleted']),
      perfectDay: serializer.fromJson<bool>(json['perfectDay']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'appOpened': serializer.toJson<bool>(appOpened),
      'tasksCompleted': serializer.toJson<int>(tasksCompleted),
      'habitsCompleted': serializer.toJson<int>(habitsCompleted),
      'prayersCompleted': serializer.toJson<int>(prayersCompleted),
      'perfectDay': serializer.toJson<bool>(perfectDay),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppActivityRecord copyWith({
    DateTime? date,
    bool? appOpened,
    int? tasksCompleted,
    int? habitsCompleted,
    int? prayersCompleted,
    bool? perfectDay,
    DateTime? updatedAt,
  }) => AppActivityRecord(
    date: date ?? this.date,
    appOpened: appOpened ?? this.appOpened,
    tasksCompleted: tasksCompleted ?? this.tasksCompleted,
    habitsCompleted: habitsCompleted ?? this.habitsCompleted,
    prayersCompleted: prayersCompleted ?? this.prayersCompleted,
    perfectDay: perfectDay ?? this.perfectDay,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppActivityRecord copyWithCompanion(AppActivityRecordsCompanion data) {
    return AppActivityRecord(
      date: data.date.present ? data.date.value : this.date,
      appOpened: data.appOpened.present ? data.appOpened.value : this.appOpened,
      tasksCompleted: data.tasksCompleted.present
          ? data.tasksCompleted.value
          : this.tasksCompleted,
      habitsCompleted: data.habitsCompleted.present
          ? data.habitsCompleted.value
          : this.habitsCompleted,
      prayersCompleted: data.prayersCompleted.present
          ? data.prayersCompleted.value
          : this.prayersCompleted,
      perfectDay: data.perfectDay.present
          ? data.perfectDay.value
          : this.perfectDay,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppActivityRecord(')
          ..write('date: $date, ')
          ..write('appOpened: $appOpened, ')
          ..write('tasksCompleted: $tasksCompleted, ')
          ..write('habitsCompleted: $habitsCompleted, ')
          ..write('prayersCompleted: $prayersCompleted, ')
          ..write('perfectDay: $perfectDay, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    appOpened,
    tasksCompleted,
    habitsCompleted,
    prayersCompleted,
    perfectDay,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppActivityRecord &&
          other.date == this.date &&
          other.appOpened == this.appOpened &&
          other.tasksCompleted == this.tasksCompleted &&
          other.habitsCompleted == this.habitsCompleted &&
          other.prayersCompleted == this.prayersCompleted &&
          other.perfectDay == this.perfectDay &&
          other.updatedAt == this.updatedAt);
}

class AppActivityRecordsCompanion extends UpdateCompanion<AppActivityRecord> {
  final Value<DateTime> date;
  final Value<bool> appOpened;
  final Value<int> tasksCompleted;
  final Value<int> habitsCompleted;
  final Value<int> prayersCompleted;
  final Value<bool> perfectDay;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppActivityRecordsCompanion({
    this.date = const Value.absent(),
    this.appOpened = const Value.absent(),
    this.tasksCompleted = const Value.absent(),
    this.habitsCompleted = const Value.absent(),
    this.prayersCompleted = const Value.absent(),
    this.perfectDay = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppActivityRecordsCompanion.insert({
    required DateTime date,
    this.appOpened = const Value.absent(),
    this.tasksCompleted = const Value.absent(),
    this.habitsCompleted = const Value.absent(),
    this.prayersCompleted = const Value.absent(),
    this.perfectDay = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<AppActivityRecord> custom({
    Expression<DateTime>? date,
    Expression<bool>? appOpened,
    Expression<int>? tasksCompleted,
    Expression<int>? habitsCompleted,
    Expression<int>? prayersCompleted,
    Expression<bool>? perfectDay,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (appOpened != null) 'app_opened': appOpened,
      if (tasksCompleted != null) 'tasks_completed': tasksCompleted,
      if (habitsCompleted != null) 'habits_completed': habitsCompleted,
      if (prayersCompleted != null) 'prayers_completed': prayersCompleted,
      if (perfectDay != null) 'perfect_day': perfectDay,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppActivityRecordsCompanion copyWith({
    Value<DateTime>? date,
    Value<bool>? appOpened,
    Value<int>? tasksCompleted,
    Value<int>? habitsCompleted,
    Value<int>? prayersCompleted,
    Value<bool>? perfectDay,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppActivityRecordsCompanion(
      date: date ?? this.date,
      appOpened: appOpened ?? this.appOpened,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      habitsCompleted: habitsCompleted ?? this.habitsCompleted,
      prayersCompleted: prayersCompleted ?? this.prayersCompleted,
      perfectDay: perfectDay ?? this.perfectDay,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (appOpened.present) {
      map['app_opened'] = Variable<bool>(appOpened.value);
    }
    if (tasksCompleted.present) {
      map['tasks_completed'] = Variable<int>(tasksCompleted.value);
    }
    if (habitsCompleted.present) {
      map['habits_completed'] = Variable<int>(habitsCompleted.value);
    }
    if (prayersCompleted.present) {
      map['prayers_completed'] = Variable<int>(prayersCompleted.value);
    }
    if (perfectDay.present) {
      map['perfect_day'] = Variable<bool>(perfectDay.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppActivityRecordsCompanion(')
          ..write('date: $date, ')
          ..write('appOpened: $appOpened, ')
          ..write('tasksCompleted: $tasksCompleted, ')
          ..write('habitsCompleted: $habitsCompleted, ')
          ..write('prayersCompleted: $prayersCompleted, ')
          ..write('perfectDay: $perfectDay, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SemanticIndexItemsTable extends SemanticIndexItems
    with TableInfo<$SemanticIndexItemsTable, SemanticIndexItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SemanticIndexItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _embeddingJsonMeta = const VerificationMeta(
    'embeddingJson',
  );
  @override
  late final GeneratedColumn<String> embeddingJson = GeneratedColumn<String>(
    'embedding_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    sourceId,
    title,
    content,
    embeddingJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'semantic_index_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SemanticIndexItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('embedding_json')) {
      context.handle(
        _embeddingJsonMeta,
        embeddingJson.isAcceptableOrUnknown(
          data['embedding_json']!,
          _embeddingJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_embeddingJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SemanticIndexItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SemanticIndexItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      embeddingJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedding_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SemanticIndexItemsTable createAlias(String alias) {
    return $SemanticIndexItemsTable(attachedDatabase, alias);
  }
}

class SemanticIndexItem extends DataClass
    implements Insertable<SemanticIndexItem> {
  final String id;
  final String sourceType;
  final String sourceId;
  final String title;
  final String content;
  final String embeddingJson;
  final DateTime updatedAt;
  const SemanticIndexItem({
    required this.id,
    required this.sourceType,
    required this.sourceId,
    required this.title,
    required this.content,
    required this.embeddingJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['embedding_json'] = Variable<String>(embeddingJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SemanticIndexItemsCompanion toCompanion(bool nullToAbsent) {
    return SemanticIndexItemsCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      title: Value(title),
      content: Value(content),
      embeddingJson: Value(embeddingJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory SemanticIndexItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SemanticIndexItem(
      id: serializer.fromJson<String>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      embeddingJson: serializer.fromJson<String>(json['embeddingJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'embeddingJson': serializer.toJson<String>(embeddingJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SemanticIndexItem copyWith({
    String? id,
    String? sourceType,
    String? sourceId,
    String? title,
    String? content,
    String? embeddingJson,
    DateTime? updatedAt,
  }) => SemanticIndexItem(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    title: title ?? this.title,
    content: content ?? this.content,
    embeddingJson: embeddingJson ?? this.embeddingJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SemanticIndexItem copyWithCompanion(SemanticIndexItemsCompanion data) {
    return SemanticIndexItem(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      embeddingJson: data.embeddingJson.present
          ? data.embeddingJson.value
          : this.embeddingJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SemanticIndexItem(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('embeddingJson: $embeddingJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    sourceId,
    title,
    content,
    embeddingJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SemanticIndexItem &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.content == this.content &&
          other.embeddingJson == this.embeddingJson &&
          other.updatedAt == this.updatedAt);
}

class SemanticIndexItemsCompanion extends UpdateCompanion<SemanticIndexItem> {
  final Value<String> id;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<String> title;
  final Value<String> content;
  final Value<String> embeddingJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SemanticIndexItemsCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.embeddingJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SemanticIndexItemsCompanion.insert({
    required String id,
    required String sourceType,
    required String sourceId,
    required String title,
    this.content = const Value.absent(),
    required String embeddingJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       title = Value(title),
       embeddingJson = Value(embeddingJson),
       updatedAt = Value(updatedAt);
  static Insertable<SemanticIndexItem> custom({
    Expression<String>? id,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? embeddingJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (embeddingJson != null) 'embedding_json': embeddingJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SemanticIndexItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<String>? title,
    Value<String>? content,
    Value<String>? embeddingJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SemanticIndexItemsCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      content: content ?? this.content,
      embeddingJson: embeddingJson ?? this.embeddingJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (embeddingJson.present) {
      map['embedding_json'] = Variable<String>(embeddingJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SemanticIndexItemsCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('embeddingJson: $embeddingJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskRecordsTable taskRecords = $TaskRecordsTable(this);
  late final $HabitRecordsTable habitRecords = $HabitRecordsTable(this);
  late final $HabitCheckInRecordsTable habitCheckInRecords =
      $HabitCheckInRecordsTable(this);
  late final $NoteRecordsTable noteRecords = $NoteRecordsTable(this);
  late final $SettingsRecordsTable settingsRecords = $SettingsRecordsTable(
    this,
  );
  late final $AppActivityRecordsTable appActivityRecords =
      $AppActivityRecordsTable(this);
  late final $SemanticIndexItemsTable semanticIndexItems =
      $SemanticIndexItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskRecords,
    habitRecords,
    habitCheckInRecords,
    noteRecords,
    settingsRecords,
    appActivityRecords,
    semanticIndexItems,
  ];
}

typedef $$TaskRecordsTableCreateCompanionBuilder =
    TaskRecordsCompanion Function({
      required String id,
      required String title,
      Value<String> description,
      required DateTime date,
      Value<int?> timeMinutes,
      Value<bool> isCompleted,
      required String priority,
      Value<String> category,
      Value<bool> reminderEnabled,
      Value<DateTime?> reminderTime,
      required String repeatType,
      Value<DateTime?> completedAt,
      Value<String?> seedKind,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TaskRecordsTableUpdateCompanionBuilder =
    TaskRecordsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<DateTime> date,
      Value<int?> timeMinutes,
      Value<bool> isCompleted,
      Value<String> priority,
      Value<String> category,
      Value<bool> reminderEnabled,
      Value<DateTime?> reminderTime,
      Value<String> repeatType,
      Value<DateTime?> completedAt,
      Value<String?> seedKind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TaskRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatType => $composableBuilder(
    column: $table.repeatType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKind => $composableBuilder(
    column: $table.seedKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatType => $composableBuilder(
    column: $table.repeatType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKind => $composableBuilder(
    column: $table.seedKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatType => $composableBuilder(
    column: $table.repeatType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seedKind =>
      $composableBuilder(column: $table.seedKind, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskRecordsTable,
          TaskRecord,
          $$TaskRecordsTableFilterComposer,
          $$TaskRecordsTableOrderingComposer,
          $$TaskRecordsTableAnnotationComposer,
          $$TaskRecordsTableCreateCompanionBuilder,
          $$TaskRecordsTableUpdateCompanionBuilder,
          (
            TaskRecord,
            BaseReferences<_$AppDatabase, $TaskRecordsTable, TaskRecord>,
          ),
          TaskRecord,
          PrefetchHooks Function()
        > {
  $$TaskRecordsTableTableManager(_$AppDatabase db, $TaskRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> timeMinutes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<DateTime?> reminderTime = const Value.absent(),
                Value<String> repeatType = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> seedKind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion(
                id: id,
                title: title,
                description: description,
                date: date,
                timeMinutes: timeMinutes,
                isCompleted: isCompleted,
                priority: priority,
                category: category,
                reminderEnabled: reminderEnabled,
                reminderTime: reminderTime,
                repeatType: repeatType,
                completedAt: completedAt,
                seedKind: seedKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> description = const Value.absent(),
                required DateTime date,
                Value<int?> timeMinutes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                required String priority,
                Value<String> category = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<DateTime?> reminderTime = const Value.absent(),
                required String repeatType,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> seedKind = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion.insert(
                id: id,
                title: title,
                description: description,
                date: date,
                timeMinutes: timeMinutes,
                isCompleted: isCompleted,
                priority: priority,
                category: category,
                reminderEnabled: reminderEnabled,
                reminderTime: reminderTime,
                repeatType: repeatType,
                completedAt: completedAt,
                seedKind: seedKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskRecordsTable,
      TaskRecord,
      $$TaskRecordsTableFilterComposer,
      $$TaskRecordsTableOrderingComposer,
      $$TaskRecordsTableAnnotationComposer,
      $$TaskRecordsTableCreateCompanionBuilder,
      $$TaskRecordsTableUpdateCompanionBuilder,
      (
        TaskRecord,
        BaseReferences<_$AppDatabase, $TaskRecordsTable, TaskRecord>,
      ),
      TaskRecord,
      PrefetchHooks Function()
    >;
typedef $$HabitRecordsTableCreateCompanionBuilder =
    HabitRecordsCompanion Function({
      required String id,
      required String name,
      Value<String> category,
      Value<int> targetPerDay,
      Value<bool> reminderEnabled,
      Value<int?> reminderMinutes,
      Value<String?> seedKind,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HabitRecordsTableUpdateCompanionBuilder =
    HabitRecordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> targetPerDay,
      Value<bool> reminderEnabled,
      Value<int?> reminderMinutes,
      Value<String?> seedKind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HabitRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitRecordsTable, HabitRecord> {
  $$HabitRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $HabitCheckInRecordsTable,
    List<HabitCheckInRecord>
  >
  _habitCheckInRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.habitCheckInRecords,
        aliasName: $_aliasNameGenerator(
          db.habitRecords.id,
          db.habitCheckInRecords.habitId,
        ),
      );

  $$HabitCheckInRecordsTableProcessedTableManager get habitCheckInRecordsRefs {
    final manager = $$HabitCheckInRecordsTableTableManager(
      $_db,
      $_db.habitCheckInRecords,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitCheckInRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPerDay => $composableBuilder(
    column: $table.targetPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKind => $composableBuilder(
    column: $table.seedKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitCheckInRecordsRefs(
    Expression<bool> Function($$HabitCheckInRecordsTableFilterComposer f) f,
  ) {
    final $$HabitCheckInRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCheckInRecords,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCheckInRecordsTableFilterComposer(
            $db: $db,
            $table: $db.habitCheckInRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPerDay => $composableBuilder(
    column: $table.targetPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKind => $composableBuilder(
    column: $table.seedKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get targetPerDay => $composableBuilder(
    column: $table.targetPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seedKind =>
      $composableBuilder(column: $table.seedKind, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> habitCheckInRecordsRefs<T extends Object>(
    Expression<T> Function($$HabitCheckInRecordsTableAnnotationComposer a) f,
  ) {
    final $$HabitCheckInRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.habitCheckInRecords,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HabitCheckInRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.habitCheckInRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HabitRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitRecordsTable,
          HabitRecord,
          $$HabitRecordsTableFilterComposer,
          $$HabitRecordsTableOrderingComposer,
          $$HabitRecordsTableAnnotationComposer,
          $$HabitRecordsTableCreateCompanionBuilder,
          $$HabitRecordsTableUpdateCompanionBuilder,
          (HabitRecord, $$HabitRecordsTableReferences),
          HabitRecord,
          PrefetchHooks Function({bool habitCheckInRecordsRefs})
        > {
  $$HabitRecordsTableTableManager(_$AppDatabase db, $HabitRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> targetPerDay = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String?> seedKind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitRecordsCompanion(
                id: id,
                name: name,
                category: category,
                targetPerDay: targetPerDay,
                reminderEnabled: reminderEnabled,
                reminderMinutes: reminderMinutes,
                seedKind: seedKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> category = const Value.absent(),
                Value<int> targetPerDay = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String?> seedKind = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitRecordsCompanion.insert(
                id: id,
                name: name,
                category: category,
                targetPerDay: targetPerDay,
                reminderEnabled: reminderEnabled,
                reminderMinutes: reminderMinutes,
                seedKind: seedKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitCheckInRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitCheckInRecordsRefs) db.habitCheckInRecords,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitCheckInRecordsRefs)
                    await $_getPrefetchedData<
                      HabitRecord,
                      $HabitRecordsTable,
                      HabitCheckInRecord
                    >(
                      currentTable: table,
                      referencedTable: $$HabitRecordsTableReferences
                          ._habitCheckInRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HabitRecordsTableReferences(
                            db,
                            table,
                            p0,
                          ).habitCheckInRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitRecordsTable,
      HabitRecord,
      $$HabitRecordsTableFilterComposer,
      $$HabitRecordsTableOrderingComposer,
      $$HabitRecordsTableAnnotationComposer,
      $$HabitRecordsTableCreateCompanionBuilder,
      $$HabitRecordsTableUpdateCompanionBuilder,
      (HabitRecord, $$HabitRecordsTableReferences),
      HabitRecord,
      PrefetchHooks Function({bool habitCheckInRecordsRefs})
    >;
typedef $$HabitCheckInRecordsTableCreateCompanionBuilder =
    HabitCheckInRecordsCompanion Function({
      required String habitId,
      required DateTime date,
      Value<int> count,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HabitCheckInRecordsTableUpdateCompanionBuilder =
    HabitCheckInRecordsCompanion Function({
      Value<String> habitId,
      Value<DateTime> date,
      Value<int> count,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HabitCheckInRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HabitCheckInRecordsTable,
          HabitCheckInRecord
        > {
  $$HabitCheckInRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitRecordsTable _habitIdTable(_$AppDatabase db) =>
      db.habitRecords.createAlias(
        $_aliasNameGenerator(
          db.habitCheckInRecords.habitId,
          db.habitRecords.id,
        ),
      );

  $$HabitRecordsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitRecordsTableTableManager(
      $_db,
      $_db.habitRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitCheckInRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCheckInRecordsTable> {
  $$HabitCheckInRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitRecordsTableFilterComposer get habitId {
    final $$HabitRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitRecordsTableFilterComposer(
            $db: $db,
            $table: $db.habitRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCheckInRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCheckInRecordsTable> {
  $$HabitCheckInRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitRecordsTableOrderingComposer get habitId {
    final $$HabitRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.habitRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCheckInRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCheckInRecordsTable> {
  $$HabitCheckInRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HabitRecordsTableAnnotationComposer get habitId {
    final $$HabitRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCheckInRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitCheckInRecordsTable,
          HabitCheckInRecord,
          $$HabitCheckInRecordsTableFilterComposer,
          $$HabitCheckInRecordsTableOrderingComposer,
          $$HabitCheckInRecordsTableAnnotationComposer,
          $$HabitCheckInRecordsTableCreateCompanionBuilder,
          $$HabitCheckInRecordsTableUpdateCompanionBuilder,
          (HabitCheckInRecord, $$HabitCheckInRecordsTableReferences),
          HabitCheckInRecord,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitCheckInRecordsTableTableManager(
    _$AppDatabase db,
    $HabitCheckInRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCheckInRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCheckInRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HabitCheckInRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> habitId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitCheckInRecordsCompanion(
                habitId: habitId,
                date: date,
                count: count,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required DateTime date,
                Value<int> count = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitCheckInRecordsCompanion.insert(
                habitId: habitId,
                date: date,
                count: count,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitCheckInRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable:
                                    $$HabitCheckInRecordsTableReferences
                                        ._habitIdTable(db),
                                referencedColumn:
                                    $$HabitCheckInRecordsTableReferences
                                        ._habitIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitCheckInRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitCheckInRecordsTable,
      HabitCheckInRecord,
      $$HabitCheckInRecordsTableFilterComposer,
      $$HabitCheckInRecordsTableOrderingComposer,
      $$HabitCheckInRecordsTableAnnotationComposer,
      $$HabitCheckInRecordsTableCreateCompanionBuilder,
      $$HabitCheckInRecordsTableUpdateCompanionBuilder,
      (HabitCheckInRecord, $$HabitCheckInRecordsTableReferences),
      HabitCheckInRecord,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$NoteRecordsTableCreateCompanionBuilder =
    NoteRecordsCompanion Function({
      required String id,
      required String title,
      Value<String> content,
      Value<String> category,
      Value<String> tagsJson,
      Value<bool> isPinned,
      Value<bool> isFavorite,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$NoteRecordsTableUpdateCompanionBuilder =
    NoteRecordsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<String> category,
      Value<String> tagsJson,
      Value<bool> isPinned,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NoteRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteRecordsTable> {
  $$NoteRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteRecordsTable> {
  $$NoteRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteRecordsTable> {
  $$NoteRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NoteRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteRecordsTable,
          NoteRecord,
          $$NoteRecordsTableFilterComposer,
          $$NoteRecordsTableOrderingComposer,
          $$NoteRecordsTableAnnotationComposer,
          $$NoteRecordsTableCreateCompanionBuilder,
          $$NoteRecordsTableUpdateCompanionBuilder,
          (
            NoteRecord,
            BaseReferences<_$AppDatabase, $NoteRecordsTable, NoteRecord>,
          ),
          NoteRecord,
          PrefetchHooks Function()
        > {
  $$NoteRecordsTableTableManager(_$AppDatabase db, $NoteRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteRecordsCompanion(
                id: id,
                title: title,
                content: content,
                category: category,
                tagsJson: tagsJson,
                isPinned: isPinned,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> content = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NoteRecordsCompanion.insert(
                id: id,
                title: title,
                content: content,
                category: category,
                tagsJson: tagsJson,
                isPinned: isPinned,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteRecordsTable,
      NoteRecord,
      $$NoteRecordsTableFilterComposer,
      $$NoteRecordsTableOrderingComposer,
      $$NoteRecordsTableAnnotationComposer,
      $$NoteRecordsTableCreateCompanionBuilder,
      $$NoteRecordsTableUpdateCompanionBuilder,
      (
        NoteRecord,
        BaseReferences<_$AppDatabase, $NoteRecordsTable, NoteRecord>,
      ),
      NoteRecord,
      PrefetchHooks Function()
    >;
typedef $$SettingsRecordsTableCreateCompanionBuilder =
    SettingsRecordsCompanion Function({
      Value<int> id,
      required String userName,
      required String language,
      required String themeMode,
      required String city,
      required String calculationMethod,
      required String madhhab,
      required bool useGeolocation,
      required bool prayerNotificationsEnabled,
      required bool soundEnabled,
      required bool vibrationEnabled,
      required bool adhanEnabled,
      Value<bool> manualPrayerOffsetsEnabled,
      Value<int> fajrOffsetMinutes,
      Value<int> sunriseOffsetMinutes,
      Value<int> dhuhrOffsetMinutes,
      Value<int> asrOffsetMinutes,
      Value<int> maghribOffsetMinutes,
      Value<int> ishaOffsetMinutes,
      required String aiMode,
      Value<bool> voiceInputEnabled,
      Value<bool> voiceReplyEnabled,
      Value<bool> autoSpeakAiReply,
      Value<double> voiceRate,
      Value<double> voicePitch,
      required bool activeMentorEnabled,
      required String activeMentorMode,
      required int maxFollowUpsPerItem,
      required int quietHoursStartMinutes,
      required int quietHoursEndMinutes,
      required bool notificationsEnabled,
      required bool isOnboardingComplete,
      required DateTime updatedAt,
    });
typedef $$SettingsRecordsTableUpdateCompanionBuilder =
    SettingsRecordsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> language,
      Value<String> themeMode,
      Value<String> city,
      Value<String> calculationMethod,
      Value<String> madhhab,
      Value<bool> useGeolocation,
      Value<bool> prayerNotificationsEnabled,
      Value<bool> soundEnabled,
      Value<bool> vibrationEnabled,
      Value<bool> adhanEnabled,
      Value<bool> manualPrayerOffsetsEnabled,
      Value<int> fajrOffsetMinutes,
      Value<int> sunriseOffsetMinutes,
      Value<int> dhuhrOffsetMinutes,
      Value<int> asrOffsetMinutes,
      Value<int> maghribOffsetMinutes,
      Value<int> ishaOffsetMinutes,
      Value<String> aiMode,
      Value<bool> voiceInputEnabled,
      Value<bool> voiceReplyEnabled,
      Value<bool> autoSpeakAiReply,
      Value<double> voiceRate,
      Value<double> voicePitch,
      Value<bool> activeMentorEnabled,
      Value<String> activeMentorMode,
      Value<int> maxFollowUpsPerItem,
      Value<int> quietHoursStartMinutes,
      Value<int> quietHoursEndMinutes,
      Value<bool> notificationsEnabled,
      Value<bool> isOnboardingComplete,
      Value<DateTime> updatedAt,
    });

class $$SettingsRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsRecordsTable> {
  $$SettingsRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get madhhab => $composableBuilder(
    column: $table.madhhab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useGeolocation => $composableBuilder(
    column: $table.useGeolocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get prayerNotificationsEnabled => $composableBuilder(
    column: $table.prayerNotificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adhanEnabled => $composableBuilder(
    column: $table.adhanEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get manualPrayerOffsetsEnabled => $composableBuilder(
    column: $table.manualPrayerOffsetsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fajrOffsetMinutes => $composableBuilder(
    column: $table.fajrOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sunriseOffsetMinutes => $composableBuilder(
    column: $table.sunriseOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dhuhrOffsetMinutes => $composableBuilder(
    column: $table.dhuhrOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get asrOffsetMinutes => $composableBuilder(
    column: $table.asrOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maghribOffsetMinutes => $composableBuilder(
    column: $table.maghribOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ishaOffsetMinutes => $composableBuilder(
    column: $table.ishaOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiMode => $composableBuilder(
    column: $table.aiMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get voiceInputEnabled => $composableBuilder(
    column: $table.voiceInputEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get voiceReplyEnabled => $composableBuilder(
    column: $table.voiceReplyEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSpeakAiReply => $composableBuilder(
    column: $table.autoSpeakAiReply,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get voiceRate => $composableBuilder(
    column: $table.voiceRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get voicePitch => $composableBuilder(
    column: $table.voicePitch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activeMentorEnabled => $composableBuilder(
    column: $table.activeMentorEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeMentorMode => $composableBuilder(
    column: $table.activeMentorMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxFollowUpsPerItem => $composableBuilder(
    column: $table.maxFollowUpsPerItem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnboardingComplete => $composableBuilder(
    column: $table.isOnboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsRecordsTable> {
  $$SettingsRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get madhhab => $composableBuilder(
    column: $table.madhhab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useGeolocation => $composableBuilder(
    column: $table.useGeolocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get prayerNotificationsEnabled => $composableBuilder(
    column: $table.prayerNotificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adhanEnabled => $composableBuilder(
    column: $table.adhanEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get manualPrayerOffsetsEnabled => $composableBuilder(
    column: $table.manualPrayerOffsetsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fajrOffsetMinutes => $composableBuilder(
    column: $table.fajrOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sunriseOffsetMinutes => $composableBuilder(
    column: $table.sunriseOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dhuhrOffsetMinutes => $composableBuilder(
    column: $table.dhuhrOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get asrOffsetMinutes => $composableBuilder(
    column: $table.asrOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maghribOffsetMinutes => $composableBuilder(
    column: $table.maghribOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ishaOffsetMinutes => $composableBuilder(
    column: $table.ishaOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiMode => $composableBuilder(
    column: $table.aiMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get voiceInputEnabled => $composableBuilder(
    column: $table.voiceInputEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get voiceReplyEnabled => $composableBuilder(
    column: $table.voiceReplyEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSpeakAiReply => $composableBuilder(
    column: $table.autoSpeakAiReply,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voiceRate => $composableBuilder(
    column: $table.voiceRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voicePitch => $composableBuilder(
    column: $table.voicePitch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activeMentorEnabled => $composableBuilder(
    column: $table.activeMentorEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeMentorMode => $composableBuilder(
    column: $table.activeMentorMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxFollowUpsPerItem => $composableBuilder(
    column: $table.maxFollowUpsPerItem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnboardingComplete => $composableBuilder(
    column: $table.isOnboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsRecordsTable> {
  $$SettingsRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get madhhab =>
      $composableBuilder(column: $table.madhhab, builder: (column) => column);

  GeneratedColumn<bool> get useGeolocation => $composableBuilder(
    column: $table.useGeolocation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get prayerNotificationsEnabled => $composableBuilder(
    column: $table.prayerNotificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adhanEnabled => $composableBuilder(
    column: $table.adhanEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get manualPrayerOffsetsEnabled => $composableBuilder(
    column: $table.manualPrayerOffsetsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fajrOffsetMinutes => $composableBuilder(
    column: $table.fajrOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sunriseOffsetMinutes => $composableBuilder(
    column: $table.sunriseOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dhuhrOffsetMinutes => $composableBuilder(
    column: $table.dhuhrOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get asrOffsetMinutes => $composableBuilder(
    column: $table.asrOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maghribOffsetMinutes => $composableBuilder(
    column: $table.maghribOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ishaOffsetMinutes => $composableBuilder(
    column: $table.ishaOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiMode =>
      $composableBuilder(column: $table.aiMode, builder: (column) => column);

  GeneratedColumn<bool> get voiceInputEnabled => $composableBuilder(
    column: $table.voiceInputEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get voiceReplyEnabled => $composableBuilder(
    column: $table.voiceReplyEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoSpeakAiReply => $composableBuilder(
    column: $table.autoSpeakAiReply,
    builder: (column) => column,
  );

  GeneratedColumn<double> get voiceRate =>
      $composableBuilder(column: $table.voiceRate, builder: (column) => column);

  GeneratedColumn<double> get voicePitch => $composableBuilder(
    column: $table.voicePitch,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activeMentorEnabled => $composableBuilder(
    column: $table.activeMentorEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeMentorMode => $composableBuilder(
    column: $table.activeMentorMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxFollowUpsPerItem => $composableBuilder(
    column: $table.maxFollowUpsPerItem,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnboardingComplete => $composableBuilder(
    column: $table.isOnboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsRecordsTable,
          SettingsRecord,
          $$SettingsRecordsTableFilterComposer,
          $$SettingsRecordsTableOrderingComposer,
          $$SettingsRecordsTableAnnotationComposer,
          $$SettingsRecordsTableCreateCompanionBuilder,
          $$SettingsRecordsTableUpdateCompanionBuilder,
          (
            SettingsRecord,
            BaseReferences<
              _$AppDatabase,
              $SettingsRecordsTable,
              SettingsRecord
            >,
          ),
          SettingsRecord,
          PrefetchHooks Function()
        > {
  $$SettingsRecordsTableTableManager(
    _$AppDatabase db,
    $SettingsRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> calculationMethod = const Value.absent(),
                Value<String> madhhab = const Value.absent(),
                Value<bool> useGeolocation = const Value.absent(),
                Value<bool> prayerNotificationsEnabled = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<bool> adhanEnabled = const Value.absent(),
                Value<bool> manualPrayerOffsetsEnabled = const Value.absent(),
                Value<int> fajrOffsetMinutes = const Value.absent(),
                Value<int> sunriseOffsetMinutes = const Value.absent(),
                Value<int> dhuhrOffsetMinutes = const Value.absent(),
                Value<int> asrOffsetMinutes = const Value.absent(),
                Value<int> maghribOffsetMinutes = const Value.absent(),
                Value<int> ishaOffsetMinutes = const Value.absent(),
                Value<String> aiMode = const Value.absent(),
                Value<bool> voiceInputEnabled = const Value.absent(),
                Value<bool> voiceReplyEnabled = const Value.absent(),
                Value<bool> autoSpeakAiReply = const Value.absent(),
                Value<double> voiceRate = const Value.absent(),
                Value<double> voicePitch = const Value.absent(),
                Value<bool> activeMentorEnabled = const Value.absent(),
                Value<String> activeMentorMode = const Value.absent(),
                Value<int> maxFollowUpsPerItem = const Value.absent(),
                Value<int> quietHoursStartMinutes = const Value.absent(),
                Value<int> quietHoursEndMinutes = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> isOnboardingComplete = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SettingsRecordsCompanion(
                id: id,
                userName: userName,
                language: language,
                themeMode: themeMode,
                city: city,
                calculationMethod: calculationMethod,
                madhhab: madhhab,
                useGeolocation: useGeolocation,
                prayerNotificationsEnabled: prayerNotificationsEnabled,
                soundEnabled: soundEnabled,
                vibrationEnabled: vibrationEnabled,
                adhanEnabled: adhanEnabled,
                manualPrayerOffsetsEnabled: manualPrayerOffsetsEnabled,
                fajrOffsetMinutes: fajrOffsetMinutes,
                sunriseOffsetMinutes: sunriseOffsetMinutes,
                dhuhrOffsetMinutes: dhuhrOffsetMinutes,
                asrOffsetMinutes: asrOffsetMinutes,
                maghribOffsetMinutes: maghribOffsetMinutes,
                ishaOffsetMinutes: ishaOffsetMinutes,
                aiMode: aiMode,
                voiceInputEnabled: voiceInputEnabled,
                voiceReplyEnabled: voiceReplyEnabled,
                autoSpeakAiReply: autoSpeakAiReply,
                voiceRate: voiceRate,
                voicePitch: voicePitch,
                activeMentorEnabled: activeMentorEnabled,
                activeMentorMode: activeMentorMode,
                maxFollowUpsPerItem: maxFollowUpsPerItem,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                notificationsEnabled: notificationsEnabled,
                isOnboardingComplete: isOnboardingComplete,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userName,
                required String language,
                required String themeMode,
                required String city,
                required String calculationMethod,
                required String madhhab,
                required bool useGeolocation,
                required bool prayerNotificationsEnabled,
                required bool soundEnabled,
                required bool vibrationEnabled,
                required bool adhanEnabled,
                Value<bool> manualPrayerOffsetsEnabled = const Value.absent(),
                Value<int> fajrOffsetMinutes = const Value.absent(),
                Value<int> sunriseOffsetMinutes = const Value.absent(),
                Value<int> dhuhrOffsetMinutes = const Value.absent(),
                Value<int> asrOffsetMinutes = const Value.absent(),
                Value<int> maghribOffsetMinutes = const Value.absent(),
                Value<int> ishaOffsetMinutes = const Value.absent(),
                required String aiMode,
                Value<bool> voiceInputEnabled = const Value.absent(),
                Value<bool> voiceReplyEnabled = const Value.absent(),
                Value<bool> autoSpeakAiReply = const Value.absent(),
                Value<double> voiceRate = const Value.absent(),
                Value<double> voicePitch = const Value.absent(),
                required bool activeMentorEnabled,
                required String activeMentorMode,
                required int maxFollowUpsPerItem,
                required int quietHoursStartMinutes,
                required int quietHoursEndMinutes,
                required bool notificationsEnabled,
                required bool isOnboardingComplete,
                required DateTime updatedAt,
              }) => SettingsRecordsCompanion.insert(
                id: id,
                userName: userName,
                language: language,
                themeMode: themeMode,
                city: city,
                calculationMethod: calculationMethod,
                madhhab: madhhab,
                useGeolocation: useGeolocation,
                prayerNotificationsEnabled: prayerNotificationsEnabled,
                soundEnabled: soundEnabled,
                vibrationEnabled: vibrationEnabled,
                adhanEnabled: adhanEnabled,
                manualPrayerOffsetsEnabled: manualPrayerOffsetsEnabled,
                fajrOffsetMinutes: fajrOffsetMinutes,
                sunriseOffsetMinutes: sunriseOffsetMinutes,
                dhuhrOffsetMinutes: dhuhrOffsetMinutes,
                asrOffsetMinutes: asrOffsetMinutes,
                maghribOffsetMinutes: maghribOffsetMinutes,
                ishaOffsetMinutes: ishaOffsetMinutes,
                aiMode: aiMode,
                voiceInputEnabled: voiceInputEnabled,
                voiceReplyEnabled: voiceReplyEnabled,
                autoSpeakAiReply: autoSpeakAiReply,
                voiceRate: voiceRate,
                voicePitch: voicePitch,
                activeMentorEnabled: activeMentorEnabled,
                activeMentorMode: activeMentorMode,
                maxFollowUpsPerItem: maxFollowUpsPerItem,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                notificationsEnabled: notificationsEnabled,
                isOnboardingComplete: isOnboardingComplete,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsRecordsTable,
      SettingsRecord,
      $$SettingsRecordsTableFilterComposer,
      $$SettingsRecordsTableOrderingComposer,
      $$SettingsRecordsTableAnnotationComposer,
      $$SettingsRecordsTableCreateCompanionBuilder,
      $$SettingsRecordsTableUpdateCompanionBuilder,
      (
        SettingsRecord,
        BaseReferences<_$AppDatabase, $SettingsRecordsTable, SettingsRecord>,
      ),
      SettingsRecord,
      PrefetchHooks Function()
    >;
typedef $$AppActivityRecordsTableCreateCompanionBuilder =
    AppActivityRecordsCompanion Function({
      required DateTime date,
      Value<bool> appOpened,
      Value<int> tasksCompleted,
      Value<int> habitsCompleted,
      Value<int> prayersCompleted,
      Value<bool> perfectDay,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppActivityRecordsTableUpdateCompanionBuilder =
    AppActivityRecordsCompanion Function({
      Value<DateTime> date,
      Value<bool> appOpened,
      Value<int> tasksCompleted,
      Value<int> habitsCompleted,
      Value<int> prayersCompleted,
      Value<bool> perfectDay,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppActivityRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AppActivityRecordsTable> {
  $$AppActivityRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appOpened => $composableBuilder(
    column: $table.appOpened,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tasksCompleted => $composableBuilder(
    column: $table.tasksCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get habitsCompleted => $composableBuilder(
    column: $table.habitsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prayersCompleted => $composableBuilder(
    column: $table.prayersCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get perfectDay => $composableBuilder(
    column: $table.perfectDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppActivityRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppActivityRecordsTable> {
  $$AppActivityRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appOpened => $composableBuilder(
    column: $table.appOpened,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tasksCompleted => $composableBuilder(
    column: $table.tasksCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get habitsCompleted => $composableBuilder(
    column: $table.habitsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prayersCompleted => $composableBuilder(
    column: $table.prayersCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get perfectDay => $composableBuilder(
    column: $table.perfectDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppActivityRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppActivityRecordsTable> {
  $$AppActivityRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get appOpened =>
      $composableBuilder(column: $table.appOpened, builder: (column) => column);

  GeneratedColumn<int> get tasksCompleted => $composableBuilder(
    column: $table.tasksCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get habitsCompleted => $composableBuilder(
    column: $table.habitsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prayersCompleted => $composableBuilder(
    column: $table.prayersCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get perfectDay => $composableBuilder(
    column: $table.perfectDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppActivityRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppActivityRecordsTable,
          AppActivityRecord,
          $$AppActivityRecordsTableFilterComposer,
          $$AppActivityRecordsTableOrderingComposer,
          $$AppActivityRecordsTableAnnotationComposer,
          $$AppActivityRecordsTableCreateCompanionBuilder,
          $$AppActivityRecordsTableUpdateCompanionBuilder,
          (
            AppActivityRecord,
            BaseReferences<
              _$AppDatabase,
              $AppActivityRecordsTable,
              AppActivityRecord
            >,
          ),
          AppActivityRecord,
          PrefetchHooks Function()
        > {
  $$AppActivityRecordsTableTableManager(
    _$AppDatabase db,
    $AppActivityRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppActivityRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppActivityRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppActivityRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<bool> appOpened = const Value.absent(),
                Value<int> tasksCompleted = const Value.absent(),
                Value<int> habitsCompleted = const Value.absent(),
                Value<int> prayersCompleted = const Value.absent(),
                Value<bool> perfectDay = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppActivityRecordsCompanion(
                date: date,
                appOpened: appOpened,
                tasksCompleted: tasksCompleted,
                habitsCompleted: habitsCompleted,
                prayersCompleted: prayersCompleted,
                perfectDay: perfectDay,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                Value<bool> appOpened = const Value.absent(),
                Value<int> tasksCompleted = const Value.absent(),
                Value<int> habitsCompleted = const Value.absent(),
                Value<int> prayersCompleted = const Value.absent(),
                Value<bool> perfectDay = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppActivityRecordsCompanion.insert(
                date: date,
                appOpened: appOpened,
                tasksCompleted: tasksCompleted,
                habitsCompleted: habitsCompleted,
                prayersCompleted: prayersCompleted,
                perfectDay: perfectDay,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppActivityRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppActivityRecordsTable,
      AppActivityRecord,
      $$AppActivityRecordsTableFilterComposer,
      $$AppActivityRecordsTableOrderingComposer,
      $$AppActivityRecordsTableAnnotationComposer,
      $$AppActivityRecordsTableCreateCompanionBuilder,
      $$AppActivityRecordsTableUpdateCompanionBuilder,
      (
        AppActivityRecord,
        BaseReferences<
          _$AppDatabase,
          $AppActivityRecordsTable,
          AppActivityRecord
        >,
      ),
      AppActivityRecord,
      PrefetchHooks Function()
    >;
typedef $$SemanticIndexItemsTableCreateCompanionBuilder =
    SemanticIndexItemsCompanion Function({
      required String id,
      required String sourceType,
      required String sourceId,
      required String title,
      Value<String> content,
      required String embeddingJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SemanticIndexItemsTableUpdateCompanionBuilder =
    SemanticIndexItemsCompanion Function({
      Value<String> id,
      Value<String> sourceType,
      Value<String> sourceId,
      Value<String> title,
      Value<String> content,
      Value<String> embeddingJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SemanticIndexItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SemanticIndexItemsTable> {
  $$SemanticIndexItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embeddingJson => $composableBuilder(
    column: $table.embeddingJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SemanticIndexItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SemanticIndexItemsTable> {
  $$SemanticIndexItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embeddingJson => $composableBuilder(
    column: $table.embeddingJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SemanticIndexItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SemanticIndexItemsTable> {
  $$SemanticIndexItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get embeddingJson => $composableBuilder(
    column: $table.embeddingJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SemanticIndexItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SemanticIndexItemsTable,
          SemanticIndexItem,
          $$SemanticIndexItemsTableFilterComposer,
          $$SemanticIndexItemsTableOrderingComposer,
          $$SemanticIndexItemsTableAnnotationComposer,
          $$SemanticIndexItemsTableCreateCompanionBuilder,
          $$SemanticIndexItemsTableUpdateCompanionBuilder,
          (
            SemanticIndexItem,
            BaseReferences<
              _$AppDatabase,
              $SemanticIndexItemsTable,
              SemanticIndexItem
            >,
          ),
          SemanticIndexItem,
          PrefetchHooks Function()
        > {
  $$SemanticIndexItemsTableTableManager(
    _$AppDatabase db,
    $SemanticIndexItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SemanticIndexItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SemanticIndexItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SemanticIndexItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> embeddingJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SemanticIndexItemsCompanion(
                id: id,
                sourceType: sourceType,
                sourceId: sourceId,
                title: title,
                content: content,
                embeddingJson: embeddingJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceType,
                required String sourceId,
                required String title,
                Value<String> content = const Value.absent(),
                required String embeddingJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SemanticIndexItemsCompanion.insert(
                id: id,
                sourceType: sourceType,
                sourceId: sourceId,
                title: title,
                content: content,
                embeddingJson: embeddingJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SemanticIndexItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SemanticIndexItemsTable,
      SemanticIndexItem,
      $$SemanticIndexItemsTableFilterComposer,
      $$SemanticIndexItemsTableOrderingComposer,
      $$SemanticIndexItemsTableAnnotationComposer,
      $$SemanticIndexItemsTableCreateCompanionBuilder,
      $$SemanticIndexItemsTableUpdateCompanionBuilder,
      (
        SemanticIndexItem,
        BaseReferences<
          _$AppDatabase,
          $SemanticIndexItemsTable,
          SemanticIndexItem
        >,
      ),
      SemanticIndexItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db, _db.taskRecords);
  $$HabitRecordsTableTableManager get habitRecords =>
      $$HabitRecordsTableTableManager(_db, _db.habitRecords);
  $$HabitCheckInRecordsTableTableManager get habitCheckInRecords =>
      $$HabitCheckInRecordsTableTableManager(_db, _db.habitCheckInRecords);
  $$NoteRecordsTableTableManager get noteRecords =>
      $$NoteRecordsTableTableManager(_db, _db.noteRecords);
  $$SettingsRecordsTableTableManager get settingsRecords =>
      $$SettingsRecordsTableTableManager(_db, _db.settingsRecords);
  $$AppActivityRecordsTableTableManager get appActivityRecords =>
      $$AppActivityRecordsTableTableManager(_db, _db.appActivityRecords);
  $$SemanticIndexItemsTableTableManager get semanticIndexItems =>
      $$SemanticIndexItemsTableTableManager(_db, _db.semanticIndexItems);
}
