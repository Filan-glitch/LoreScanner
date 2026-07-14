// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card.dart';

class CardMapper extends ClassMapperBase<Card> {
  CardMapper._();

  static CardMapper? _instance;
  static CardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Card';

  static int _$id(Card v) => v.id;
  static const Field<Card, int> _f$id = Field('id', _$id);
  static String _$setCode(Card v) => v.setCode;
  static const Field<Card, String> _f$setCode = Field('setCode', _$setCode);
  static Map<String, String> _$images(Card v) => v.images;
  static const Field<Card, Map<String, String>> _f$images = Field(
    'images',
    _$images,
    hook: ImagesHook(),
  );
  static int _$number(Card v) => v.number;
  static const Field<Card, int> _f$number = Field('number', _$number);
  static String _$simpleName(Card v) => v.simpleName;
  static const Field<Card, String> _f$simpleName = Field(
    'simpleName',
    _$simpleName,
  );
  static String _$fullName(Card v) => v.fullName;
  static const Field<Card, String> _f$fullName = Field('fullName', _$fullName);
  static String _$rarity(Card v) => v.rarity;
  static const Field<Card, String> _f$rarity = Field('rarity', _$rarity);
  static String _$story(Card v) => v.story;
  static const Field<Card, String> _f$story = Field('story', _$story);
  static String _$type(Card v) => v.type;
  static const Field<Card, String> _f$type = Field('type', _$type);
  static bool _$inkwell(Card v) => v.inkwell;
  static const Field<Card, bool> _f$inkwell = Field(
    'inkwell',
    _$inkwell,
    hook: InkwellHook(),
  );
  static int _$cost(Card v) => v.cost;
  static const Field<Card, int> _f$cost = Field('cost', _$cost);
  static Map<String, String> _$externalLinks(Card v) => v.externalLinks;
  static const Field<Card, Map<String, String>> _f$externalLinks = Field(
    'externalLinks',
    _$externalLinks,
    hook: ExternalLinksHook(),
  );
  static String? _$promoGrouping(Card v) => v.promoGrouping;
  static const Field<Card, String> _f$promoGrouping = Field(
    'promoGrouping',
    _$promoGrouping,
    opt: true,
  );
  static List<String> _$foilTypes(Card v) => v.foilTypes;
  static const Field<Card, List<String>> _f$foilTypes = Field(
    'foilTypes',
    _$foilTypes,
    opt: true,
    def: const [],
    hook: FoilHook(),
  );
  static String _$language(Card v) => v.language;
  static const Field<Card, String> _f$language = Field(
    'language',
    _$language,
    opt: true,
    def: 'de',
  );

  @override
  final MappableFields<Card> fields = const {
    #id: _f$id,
    #setCode: _f$setCode,
    #images: _f$images,
    #number: _f$number,
    #simpleName: _f$simpleName,
    #fullName: _f$fullName,
    #rarity: _f$rarity,
    #story: _f$story,
    #type: _f$type,
    #inkwell: _f$inkwell,
    #cost: _f$cost,
    #externalLinks: _f$externalLinks,
    #promoGrouping: _f$promoGrouping,
    #foilTypes: _f$foilTypes,
    #language: _f$language,
  };

