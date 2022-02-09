// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatAdapter extends TypeAdapter<Cat> {
  @override
  final int typeId = 1;

  @override
  Cat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cat(
      id: fields[0] as String,
      maxHappiness: fields[1] as int,
      maxFitness: fields[2] as int,
      imagePath: fields[3] as String?,
      name: fields[4] as String,
      level: fields[7] == null ? 1 : fields[7] as int,
      experience: fields[8] == null ? 0 : fields[8] as double,
      preferences: (fields[9] as Map).cast<String, double>(),
      todayExp: fields[10] == null ? 0 : fields[10] as double,
    )
      ..happiness = fields[5] as double
      ..fitness = fields[6] as double;
  }

  @override
  void write(BinaryWriter writer, Cat obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.maxHappiness)
      ..writeByte(2)
      ..write(obj.maxFitness)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.happiness)
      ..writeByte(6)
      ..write(obj.fitness)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.experience)
      ..writeByte(9)
      ..write(obj.preferences)
      ..writeByte(10)
      ..write(obj.todayExp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
