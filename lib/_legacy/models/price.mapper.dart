// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'price.dart';

class PriceMapper extends ClassMapperBase<Price> {
  PriceMapper._();

  static PriceMapper? _instance;
  static PriceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PriceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Price';

  static int _$idProduct(Price v) => v.idProduct;
  static const Field<Price, int> _f$idProduct = Field('idProduct', _$idProduct);
  static double? _$avg(Price v) => v.avg;
  static const Field<Price, double> _f$avg = Field('avg', _$avg, opt: true);
  static double? _$low(Price v) => v.low;
  static const Field<Price, double> _f$low = Field('low', _$low, opt: true);
  static double? _$trend(Price v) => v.trend;
  static const Field<Price, double> _f$trend = Field(
    'trend',
    _$trend,
    opt: true,
  );
  static double? _$avg1(Price v) => v.avg1;
  static const Field<Price, double> _f$avg1 = Field('avg1', _$avg1, opt: true);
  static double? _$avg7(Price v) => v.avg7;
  static const Field<Price, double> _f$avg7 = Field('avg7', _$avg7, opt: true);
  static double? _$avg30(Price v) => v.avg30;
  static const Field<Price, double> _f$avg30 = Field(
    'avg30',
    _$avg30,
    opt: true,
  );
  static double? _$avgFoil(Price v) => v.avgFoil;
  static const Field<Price, double> _f$avgFoil = Field(
    'avgFoil',
    _$avgFoil,
    key: r'avg-foil',
    opt: true,
  );
  static double? _$lowFoil(Price v) => v.lowFoil;
  static const Field<Price, double> _f$lowFoil = Field(
    'lowFoil',
    _$lowFoil,
    key: r'low-foil',
    opt: true,
  );
  static double? _$trendFoil(Price v) => v.trendFoil;
  static const Field<Price, double> _f$trendFoil = Field(
    'trendFoil',
    _$trendFoil,
    key: r'trend-foil',
    opt: true,
  );
  static double? _$avg1Foil(Price v) => v.avg1Foil;
  static const Field<Price, double> _f$avg1Foil = Field(
    'avg1Foil',
    _$avg1Foil,
    key: r'avg1-foil',
    opt: true,
  );
  static double? _$avg7Foil(Price v) => v.avg7Foil;
  static const Field<Price, double> _f$avg7Foil = Field(
    'avg7Foil',
    _$avg7Foil,
    key: r'avg7-foil',
    opt: true,
  );
  static double? _$avg30Foil(Price v) => v.avg30Foil;
  static const Field<Price, double> _f$avg30Foil = Field(
    'avg30Foil',
    _$avg30Foil,
    key: r'avg30-foil',
    opt: true,
  );

  @override
  final MappableFields<Price> fields = const {
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

  static Price _instantiate(DecodingData data) {
    return Price(
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

  static Price fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Price>(map);
  }

  static Price fromJson(String json) {
    return ensureInitialized().decodeJson<Price>(json);
  }
}

mixin PriceMappable {
  String toJson() {
    return PriceMapper.ensureInitialized().encodeJson<Price>(this as Price);
  }

  Map<String, dynamic> toMap() {
    return PriceMapper.ensureInitialized().encodeMap<Price>(this as Price);
  }

  PriceCopyWith<Price, Price, Price> get copyWith =>
      _PriceCopyWithImpl<Price, Price>(this as Price, $identity, $identity);
  @override
  String toString() {
    return PriceMapper.ensureInitialized().stringifyValue(this as Price);
  }

  @override
  bool operator ==(Object other) {
    return PriceMapper.ensureInitialized().equalsValue(this as Price, other);
  }

  @override
  int get hashCode {
    return PriceMapper.ensureInitialized().hashValue(this as Price);
  }
}

extension PriceValueCopy<$R, $Out> on ObjectCopyWith<$R, Price, $Out> {
  PriceCopyWith<$R, Price, $Out> get $asPrice =>
      $base.as((v, t, t2) => _PriceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PriceCopyWith<$R, $In extends Price, $Out>
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
  PriceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PriceCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Price, $Out>
    implements PriceCopyWith<$R, Price, $Out> {
  _PriceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Price> $mapper = PriceMapper.ensureInitialized();
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
  Price $make(CopyWithData data) => Price(
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
  PriceCopyWith<$R2, Price, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PriceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

