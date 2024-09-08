// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'gravity_rule.dart';

class GravityRuleMapper extends EnumMapper<GravityRule> {
  GravityRuleMapper._();

  static GravityRuleMapper? _instance;
  static GravityRuleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GravityRuleMapper._());
    }
    return _instance!;
  }

  static GravityRule fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  GravityRule decode(dynamic value) {
    switch (value) {
      case 'attractSameColor':
        return GravityRule.attractSameColor;
      case 'repelSameColor':
        return GravityRule.repelSameColor;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(GravityRule self) {
    switch (self) {
      case GravityRule.attractSameColor:
        return 'attractSameColor';
      case GravityRule.repelSameColor:
        return 'repelSameColor';
    }
  }
}

extension GravityRuleMapperExtension on GravityRule {
  String toValue() {
    GravityRuleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<GravityRule>(this) as String;
  }
}
