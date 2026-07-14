// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dtos.dart';

class MetadataDtoMapper extends ClassMapperBase<MetadataDto> {
  MetadataDtoMapper._();

  static MetadataDtoMapper? _instance;
  static MetadataDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MetadataDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MetadataDto';

  static String _$formatVersion(MetadataDto v) => v.formatVersion;
  static const Field<MetadataDto, String> _f$formatVersion = Field(
    'formatVersion',
    _$formatVersion,
  );
  static String _$generatedOn(MetadataDto v) => v.generatedOn;
  static const Field<MetadataDto, String> _f$generatedOn = Field(
    'generatedOn',
    _$generatedOn,
  );
  static String _$language(MetadataDto v) => v.language;
  static const Field<MetadataDto, String> _f$language = Field(
    'language',
    _$language,
  );

  @override
  final MappableFields<MetadataDto> fields = const {
    #formatVersion: _f$formatVersion,
    #generatedOn: _f$generatedOn,
    #language: _f$language,
  };

  static MetadataDto _instantiate(DecodingData data) {
    return MetadataDto(
      formatVersion: data.dec(_f$formatVersion),
      generatedOn: data.dec(_f$generatedOn),
      language: data.dec(_f$language),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MetadataDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MetadataDto>(map);
  }

  static MetadataDto fromJson(String json) {
    return ensureInitialized().decodeJson<MetadataDto>(json);
  }
}

mixin MetadataDtoMappable {
  String toJson() {
    return MetadataDtoMapper.ensureInitialized().encodeJson<MetadataDto>(
      this as MetadataDto,
    );
  }

  Map<String, dynamic> toMap() {
    return MetadataDtoMapper.ensureInitialized().encodeMap<MetadataDto>(
      this as MetadataDto,
    );
  }

  MetadataDtoCopyWith<MetadataDto, MetadataDto, MetadataDto> get copyWith =>
      _MetadataDtoCopyWithImpl<MetadataDto, MetadataDto>(
        this as MetadataDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MetadataDtoMapper.ensureInitialized().stringifyValue(
      this as MetadataDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return MetadataDtoMapper.ensureInitialized().equalsValue(
      this as MetadataDto,
      other,
    );
  }

  @override
  int get hashCode {
    return MetadataDtoMapper.ensureInitialized().hashValue(this as MetadataDto);
  }
}

extension MetadataDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MetadataDto, $Out> {
  MetadataDtoCopyWith<$R, MetadataDto, $Out> get $asMetadataDto =>
      $base.as((v, t, t2) => _MetadataDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MetadataDtoCopyWith<$R, $In extends MetadataDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? formatVersion, String? generatedOn, String? language});
  MetadataDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MetadataDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MetadataDto, $Out>
    implements MetadataDtoCopyWith<$R, MetadataDto, $Out> {
  _MetadataDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MetadataDto> $mapper =
      MetadataDtoMapper.ensureInitialized();
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
  MetadataDto $make(CopyWithData data) => MetadataDto(
    formatVersion: data.get(#formatVersion, or: $value.formatVersion),
    generatedOn: data.get(#generatedOn, or: $value.generatedOn),
    language: data.get(#language, or: $value.language),
  );

  @override
  MetadataDtoCopyWith<$R2, MetadataDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MetadataDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CardDtoMapper extends ClassMapperBase<CardDto> {
  CardDtoMapper._();

  static CardDtoMapper? _instance;
  static CardDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CardDto';

  static int _$id(CardDto v) => v.id;
  static const Field<CardDto, int> _f$id = Field('id', _$id);
  static String _$setCode(CardDto v) => v.setCode;
  static const Field<CardDto, String> _f$setCode = Field('setCode', _$setCode);
  static int _$number(CardDto v) => v.number;
  static const Field<CardDto, int> _f$number = Field('number', _$number);
  static String _$simpleName(CardDto v) => v.simpleName;
  static const Field<CardDto, String> _f$simpleName = Field(
    'simpleName',
    _$simpleName,
  );
  static String _$fullName(CardDto v) => v.fullName;
  static const Field<CardDto, String> _f$fullName = Field(
    'fullName',
    _$fullName,
  );
  static String _$rarity(CardDto v) => v.rarity;
  static const Field<CardDto, String> _f$rarity = Field(
    'rarity',
    _$rarity,
    opt: true,
    def: '',
  );
  static String _$type(CardDto v) => v.type;
  static const Field<CardDto, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: '',
  );
  static String _$story(CardDto v) => v.story;
  static const Field<CardDto, String> _f$story = Field(
    'story',
    _$story,
    opt: true,
    def: '',
  );
  static int _$cost(CardDto v) => v.cost;
  static const Field<CardDto, int> _f$cost = Field(
    'cost',
    _$cost,
    opt: true,
    def: 0,
  );
  static bool _$inkwell(CardDto v) => v.inkwell;
  static const Field<CardDto, bool> _f$inkwell = Field(
    'inkwell',
    _$inkwell,
    opt: true,
    def: false,
  );
  static String? _$color(CardDto v) => v.color;
  static const Field<CardDto, String> _f$color = Field(
    'color',
    _$color,
    opt: true,
  );
  static List<String>? _$colors(CardDto v) => v.colors;
  static const Field<CardDto, List<String>> _f$colors = Field(
    'colors',
    _$colors,
    opt: true,
  );
  static String? _$promoGrouping(CardDto v) => v.promoGrouping;
  static const Field<CardDto, String> _f$promoGrouping = Field(
    'promoGrouping',
    _$promoGrouping,
    opt: true,
  );
  static List<String> _$foilTypes(CardDto v) => v.foilTypes;
  static const Field<CardDto, List<String>> _f$foilTypes = Field(
    'foilTypes',
    _$foilTypes,
    opt: true,
    def: const [],
  );
  static Map<String, String> _$images(CardDto v) => v.images;
  static const Field<CardDto, Map<String, String>> _f$images = Field(
    'images',
    _$images,
    opt: true,
    def: const {},
  );
  static Map<String, String> _$externalLinks(CardDto v) => v.externalLinks;
  static const Field<CardDto, Map<String, String>> _f$externalLinks = Field(
    'externalLinks',
    _$externalLinks,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<CardDto> fields = const {
    #id: _f$id,
    #setCode: _f$setCode,
    #number: _f$number,
    #simpleName: _f$simpleName,
    #fullName: _f$fullName,
    #rarity: _f$rarity,
    #type: _f$type,
    #story: _f$story,
    #cost: _f$cost,
    #inkwell: _f$inkwell,
    #color: _f$color,
    #colors: _f$colors,
    #promoGrouping: _f$promoGrouping,
    #foilTypes: _f$foilTypes,
    #images: _f$images,
    #externalLinks: _f$externalLinks,
  };

  static CardDto _instantiate(DecodingData data) {
    return CardDto(
      id: data.dec(_f$id),
      setCode: data.dec(_f$setCode),
      number: data.dec(_f$number),
      simpleName: data.dec(_f$simpleName),
      fullName: data.dec(_f$fullName),
      rarity: data.dec(_f$rarity),
      type: data.dec(_f$type),
      story: data.dec(_f$story),
      cost: data.dec(_f$cost),
      inkwell: data.dec(_f$inkwell),
      color: data.dec(_f$color),
      colors: data.dec(_f$colors),
      promoGrouping: data.dec(_f$promoGrouping),
      foilTypes: data.dec(_f$foilTypes),
      images: data.dec(_f$images),
      externalLinks: data.dec(_f$externalLinks),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CardDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardDto>(map);
  }

  static CardDto fromJson(String json) {
    return ensureInitialized().decodeJson<CardDto>(json);
  }
}

mixin CardDtoMappable {
  String toJson() {
    return CardDtoMapper.ensureInitialized().encodeJson<CardDto>(
      this as CardDto,
    );
  }

  Map<String, dynamic> toMap() {
    return CardDtoMapper.ensureInitialized().encodeMap<CardDto>(
      this as CardDto,
    );
  }

  CardDtoCopyWith<CardDto, CardDto, CardDto> get copyWith =>
      _CardDtoCopyWithImpl<CardDto, CardDto>(
        this as CardDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CardDtoMapper.ensureInitialized().stringifyValue(this as CardDto);
  }

  @override
  bool operator ==(Object other) {
    return CardDtoMapper.ensureInitialized().equalsValue(
      this as CardDto,
      other,
    );
  }

  @override
  int get hashCode {
    return CardDtoMapper.ensureInitialized().hashValue(this as CardDto);
  }
}

extension CardDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, CardDto, $Out> {
  CardDtoCopyWith<$R, CardDto, $Out> get $asCardDto =>
      $base.as((v, t, t2) => _CardDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CardDtoCopyWith<$R, $In extends CardDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get colors;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get foilTypes;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get images;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get externalLinks;
  $R call({
    int? id,
    String? setCode,
    int? number,
    String? simpleName,
    String? fullName,
    String? rarity,
    String? type,
    String? story,
    int? cost,
    bool? inkwell,
    String? color,
    List<String>? colors,
    String? promoGrouping,
    List<String>? foilTypes,
    Map<String, String>? images,
    Map<String, String>? externalLinks,
  });
  CardDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CardDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardDto, $Out>
    implements CardDtoCopyWith<$R, CardDto, $Out> {
  _CardDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardDto> $mapper =
      CardDtoMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get colors =>
      $value.colors != null
      ? ListCopyWith(
          $value.colors!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(colors: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get foilTypes =>
      ListCopyWith(
        $value.foilTypes,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(foilTypes: v),
      );
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
  $R call({
    int? id,
    String? setCode,
    int? number,
    String? simpleName,
    String? fullName,
    String? rarity,
    String? type,
    String? story,
    int? cost,
    bool? inkwell,
    Object? color = $none,
    Object? colors = $none,
    Object? promoGrouping = $none,
    List<String>? foilTypes,
    Map<String, String>? images,
    Map<String, String>? externalLinks,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (setCode != null) #setCode: setCode,
      if (number != null) #number: number,
      if (simpleName != null) #simpleName: simpleName,
      if (fullName != null) #fullName: fullName,
      if (rarity != null) #rarity: rarity,
      if (type != null) #type: type,
      if (story != null) #story: story,
      if (cost != null) #cost: cost,
      if (inkwell != null) #inkwell: inkwell,
      if (color != $none) #color: color,
      if (colors != $none) #colors: colors,
      if (promoGrouping != $none) #promoGrouping: promoGrouping,
      if (foilTypes != null) #foilTypes: foilTypes,
      if (images != null) #images: images,
      if (externalLinks != null) #externalLinks: externalLinks,
    }),
  );
  @override
  CardDto $make(CopyWithData data) => CardDto(
    id: data.get(#id, or: $value.id),
    setCode: data.get(#setCode, or: $value.setCode),
    number: data.get(#number, or: $value.number),
    simpleName: data.get(#simpleName, or: $value.simpleName),
    fullName: data.get(#fullName, or: $value.fullName),
    rarity: data.get(#rarity, or: $value.rarity),
    type: data.get(#type, or: $value.type),
    story: data.get(#story, or: $value.story),
    cost: data.get(#cost, or: $value.cost),
    inkwell: data.get(#inkwell, or: $value.inkwell),
    color: data.get(#color, or: $value.color),
    colors: data.get(#colors, or: $value.colors),
    promoGrouping: data.get(#promoGrouping, or: $value.promoGrouping),
    foilTypes: data.get(#foilTypes, or: $value.foilTypes),
    images: data.get(#images, or: $value.images),
    externalLinks: data.get(#externalLinks, or: $value.externalLinks),
  );

  @override
  CardDtoCopyWith<$R2, CardDto, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CardDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PriceDtoMapper extends ClassMapperBase<PriceDto> {
  PriceDtoMapper._();

  static PriceDtoMapper? _instance;
  static PriceDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PriceDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PriceDto';

  static int _$idProduct(PriceDto v) => v.idProduct;
  static const Field<PriceDto, int> _f$idProduct = Field(
    'idProduct',
    _$idProduct,
  );
  static double? _$avg(PriceDto v) => v.avg;
  static const Field<PriceDto, double> _f$avg = Field('avg', _$avg, opt: true);
  static double? _$low(PriceDto v) => v.low;
  static const Field<PriceDto, double> _f$low = Field('low', _$low, opt: true);
  static double? _$trend(PriceDto v) => v.trend;
  static const Field<PriceDto, double> _f$trend = Field(
    'trend',
    _$trend,
    opt: true,
  );
  static double? _$avg1(PriceDto v) => v.avg1;
  static const Field<PriceDto, double> _f$avg1 = Field(
    'avg1',
    _$avg1,
    opt: true,
  );
  static double? _$avg7(PriceDto v) => v.avg7;
  static const Field<PriceDto, double> _f$avg7 = Field(
    'avg7',
    _$avg7,
    opt: true,
  );
  static double? _$avg30(PriceDto v) => v.avg30;
  static const Field<PriceDto, double> _f$avg30 = Field(
    'avg30',
    _$avg30,
    opt: true,
  );
  static double? _$avgFoil(PriceDto v) => v.avgFoil;
  static const Field<PriceDto, double> _f$avgFoil = Field(
    'avgFoil',
    _$avgFoil,
    key: r'avg-foil',
    opt: true,
  );
  static double? _$lowFoil(PriceDto v) => v.lowFoil;
  static const Field<PriceDto, double> _f$lowFoil = Field(
    'lowFoil',
    _$lowFoil,
    key: r'low-foil',
    opt: true,
  );
  static double? _$trendFoil(PriceDto v) => v.trendFoil;
  static const Field<PriceDto, double> _f$trendFoil = Field(
    'trendFoil',
    _$trendFoil,
    key: r'trend-foil',
    opt: true,
  );
  static double? _$avg1Foil(PriceDto v) => v.avg1Foil;
  static const Field<PriceDto, double> _f$avg1Foil = Field(
    'avg1Foil',
    _$avg1Foil,
    key: r'avg1-foil',
    opt: true,
  );
  static double? _$avg7Foil(PriceDto v) => v.avg7Foil;
  static const Field<PriceDto, double> _f$avg7Foil = Field(
    'avg7Foil',
    _$avg7Foil,
    key: r'avg7-foil',
    opt: true,
  );
  static double? _$avg30Foil(PriceDto v) => v.avg30Foil;
  static const Field<PriceDto, double> _f$avg30Foil = Field(
    'avg30Foil',
    _$avg30Foil,
    key: r'avg30-foil',
    opt: true,
  );

  @override
  final MappableFields<PriceDto> fields = const {
    #idProduct: _f$idProduct,
    #avg: _f$avg,
    #low: _f$low,
    #trend: _f$trend,
    #avg1: _f$avg1,
    #avg7: _f$avg7,
    #avg30: _f$avg30,
    #avgFoil: _f$avgFoil,
    #lowFoil: _f$lowFoil,
    #trendFoil: _f$trendFoil,
    #avg1Foil: _f$avg1Foil,
    #avg7Foil: _f$avg7Foil,
    #avg30Foil: _f$avg30Foil,
  };

  static PriceDto _instantiate(DecodingData data) {
    return PriceDto(
      idProduct: data.dec(_f$idProduct),
      avg: data.dec(_f$avg),
      low: data.dec(_f$low),
      trend: data.dec(_f$trend),
      avg1: data.dec(_f$avg1),
      avg7: data.dec(_f$avg7),
      avg30: data.dec(_f$avg30),
      avgFoil: data.dec(_f$avgFoil),
      lowFoil: data.dec(_f$lowFoil),
      trendFoil: data.dec(_f$trendFoil),
      avg1Foil: data.dec(_f$avg1Foil),
      avg7Foil: data.dec(_f$avg7Foil),
      avg30Foil: data.dec(_f$avg30Foil),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PriceDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PriceDto>(map);
  }

  static PriceDto fromJson(String json) {
    return ensureInitialized().decodeJson<PriceDto>(json);
  }
}

mixin PriceDtoMappable {
  String toJson() {
    return PriceDtoMapper.ensureInitialized().encodeJson<PriceDto>(
      this as PriceDto,
    );
  }

  Map<String, dynamic> toMap() {
    return PriceDtoMapper.ensureInitialized().encodeMap<PriceDto>(
      this as PriceDto,
    );
  }

  PriceDtoCopyWith<PriceDto, PriceDto, PriceDto> get copyWith =>
      _PriceDtoCopyWithImpl<PriceDto, PriceDto>(
        this as PriceDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PriceDtoMapper.ensureInitialized().stringifyValue(this as PriceDto);
  }

  @override
  bool operator ==(Object other) {
    return PriceDtoMapper.ensureInitialized().equalsValue(
      this as PriceDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PriceDtoMapper.ensureInitialized().hashValue(this as PriceDto);
  }
}

extension PriceDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, PriceDto, $Out> {
  PriceDtoCopyWith<$R, PriceDto, $Out> get $asPriceDto =>
      $base.as((v, t, t2) => _PriceDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PriceDtoCopyWith<$R, $In extends PriceDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? idProduct,
    double? avg,
    double? low,
    double? trend,
    double? avg1,
    double? avg7,
    double? avg30,
    double? avgFoil,
    double? lowFoil,
    double? trendFoil,
    double? avg1Foil,
    double? avg7Foil,
    double? avg30Foil,
  });
  PriceDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PriceDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PriceDto, $Out>
    implements PriceDtoCopyWith<$R, PriceDto, $Out> {
  _PriceDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PriceDto> $mapper =
      PriceDtoMapper.ensureInitialized();
  @override
  $R call({
    int? idProduct,
    Object? avg = $none,
    Object? low = $none,
    Object? trend = $none,
    Object? avg1 = $none,
    Object? avg7 = $none,
    Object? avg30 = $none,
    Object? avgFoil = $none,
    Object? lowFoil = $none,
    Object? trendFoil = $none,
    Object? avg1Foil = $none,
    Object? avg7Foil = $none,
    Object? avg30Foil = $none,
  }) => $apply(
    FieldCopyWithData({
      if (idProduct != null) #idProduct: idProduct,
      if (avg != $none) #avg: avg,
      if (low != $none) #low: low,
      if (trend != $none) #trend: trend,
      if (avg1 != $none) #avg1: avg1,
      if (avg7 != $none) #avg7: avg7,
      if (avg30 != $none) #avg30: avg30,
      if (avgFoil != $none) #avgFoil: avgFoil,
      if (lowFoil != $none) #lowFoil: lowFoil,
      if (trendFoil != $none) #trendFoil: trendFoil,
      if (avg1Foil != $none) #avg1Foil: avg1Foil,
      if (avg7Foil != $none) #avg7Foil: avg7Foil,
      if (avg30Foil != $none) #avg30Foil: avg30Foil,
    }),
  );
  @override
  PriceDto $make(CopyWithData data) => PriceDto(
    idProduct: data.get(#idProduct, or: $value.idProduct),
    avg: data.get(#avg, or: $value.avg),
    low: data.get(#low, or: $value.low),
    trend: data.get(#trend, or: $value.trend),
    avg1: data.get(#avg1, or: $value.avg1),
    avg7: data.get(#avg7, or: $value.avg7),
    avg30: data.get(#avg30, or: $value.avg30),
    avgFoil: data.get(#avgFoil, or: $value.avgFoil),
    lowFoil: data.get(#lowFoil, or: $value.lowFoil),
    trendFoil: data.get(#trendFoil, or: $value.trendFoil),
    avg1Foil: data.get(#avg1Foil, or: $value.avg1Foil),
    avg7Foil: data.get(#avg7Foil, or: $value.avg7Foil),
    avg30Foil: data.get(#avg30Foil, or: $value.avg30Foil),
  );

  @override
  PriceDtoCopyWith<$R2, PriceDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PriceDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

