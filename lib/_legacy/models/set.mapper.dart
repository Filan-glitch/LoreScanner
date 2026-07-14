// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'set.dart';

class SetMapper extends ClassMapperBase<Set> {
  SetMapper._();

  static SetMapper? _instance;
  static SetMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Set';

  static int _$number(Set v) => v.number;
  static const Field<Set, int> _f$number = Field('number', _$number);
  static String _$prereleaseDate(Set v) => v.prereleaseDate;
  static const Field<Set, String> _f$prereleaseDate = Field(
    'prereleaseDate',
    _$prereleaseDate,
  );
  static String _$releaseDate(Set v) => v.releaseDate;
  static const Field<Set, String> _f$releaseDate = Field(
    'releaseDate',
    _$releaseDate,
  );
  static bool _$hasAllCards(Set v) => v.hasAllCards;
  static const Field<Set, bool> _f$hasAllCards = Field(
    'hasAllCards',
    _$hasAllCards,
  );
  static String _$type(Set v) => v.type;
  static const Field<Set, String> _f$type = Field('type', _$type);
  static String _$name(Set v) => v.name;
  static const Field<Set, String> _f$name = Field('name', _$name);
  static String _$language(Set v) => v.language;
  static const Field<Set, String> _f$language = Field(
    'language',
    _$language,
    opt: true,
    def: 'de',
  );

  @override
  final MappableFields<Set> fields = const {
    #number: _f$number,
    #prereleaseDate: _f$prereleaseDate,
    #releaseDate: _f$releaseDate,
    #hasAllCards: _f$hasAllCards,
    #type: _f$type,
    #name: _f$name,
    #language: _f$language,
  };

  static Set _instantiate(DecodingData data) {
    return Set(
      number: data.dec(_f$number),
      prereleaseDate: data.dec(_f$prereleaseDate),
      releaseDate: data.dec(_f$releaseDate),
      hasAllCards: data.dec(_f$hasAllCards),
      type: data.dec(_f$type),
      name: data.dec(_f$name),
      language: data.dec(_f$language),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Set fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Set>(map);
  }

  static Set fromJson(String json) {
    return ensureInitialized().decodeJson<Set>(json);
  }
}

mixin SetMappable {
  String toJson() {
    return SetMapper.ensureInitialized().encodeJson<Set>(this as Set);
  }

  Map<String, dynamic> toMap() {
    return SetMapper.ensureInitialized().encodeMap<Set>(this as Set);
  }

  SetCopyWith<Set, Set, Set> get copyWith =>
      _SetCopyWithImpl<Set, Set>(this as Set, $identity, $identity);
  @override
  String toString() {
    return SetMapper.ensureInitialized().stringifyValue(this as Set);
  }

  @override
  bool operator ==(Object other) {
    return SetMapper.ensureInitialized().equalsValue(this as Set, other);
  }

  @override
  int get hashCode {
    return SetMapper.ensureInitialized().hashValue(this as Set);
  }
}

extension SetValueCopy<$R, $Out> on ObjectCopyWith<$R, Set, $Out> {
  SetCopyWith<$R, Set, $Out> get $asSet =>
      $base.as((v, t, t2) => _SetCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SetCopyWith<$R, $In extends Set, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? number,
    String? prereleaseDate,
    String? releaseDate,
    bool? hasAllCards,
    String? type,
    String? name,
    String? language,
  });
  SetCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SetCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Set, $Out>
    implements SetCopyWith<$R, Set, $Out> {
  _SetCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Set> $mapper = SetMapper.ensureInitialized();
  @override
  $R call({
    int? number,
    String? prereleaseDate,
    String? releaseDate,
    bool? hasAllCards,
    String? type,
    String? name,
    String? language,
  }) => $apply(
    FieldCopyWithData({
      if (number != null) #number: number,
      if (prereleaseDate != null) #prereleaseDate: prereleaseDate,
      if (releaseDate != null) #releaseDate: releaseDate,
      if (hasAllCards != null) #hasAllCards: hasAllCards,
      if (type != null) #type: type,
      if (name != null) #name: name,
      if (language != null) #language: language,
    }),
  );
  @override
  Set $make(CopyWithData data) => Set(
    number: data.get(#number, or: $value.number),
    prereleaseDate: data.get(#prereleaseDate, or: $value.prereleaseDate),
    releaseDate: data.get(#releaseDate, or: $value.releaseDate),
    hasAllCards: data.get(#hasAllCards, or: $value.hasAllCards),
    type: data.get(#type, or: $value.type),
    name: data.get(#name, or: $value.name),
    language: data.get(#language, or: $value.language),
  );

  @override
  SetCopyWith<$R2, Set, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SetCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

