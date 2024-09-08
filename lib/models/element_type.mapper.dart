// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'element_type.dart';

class ElementTypeMapper extends EnumMapper<ElementType> {
  ElementTypeMapper._();

  static ElementTypeMapper? _instance;
  static ElementTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ElementTypeMapper._());
    }
    return _instance!;
  }

  static ElementType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ElementType decode(dynamic value) {
    switch (value) {
      case 'water':
        return ElementType.water;
      case 'fire':
        return ElementType.fire;
      case 'stone':
        return ElementType.stone;
      case 'air':
        return ElementType.air;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ElementType self) {
    switch (self) {
      case ElementType.water:
        return 'water';
      case ElementType.fire:
        return 'fire';
      case ElementType.stone:
        return 'stone';
      case ElementType.air:
        return 'air';
    }
  }
}

extension ElementTypeMapperExtension on ElementType {
  String toValue() {
    ElementTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ElementType>(this) as String;
  }
}
