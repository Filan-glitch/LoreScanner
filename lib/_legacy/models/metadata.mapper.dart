// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'metadata.dart';

class MetadataMapper extends ClassMapperBase<Metadata> {
  MetadataMapper._();

  static MetadataMapper? _instance;
  static MetadataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MetadataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Metadata';

  static String _$formatVersion(Metadata v) => v.formatVersion;
  static const Field<Metadata, String> _f$formatVersion = Field(
    'formatVersion',
    _$formatVersion,
  );
  static String _$generatedOn(Metadata v) => v.generatedOn;
  static const Field<Metadata, String> _f$generatedOn = Field(
    'generatedOn',
    _$generatedOn,
  );
  static String _$language(Metadata v) => v.language;
  static const Field<Metadata, String> _f$language = Field(
    'language',
    _$language,
  );

  @override
  final MappableFields<Metadata> fields = const {
    #formatVersion: _f$formatVersion,
    #generatedOn: _f$generatedOn,
    #language: _f$language,
  };

  static Metadata _instantiate(DecodingData data) {
    return Metadata(
      formatVersion: data.dec(_f$formatVersion),
      generatedOn: data.dec(_f$generatedOn),
      language: data.dec(_f$language),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Metadata fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Metadata>(map);
  }

  static Metadata fromJson(String json) {
    return ensureInitialized().decodeJson<Metadata>(json);
  }
}

mixin MetadataMappable {
  String toJson() {
    return MetadataMapper.ensureInitialized().encodeJson<Metadata>(
      this as Metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return MetadataMapper.ensureInitialized().encodeMap<Metadata>(
      this as Metadata,
    );
  }

  MetadataCopyWith<Metadata, Metadata, Metadata> get copyWith =>
      _MetadataCopyWithImpl<Metadata, Metadata>(
        this as Metadata,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MetadataMapper.ensureInitialized().stringifyValue(this as Metadata);
  }

  @override
  bool operator ==(Object other) {
    return MetadataMapper.ensureInitialized().equalsValue(
      this as Metadata,
      other,
    );
  }

  @override
  int get hashCode {
    return MetadataMapper.ensureInitialized().hashValue(this as Metadata);
  }
}

extension MetadataValueCopy<$R, $Out> on ObjectCopyWith<$R, Metadata, $Out> {
  MetadataCopyWith<$R, Metadata, $Out> get $asMetadata =>
      $base.as((v, t, t2) => _MetadataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MetadataCopyWith<$R, $In extends Metadata, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? formatVersion, String? generatedOn, String? language});
  MetadataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MetadataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Metadata, $Out>
    implements MetadataCopyWith<$R, Metadata, $Out> {
  _MetadataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Metadata> $mapper =
      MetadataMapper.ensureInitialized();
  @override
  $R call({String? formatVersion, String? generatedOn, String? language}) =>
      $apply(
        FieldCopyWithData({
          if (formatVersion != null) #formatVersion: formatVersion,
          if (generatedOn != null) #generatedOn: generatedOn,
          if (language != null) #language: language,
        }),
      );
  @override
  Metadata $make(CopyWithData data) => Metadata(
    formatVersion: data.get(#formatVersion, or: $value.formatVersion),
    generatedOn: data.get(#generatedOn, or: $value.generatedOn),
    language: data.get(#language, or: $value.language),
  );

  @override
  MetadataCopyWith<$R2, Metadata, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MetadataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