  static Card _instantiate(DecodingData data) {
    return Card(
      id: data.dec(_f$id),
      setCode: data.dec(_f$setCode),
      images: data.dec(_f$images),
      number: data.dec(_f$number),
      simpleName: data.dec(_f$simpleName),
      fullName: data.dec(_f$fullName),
      rarity: data.dec(_f$rarity),
      story: data.dec(_f$story),
      type: data.dec(_f$type),
      inkwell: data.dec(_f$inkwell),
      cost: data.dec(_f$cost),
      externalLinks: data.dec(_f$externalLinks),
      promoGrouping: data.dec(_f$promoGrouping),
      foilTypes: data.dec(_f$foilTypes),
      language: data.dec(_f$language),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Card fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Card>(map);
  }

  static Card fromJson(String json) {
    return ensureInitialized().decodeJson<Card>(json);
  }
}

mixin CardMappable {
  String toJson() {
    return CardMapper.ensureInitialized().encodeJson<Card>(this as Card);
  }

  Map<String, dynamic> toMap() {
    return CardMapper.ensureInitialized().encodeMap<Card>(this as Card);
  }

  CardCopyWith<Card, Card, Card> get copyWith =>
      _CardCopyWithImpl<Card, Card>(this as Card, $identity, $identity);
  @override
  String toString() {
    return CardMapper.ensureInitialized().stringifyValue(this as Card);
  }

  @override
  bool operator ==(Object other) {
    return CardMapper.ensureInitialized().equalsValue(this as Card, other);
  }

  @override
  int get hashCode {
    return CardMapper.ensureInitialized().hashValue(this as Card);
  }
}

extension CardValueCopy<$R, $Out> on ObjectCopyWith<$R, Card, $Out> {
  CardCopyWith<$R, Card, $Out> get $asCard =>
      $base.as((v, t, t2) => _CardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CardCopyWith<$R, $In extends Card, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get images;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get externalLinks;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get foilTypes;
  $R call({
    int? id,
    String? setCode,
    Map<String, String>? images,
    int? number,
    String? simpleName,
    String? fullName,
    String? rarity,
    String? story,
    String? type,
    bool? inkwell,
    int? cost,
    Map<String, String>? externalLinks,
    String? promoGrouping,
    List<String>? foilTypes,
    String? language,
  });
  CardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CardCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Card, $Out>
    implements CardCopyWith<$R, Card, $Out> {
  _CardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Card> $mapper = CardMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get images => MapCopyWith(
    $value.images,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(images: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get externalLinks => MapCopyWith(
    $value.externalLinks,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(externalLinks: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get foilTypes =>
      ListCopyWith(
        $value.foilTypes,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(foilTypes: v),
      );
  @override
  $R call({
    int? id,
    String? setCode,
    Map<String, String>? images,
    int? number,
    String? simpleName,
    String? fullName,
    String? rarity,
    String? story,
    String? type,
    bool? inkwell,
    int? cost,
    Map<String, String>? externalLinks,
    Object? promoGrouping = $none,
    List<String>? foilTypes,
    String? language,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (setCode != null) #setCode: setCode,
      if (images != null) #images: images,
      if (number != null) #number: number,
      if (simpleName != null) #simpleName: simpleName,
      if (fullName != null) #fullName: fullName,
      if (rarity != null) #rarity: rarity,
      if (story != null) #story: story,
      if (type != null) #type: type,
      if (inkwell != null) #inkwell: inkwell,
      if (cost != null) #cost: cost,
      if (externalLinks != null) #externalLinks: externalLinks,
      if (promoGrouping != $none) #promoGrouping: promoGrouping,
      if (foilTypes != null) #foilTypes: foilTypes,
      if (language != null) #language: language,
    }),
  );
  @override
  Card $make(CopyWithData data) => Card(
    id: data.get(#id, or: $value.id),
    setCode: data.get(#setCode, or: $value.setCode),
    images: data.get(#images, or: $value.images),
    number: data.get(#number, or: $value.number),
    simpleName: data.get(#simpleName, or: $value.simpleName),
    fullName: data.get(#fullName, or: $value.fullName),
    rarity: data.get(#rarity, or: $value.rarity),
    story: data.get(#story, or: $value.story),
    type: data.get(#type, or: $value.type),
    inkwell: data.get(#inkwell, or: $value.inkwell),
    cost: data.get(#cost, or: $value.cost),
    externalLinks: data.get(#externalLinks, or: $value.externalLinks),
    promoGrouping: data.get(#promoGrouping, or: $value.promoGrouping),
    foilTypes: data.get(#foilTypes, or: $value.foilTypes),
    language: data.get(#language, or: $value.language),
  );

  @override
  CardCopyWith<$R2, Card, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

