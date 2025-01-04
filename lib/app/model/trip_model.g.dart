// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 0;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      startLocationName: fields[0] as String,
      startLatitude: fields[1] as double,
      startLongitude: fields[2] as double,
      endLocationName: fields[3] as String,
      endLatitude: fields[4] as double,
      endLongitude: fields[5] as double,
      distance: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.startLocationName)
      ..writeByte(1)
      ..write(obj.startLatitude)
      ..writeByte(2)
      ..write(obj.startLongitude)
      ..writeByte(3)
      ..write(obj.endLocationName)
      ..writeByte(4)
      ..write(obj.endLatitude)
      ..writeByte(5)
      ..write(obj.endLongitude)
      ..writeByte(6)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
