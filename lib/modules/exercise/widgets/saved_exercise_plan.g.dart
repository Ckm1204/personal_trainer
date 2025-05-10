// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_exercise_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedExercisePlanAdapter extends TypeAdapter<SavedExercisePlan> {
  @override
  final int typeId = 1;

  @override
  SavedExercisePlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedExercisePlan(
      exercises: (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
      savedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedExercisePlan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.exercises)
      ..writeByte(1)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedExercisePlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
