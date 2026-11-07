// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepHistoryModelAdapter extends TypeAdapter<StepHistoryModel> {
  @override
  final int typeId = 1;

  @override
  StepHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepHistoryModel(
      date: fields[0] as String,
      steps: fields[1] as int,
      calories: fields[2] as double,
      distance: fields[3] as double,
      activeMinutes: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.steps)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.activeMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
