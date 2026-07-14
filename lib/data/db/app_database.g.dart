// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, Card> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _setCodeMeta = const VerificationMeta(
    'setCode',
  );
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
    'set_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('de'),
  );
  static const VerificationMeta _simpleNameMeta = const VerificationMeta(
    'simpleName',
  );
  @override
  late final GeneratedColumn<String> simpleName = GeneratedColumn<String>(
    'simple_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchNameMeta = const VerificationMeta(
    'searchName',
  );
  @override
  late final GeneratedColumn<String> searchName = GeneratedColumn<String>(
    'search_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storyMeta = const VerificationMeta('story');
  @override
  late final GeneratedColumn<String> story = GeneratedColumn<String>(
    'story',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inkMeta = const VerificationMeta('ink');
  @override
  late final GeneratedColumn<String> ink = GeneratedColumn<String>(
    'ink',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _inksJsonMeta = const VerificationMeta(
    'inksJson',
  );
  @override
  late final GeneratedColumn<String> inksJson = GeneratedColumn<String>(
    'inks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inkwellMeta = const VerificationMeta(
    'inkwell',
  );
  @override
  late final GeneratedColumn<bool> inkwell = GeneratedColumn<bool>(
    'inkwell',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inkwell" IN (0, 1))',
    ),
  );
  static const VerificationMeta _promoGroupingMeta = const VerificationMeta(
    'promoGrouping',
  );
  @override
  late final GeneratedColumn<String> promoGrouping = GeneratedColumn<String>(
    'promo_grouping',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foilTypesJsonMeta = const VerificationMeta(
    'foilTypesJson',
  );
  @override
  late final GeneratedColumn<String> foilTypesJson = GeneratedColumn<String>(
    'foil_types_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _imagesJsonMeta = const VerificationMeta(
    'imagesJson',
  );
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
    'images_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _externalLinksJsonMeta = const VerificationMeta(
    'externalLinksJson',
  );
  @override
  late final GeneratedColumn<String> externalLinksJson =
      GeneratedColumn<String>(
        'external_links_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _cardmarketIdMeta = const VerificationMeta(
    'cardmarketId',
  );
  @override
  late final GeneratedColumn<int> cardmarketId = GeneratedColumn<int>(
    'cardmarket_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    setCode,
    number,
    language,
    simpleName,
    fullName,
    searchName,
    rarity,
    type,
    story,
    ink,
    inksJson,
    cost,
    inkwell,
    promoGrouping,
    foilTypesJson,
    imagesJson,
    externalLinksJson,
    cardmarketId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Card> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('set_code')) {
      context.handle(
        _setCodeMeta,
        setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('simple_name')) {
      context.handle(
        _simpleNameMeta,
        simpleName.isAcceptableOrUnknown(data['simple_name']!, _simpleNameMeta),
      );
    } else if (isInserting) {
      context.missing(_simpleNameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('search_name')) {
      context.handle(
        _searchNameMeta,
        searchName.isAcceptableOrUnknown(data['search_name']!, _searchNameMeta),
      );
    } else if (isInserting) {
      context.missing(_searchNameMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('story')) {
      context.handle(
        _storyMeta,
        story.isAcceptableOrUnknown(data['story']!, _storyMeta),
      );
    } else if (isInserting) {
      context.missing(_storyMeta);
    }
    if (data.containsKey('ink')) {
      context.handle(
        _inkMeta,
        ink.isAcceptableOrUnknown(data['ink']!, _inkMeta),
      );
    }
    if (data.containsKey('inks_json')) {
      context.handle(
        _inksJsonMeta,
        inksJson.isAcceptableOrUnknown(data['inks_json']!, _inksJsonMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('inkwell')) {
      context.handle(
        _inkwellMeta,
        inkwell.isAcceptableOrUnknown(data['inkwell']!, _inkwellMeta),
      );
    } else if (isInserting) {
      context.missing(_inkwellMeta);
    }
    if (data.containsKey('promo_grouping')) {
      context.handle(
        _promoGroupingMeta,
        promoGrouping.isAcceptableOrUnknown(
          data['promo_grouping']!,
          _promoGroupingMeta,
        ),
      );
    }
    if (data.containsKey('foil_types_json')) {
      context.handle(
        _foilTypesJsonMeta,
        foilTypesJson.isAcceptableOrUnknown(
          data['foil_types_json']!,
          _foilTypesJsonMeta,
        ),
      );
    }
    if (data.containsKey('images_json')) {
      context.handle(
        _imagesJsonMeta,
        imagesJson.isAcceptableOrUnknown(data['images_json']!, _imagesJsonMeta),
      );
    }
    if (data.containsKey('external_links_json')) {
      context.handle(
        _externalLinksJsonMeta,
        externalLinksJson.isAcceptableOrUnknown(
          data['external_links_json']!,
          _externalLinksJsonMeta,
        ),
      );
    }
    if (data.containsKey('cardmarket_id')) {
      context.handle(
        _cardmarketIdMeta,
        cardmarketId.isAcceptableOrUnknown(
          data['cardmarket_id']!,
          _cardmarketIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Card(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      setCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}set_code'],
          )!,
      number:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}number'],
          )!,
      language:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}language'],
          )!,
      simpleName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}simple_name'],
          )!,
      fullName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}full_name'],
          )!,
      searchName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}search_name'],
          )!,
      rarity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}rarity'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      story:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}story'],
          )!,
      ink:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ink'],
          )!,
      inksJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}inks_json'],
          )!,
      cost:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}cost'],
          )!,
      inkwell:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}inkwell'],
          )!,
      promoGrouping: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promo_grouping'],
      ),
      foilTypesJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}foil_types_json'],
          )!,
      imagesJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}images_json'],
          )!,
      externalLinksJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}external_links_json'],
          )!,
      cardmarketId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cardmarket_id'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class Card extends DataClass implements Insertable<Card> {
  final int id;
  final String setCode;
  final int number;
  final String language;
  final String simpleName;
  final String fullName;

  /// Pre-normalized via [normalizeName] — scanner matching key.
  final String searchName;
  final String rarity;
  final String type;
  final String story;

  /// Primary ink color; dual-ink cards carry the full list in [inksJson].
  final String ink;
  final String inksJson;
  final int cost;
  final bool inkwell;
  final String? promoGrouping;
  final String foilTypesJson;
  final String imagesJson;
  final String externalLinksJson;

  /// Extracted from externalLinks.cardmarketId at sync time so prices join
  /// in SQL.
  final int? cardmarketId;
  const Card({
    required this.id,
    required this.setCode,
    required this.number,
    required this.language,
    required this.simpleName,
    required this.fullName,
    required this.searchName,
    required this.rarity,
    required this.type,
    required this.story,
    required this.ink,
    required this.inksJson,
    required this.cost,
    required this.inkwell,
    this.promoGrouping,
    required this.foilTypesJson,
    required this.imagesJson,
    required this.externalLinksJson,
    this.cardmarketId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['set_code'] = Variable<String>(setCode);
    map['number'] = Variable<int>(number);
    map['language'] = Variable<String>(language);
    map['simple_name'] = Variable<String>(simpleName);
    map['full_name'] = Variable<String>(fullName);
    map['search_name'] = Variable<String>(searchName);
    map['rarity'] = Variable<String>(rarity);
    map['type'] = Variable<String>(type);
    map['story'] = Variable<String>(story);
    map['ink'] = Variable<String>(ink);
    map['inks_json'] = Variable<String>(inksJson);
    map['cost'] = Variable<int>(cost);
    map['inkwell'] = Variable<bool>(inkwell);
    if (!nullToAbsent || promoGrouping != null) {
      map['promo_grouping'] = Variable<String>(promoGrouping);
    }
    map['foil_types_json'] = Variable<String>(foilTypesJson);
    map['images_json'] = Variable<String>(imagesJson);
    map['external_links_json'] = Variable<String>(externalLinksJson);
    if (!nullToAbsent || cardmarketId != null) {
      map['cardmarket_id'] = Variable<int>(cardmarketId);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      setCode: Value(setCode),
      number: Value(number),
      language: Value(language),
      simpleName: Value(simpleName),
      fullName: Value(fullName),
      searchName: Value(searchName),
      rarity: Value(rarity),
      type: Value(type),
      story: Value(story),
      ink: Value(ink),
      inksJson: Value(inksJson),
      cost: Value(cost),
      inkwell: Value(inkwell),
      promoGrouping:
          promoGrouping == null && nullToAbsent
              ? const Value.absent()
              : Value(promoGrouping),
      foilTypesJson: Value(foilTypesJson),
      imagesJson: Value(imagesJson),
      externalLinksJson: Value(externalLinksJson),
      cardmarketId:
          cardmarketId == null && nullToAbsent
              ? const Value.absent()
              : Value(cardmarketId),
    );
  }

  factory Card.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<int>(json['id']),
      setCode: serializer.fromJson<String>(json['setCode']),
      number: serializer.fromJson<int>(json['number']),
      language: serializer.fromJson<String>(json['language']),
      simpleName: serializer.fromJson<String>(json['simpleName']),
      fullName: serializer.fromJson<String>(json['fullName']),
      searchName: serializer.fromJson<String>(json['searchName']),
      rarity: serializer.fromJson<String>(json['rarity']),
      type: serializer.fromJson<String>(json['type']),
      story: serializer.fromJson<String>(json['story']),
      ink: serializer.fromJson<String>(json['ink']),
      inksJson: serializer.fromJson<String>(json['inksJson']),
      cost: serializer.fromJson<int>(json['cost']),
      inkwell: serializer.fromJson<bool>(json['inkwell']),
      promoGrouping: serializer.fromJson<String?>(json['promoGrouping']),
      foilTypesJson: serializer.fromJson<String>(json['foilTypesJson']),
      imagesJson: serializer.fromJson<String>(json['imagesJson']),
      externalLinksJson: serializer.fromJson<String>(json['externalLinksJson']),
      cardmarketId: serializer.fromJson<int?>(json['cardmarketId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'setCode': serializer.toJson<String>(setCode),
      'number': serializer.toJson<int>(number),
      'language': serializer.toJson<String>(language),
      'simpleName': serializer.toJson<String>(simpleName),
      'fullName': serializer.toJson<String>(fullName),
      'searchName': serializer.toJson<String>(searchName),
      'rarity': serializer.toJson<String>(rarity),
      'type': serializer.toJson<String>(type),
      'story': serializer.toJson<String>(story),
      'ink': serializer.toJson<String>(ink),
      'inksJson': serializer.toJson<String>(inksJson),
      'cost': serializer.toJson<int>(cost),
      'inkwell': serializer.toJson<bool>(inkwell),
      'promoGrouping': serializer.toJson<String?>(promoGrouping),
      'foilTypesJson': serializer.toJson<String>(foilTypesJson),
      'imagesJson': serializer.toJson<String>(imagesJson),
      'externalLinksJson': serializer.toJson<String>(externalLinksJson),
      'cardmarketId': serializer.toJson<int?>(cardmarketId),
    };
  }

  Card copyWith({
    int? id,
    String? setCode,
    int? number,
    String? language,
    String? simpleName,
    String? fullName,
    String? searchName,
    String? rarity,
    String? type,
    String? story,
    String? ink,
    String? inksJson,
    int? cost,
    bool? inkwell,
    Value<String?> promoGrouping = const Value.absent(),
    String? foilTypesJson,
    String? imagesJson,
    String? externalLinksJson,
    Value<int?> cardmarketId = const Value.absent(),
  }) => Card(
    id: id ?? this.id,
    setCode: setCode ?? this.setCode,
    number: number ?? this.number,
    language: language ?? this.language,
    simpleName: simpleName ?? this.simpleName,
    fullName: fullName ?? this.fullName,
    searchName: searchName ?? this.searchName,
    rarity: rarity ?? this.rarity,
    type: type ?? this.type,
    story: story ?? this.story,
    ink: ink ?? this.ink,
    inksJson: inksJson ?? this.inksJson,
    cost: cost ?? this.cost,
    inkwell: inkwell ?? this.inkwell,
    promoGrouping:
        promoGrouping.present ? promoGrouping.value : this.promoGrouping,
    foilTypesJson: foilTypesJson ?? this.foilTypesJson,
    imagesJson: imagesJson ?? this.imagesJson,
    externalLinksJson: externalLinksJson ?? this.externalLinksJson,
    cardmarketId: cardmarketId.present ? cardmarketId.value : this.cardmarketId,
  );
  Card copyWithCompanion(CardsCompanion data) {
    return Card(
      id: data.id.present ? data.id.value : this.id,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      number: data.number.present ? data.number.value : this.number,
      language: data.language.present ? data.language.value : this.language,
      simpleName:
          data.simpleName.present ? data.simpleName.value : this.simpleName,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      searchName:
          data.searchName.present ? data.searchName.value : this.searchName,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      type: data.type.present ? data.type.value : this.type,
      story: data.story.present ? data.story.value : this.story,
      ink: data.ink.present ? data.ink.value : this.ink,
      inksJson: data.inksJson.present ? data.inksJson.value : this.inksJson,
      cost: data.cost.present ? data.cost.value : this.cost,
      inkwell: data.inkwell.present ? data.inkwell.value : this.inkwell,
      promoGrouping:
          data.promoGrouping.present
              ? data.promoGrouping.value
              : this.promoGrouping,
      foilTypesJson:
          data.foilTypesJson.present
              ? data.foilTypesJson.value
              : this.foilTypesJson,
      imagesJson:
          data.imagesJson.present ? data.imagesJson.value : this.imagesJson,
      externalLinksJson:
          data.externalLinksJson.present
              ? data.externalLinksJson.value
              : this.externalLinksJson,
      cardmarketId:
          data.cardmarketId.present
              ? data.cardmarketId.value
              : this.cardmarketId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('setCode: $setCode, ')
          ..write('number: $number, ')
          ..write('language: $language, ')
          ..write('simpleName: $simpleName, ')
          ..write('fullName: $fullName, ')
          ..write('searchName: $searchName, ')
          ..write('rarity: $rarity, ')
          ..write('type: $type, ')
          ..write('story: $story, ')
          ..write('ink: $ink, ')
          ..write('inksJson: $inksJson, ')
          ..write('cost: $cost, ')
          ..write('inkwell: $inkwell, ')
          ..write('promoGrouping: $promoGrouping, ')
          ..write('foilTypesJson: $foilTypesJson, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('externalLinksJson: $externalLinksJson, ')
          ..write('cardmarketId: $cardmarketId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    setCode,
    number,
    language,
    simpleName,
    fullName,
    searchName,
    rarity,
    type,
    story,
    ink,
    inksJson,
    cost,
    inkwell,
    promoGrouping,
    foilTypesJson,
    imagesJson,
    externalLinksJson,
    cardmarketId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Card &&
          other.id == this.id &&
          other.setCode == this.setCode &&
          other.number == this.number &&
          other.language == this.language &&
          other.simpleName == this.simpleName &&
          other.fullName == this.fullName &&
          other.searchName == this.searchName &&
          other.rarity == this.rarity &&
          other.type == this.type &&
          other.story == this.story &&
          other.ink == this.ink &&
          other.inksJson == this.inksJson &&
          other.cost == this.cost &&
          other.inkwell == this.inkwell &&
          other.promoGrouping == this.promoGrouping &&
          other.foilTypesJson == this.foilTypesJson &&
          other.imagesJson == this.imagesJson &&
          other.externalLinksJson == this.externalLinksJson &&
          other.cardmarketId == this.cardmarketId);
}

class CardsCompanion extends UpdateCompanion<Card> {
  final Value<int> id;
  final Value<String> setCode;
  final Value<int> number;
  final Value<String> language;
  final Value<String> simpleName;
  final Value<String> fullName;
  final Value<String> searchName;
  final Value<String> rarity;
  final Value<String> type;
  final Value<String> story;
  final Value<String> ink;
  final Value<String> inksJson;
  final Value<int> cost;
  final Value<bool> inkwell;
  final Value<String?> promoGrouping;
  final Value<String> foilTypesJson;
  final Value<String> imagesJson;
  final Value<String> externalLinksJson;
  final Value<int?> cardmarketId;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.setCode = const Value.absent(),
    this.number = const Value.absent(),
    this.language = const Value.absent(),
    this.simpleName = const Value.absent(),
    this.fullName = const Value.absent(),
    this.searchName = const Value.absent(),
    this.rarity = const Value.absent(),
    this.type = const Value.absent(),
    this.story = const Value.absent(),
    this.ink = const Value.absent(),
    this.inksJson = const Value.absent(),
    this.cost = const Value.absent(),
    this.inkwell = const Value.absent(),
    this.promoGrouping = const Value.absent(),
    this.foilTypesJson = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.externalLinksJson = const Value.absent(),
    this.cardmarketId = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String setCode,
    required int number,
    this.language = const Value.absent(),
    required String simpleName,
    required String fullName,
    required String searchName,
    required String rarity,
    required String type,
    required String story,
    this.ink = const Value.absent(),
    this.inksJson = const Value.absent(),
    required int cost,
    required bool inkwell,
    this.promoGrouping = const Value.absent(),
    this.foilTypesJson = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.externalLinksJson = const Value.absent(),
    this.cardmarketId = const Value.absent(),
  }) : setCode = Value(setCode),
       number = Value(number),
       simpleName = Value(simpleName),
       fullName = Value(fullName),
       searchName = Value(searchName),
       rarity = Value(rarity),
       type = Value(type),
       story = Value(story),
       cost = Value(cost),
       inkwell = Value(inkwell);
  static Insertable<Card> custom({
    Expression<int>? id,
    Expression<String>? setCode,
    Expression<int>? number,
    Expression<String>? language,
    Expression<String>? simpleName,
    Expression<String>? fullName,
    Expression<String>? searchName,
    Expression<String>? rarity,
    Expression<String>? type,
    Expression<String>? story,
    Expression<String>? ink,
    Expression<String>? inksJson,
    Expression<int>? cost,
    Expression<bool>? inkwell,
    Expression<String>? promoGrouping,
    Expression<String>? foilTypesJson,
    Expression<String>? imagesJson,
    Expression<String>? externalLinksJson,
    Expression<int>? cardmarketId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setCode != null) 'set_code': setCode,
      if (number != null) 'number': number,
      if (language != null) 'language': language,
      if (simpleName != null) 'simple_name': simpleName,
      if (fullName != null) 'full_name': fullName,
      if (searchName != null) 'search_name': searchName,
      if (rarity != null) 'rarity': rarity,
      if (type != null) 'type': type,
      if (story != null) 'story': story,
      if (ink != null) 'ink': ink,
      if (inksJson != null) 'inks_json': inksJson,
      if (cost != null) 'cost': cost,
      if (inkwell != null) 'inkwell': inkwell,
      if (promoGrouping != null) 'promo_grouping': promoGrouping,
      if (foilTypesJson != null) 'foil_types_json': foilTypesJson,
      if (imagesJson != null) 'images_json': imagesJson,
      if (externalLinksJson != null) 'external_links_json': externalLinksJson,
      if (cardmarketId != null) 'cardmarket_id': cardmarketId,
    });
  }

  CardsCompanion copyWith({
    Value<int>? id,
    Value<String>? setCode,
    Value<int>? number,
    Value<String>? language,
    Value<String>? simpleName,
    Value<String>? fullName,
    Value<String>? searchName,
    Value<String>? rarity,
    Value<String>? type,
    Value<String>? story,
    Value<String>? ink,
    Value<String>? inksJson,
    Value<int>? cost,
    Value<bool>? inkwell,
    Value<String?>? promoGrouping,
    Value<String>? foilTypesJson,
    Value<String>? imagesJson,
    Value<String>? externalLinksJson,
    Value<int?>? cardmarketId,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      setCode: setCode ?? this.setCode,
      number: number ?? this.number,
      language: language ?? this.language,
      simpleName: simpleName ?? this.simpleName,
      fullName: fullName ?? this.fullName,
      searchName: searchName ?? this.searchName,
      rarity: rarity ?? this.rarity,
      type: type ?? this.type,
      story: story ?? this.story,
      ink: ink ?? this.ink,
      inksJson: inksJson ?? this.inksJson,
      cost: cost ?? this.cost,
      inkwell: inkwell ?? this.inkwell,
      promoGrouping: promoGrouping ?? this.promoGrouping,
      foilTypesJson: foilTypesJson ?? this.foilTypesJson,
      imagesJson: imagesJson ?? this.imagesJson,
      externalLinksJson: externalLinksJson ?? this.externalLinksJson,
      cardmarketId: cardmarketId ?? this.cardmarketId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (simpleName.present) {
      map['simple_name'] = Variable<String>(simpleName.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (searchName.present) {
      map['search_name'] = Variable<String>(searchName.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (story.present) {
      map['story'] = Variable<String>(story.value);
    }
    if (ink.present) {
      map['ink'] = Variable<String>(ink.value);
    }
    if (inksJson.present) {
      map['inks_json'] = Variable<String>(inksJson.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (inkwell.present) {
      map['inkwell'] = Variable<bool>(inkwell.value);
    }
    if (promoGrouping.present) {
      map['promo_grouping'] = Variable<String>(promoGrouping.value);
    }
    if (foilTypesJson.present) {
      map['foil_types_json'] = Variable<String>(foilTypesJson.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    if (externalLinksJson.present) {
      map['external_links_json'] = Variable<String>(externalLinksJson.value);
    }
    if (cardmarketId.present) {
      map['cardmarket_id'] = Variable<int>(cardmarketId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('setCode: $setCode, ')
          ..write('number: $number, ')
          ..write('language: $language, ')
          ..write('simpleName: $simpleName, ')
          ..write('fullName: $fullName, ')
          ..write('searchName: $searchName, ')
          ..write('rarity: $rarity, ')
          ..write('type: $type, ')
          ..write('story: $story, ')
          ..write('ink: $ink, ')
          ..write('inksJson: $inksJson, ')
          ..write('cost: $cost, ')
          ..write('inkwell: $inkwell, ')
          ..write('promoGrouping: $promoGrouping, ')
          ..write('foilTypesJson: $foilTypesJson, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('externalLinksJson: $externalLinksJson, ')
          ..write('cardmarketId: $cardmarketId')
          ..write(')'))
        .toString();
  }
}

class $CollectionEntriesTable extends CollectionEntries
    with TableInfo<$CollectionEntriesTable, CollectionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountFoilMeta = const VerificationMeta(
    'amountFoil',
  );
  @override
  late final GeneratedColumn<int> amountFoil = GeneratedColumn<int>(
    'amount_foil',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cardId, amount, amountFoil, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('amount_foil')) {
      context.handle(
        _amountFoilMeta,
        amountFoil.isAcceptableOrUnknown(data['amount_foil']!, _amountFoilMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  CollectionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionEntry(
      cardId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}card_id'],
          )!,
      amount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}amount'],
          )!,
      amountFoil:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}amount_foil'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $CollectionEntriesTable createAlias(String alias) {
    return $CollectionEntriesTable(attachedDatabase, alias);
  }
}

class CollectionEntry extends DataClass implements Insertable<CollectionEntry> {
  final int cardId;
  final int amount;
  final int amountFoil;
  final int updatedAt;
  const CollectionEntry({
    required this.cardId,
    required this.amount,
    required this.amountFoil,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<int>(cardId);
    map['amount'] = Variable<int>(amount);
    map['amount_foil'] = Variable<int>(amountFoil);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CollectionEntriesCompanion toCompanion(bool nullToAbsent) {
    return CollectionEntriesCompanion(
      cardId: Value(cardId),
      amount: Value(amount),
      amountFoil: Value(amountFoil),
      updatedAt: Value(updatedAt),
    );
  }

  factory CollectionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionEntry(
      cardId: serializer.fromJson<int>(json['cardId']),
      amount: serializer.fromJson<int>(json['amount']),
      amountFoil: serializer.fromJson<int>(json['amountFoil']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<int>(cardId),
      'amount': serializer.toJson<int>(amount),
      'amountFoil': serializer.toJson<int>(amountFoil),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CollectionEntry copyWith({
    int? cardId,
    int? amount,
    int? amountFoil,
    int? updatedAt,
  }) => CollectionEntry(
    cardId: cardId ?? this.cardId,
    amount: amount ?? this.amount,
    amountFoil: amountFoil ?? this.amountFoil,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CollectionEntry copyWithCompanion(CollectionEntriesCompanion data) {
    return CollectionEntry(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountFoil:
          data.amountFoil.present ? data.amountFoil.value : this.amountFoil,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionEntry(')
          ..write('cardId: $cardId, ')
          ..write('amount: $amount, ')
          ..write('amountFoil: $amountFoil, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, amount, amountFoil, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionEntry &&
          other.cardId == this.cardId &&
          other.amount == this.amount &&
          other.amountFoil == this.amountFoil &&
          other.updatedAt == this.updatedAt);
}

class CollectionEntriesCompanion extends UpdateCompanion<CollectionEntry> {
  final Value<int> cardId;
  final Value<int> amount;
  final Value<int> amountFoil;
  final Value<int> updatedAt;
  const CollectionEntriesCompanion({
    this.cardId = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountFoil = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CollectionEntriesCompanion.insert({
    this.cardId = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountFoil = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<CollectionEntry> custom({
    Expression<int>? cardId,
    Expression<int>? amount,
    Expression<int>? amountFoil,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (amount != null) 'amount': amount,
      if (amountFoil != null) 'amount_foil': amountFoil,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CollectionEntriesCompanion copyWith({
    Value<int>? cardId,
    Value<int>? amount,
    Value<int>? amountFoil,
    Value<int>? updatedAt,
  }) {
    return CollectionEntriesCompanion(
      cardId: cardId ?? this.cardId,
      amount: amount ?? this.amount,
      amountFoil: amountFoil ?? this.amountFoil,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (amountFoil.present) {
      map['amount_foil'] = Variable<int>(amountFoil.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionEntriesCompanion(')
          ..write('cardId: $cardId, ')
          ..write('amount: $amount, ')
          ..write('amountFoil: $amountFoil, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PricesTable extends Prices with TableInfo<$PricesTable, Price> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardmarketIdMeta = const VerificationMeta(
    'cardmarketId',
  );
  @override
  late final GeneratedColumn<int> cardmarketId = GeneratedColumn<int>(
    'cardmarket_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgMeta = const VerificationMeta('avg');
  @override
  late final GeneratedColumn<double> avg = GeneratedColumn<double>(
    'avg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowMeta = const VerificationMeta('low');
  @override
  late final GeneratedColumn<double> low = GeneratedColumn<double>(
    'low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trendMeta = const VerificationMeta('trend');
  @override
  late final GeneratedColumn<double> trend = GeneratedColumn<double>(
    'trend',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avg1Meta = const VerificationMeta('avg1');
  @override
  late final GeneratedColumn<double> avg1 = GeneratedColumn<double>(
    'avg1',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avg7Meta = const VerificationMeta('avg7');
  @override
  late final GeneratedColumn<double> avg7 = GeneratedColumn<double>(
    'avg7',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avg30Meta = const VerificationMeta('avg30');
  @override
  late final GeneratedColumn<double> avg30 = GeneratedColumn<double>(
    'avg30',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgFoilMeta = const VerificationMeta(
    'avgFoil',
  );
  @override
  late final GeneratedColumn<double> avgFoil = GeneratedColumn<double>(
    'avg_foil',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowFoilMeta = const VerificationMeta(
    'lowFoil',
  );
  @override
  late final GeneratedColumn<double> lowFoil = GeneratedColumn<double>(
    'low_foil',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trendFoilMeta = const VerificationMeta(
    'trendFoil',
  );
  @override
  late final GeneratedColumn<double> trendFoil = GeneratedColumn<double>(
    'trend_foil',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avg1FoilMeta = const VerificationMeta(
    'avg1Foil',
  );
  @override
  late final GeneratedColumn<double> avg1Foil = GeneratedColumn<double>(
    'avg1_foil',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avg7FoilMeta = const VerificationMeta(
    'avg7Foil',
  );
  @override
  late final GeneratedColumn<double> avg7Foil = GeneratedColumn<double>(
    'avg7_foil',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avg30FoilMeta = const VerificationMeta(
    'avg30Foil',
  );
  @override
  late final GeneratedColumn<double> avg30Foil = GeneratedColumn<double>(
    'avg30_foil',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardmarketId,
    avg,
    low,
    trend,
    avg1,
    avg7,
    avg30,
    avgFoil,
    lowFoil,
    trendFoil,
    avg1Foil,
    avg7Foil,
    avg30Foil,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Price> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cardmarket_id')) {
      context.handle(
        _cardmarketIdMeta,
        cardmarketId.isAcceptableOrUnknown(
          data['cardmarket_id']!,
          _cardmarketIdMeta,
        ),
      );
    }
    if (data.containsKey('avg')) {
      context.handle(
        _avgMeta,
        avg.isAcceptableOrUnknown(data['avg']!, _avgMeta),
      );
    }
    if (data.containsKey('low')) {
      context.handle(
        _lowMeta,
        low.isAcceptableOrUnknown(data['low']!, _lowMeta),
      );
    }
    if (data.containsKey('trend')) {
      context.handle(
        _trendMeta,
        trend.isAcceptableOrUnknown(data['trend']!, _trendMeta),
      );
    }
    if (data.containsKey('avg1')) {
      context.handle(
        _avg1Meta,
        avg1.isAcceptableOrUnknown(data['avg1']!, _avg1Meta),
      );
    }
    if (data.containsKey('avg7')) {
      context.handle(
        _avg7Meta,
        avg7.isAcceptableOrUnknown(data['avg7']!, _avg7Meta),
      );
    }
    if (data.containsKey('avg30')) {
      context.handle(
        _avg30Meta,
        avg30.isAcceptableOrUnknown(data['avg30']!, _avg30Meta),
      );
    }
    if (data.containsKey('avg_foil')) {
      context.handle(
        _avgFoilMeta,
        avgFoil.isAcceptableOrUnknown(data['avg_foil']!, _avgFoilMeta),
      );
    }
    if (data.containsKey('low_foil')) {
      context.handle(
        _lowFoilMeta,
        lowFoil.isAcceptableOrUnknown(data['low_foil']!, _lowFoilMeta),
      );
    }
    if (data.containsKey('trend_foil')) {
      context.handle(
        _trendFoilMeta,
        trendFoil.isAcceptableOrUnknown(data['trend_foil']!, _trendFoilMeta),
      );
    }
    if (data.containsKey('avg1_foil')) {
      context.handle(
        _avg1FoilMeta,
        avg1Foil.isAcceptableOrUnknown(data['avg1_foil']!, _avg1FoilMeta),
      );
    }
    if (data.containsKey('avg7_foil')) {
      context.handle(
        _avg7FoilMeta,
        avg7Foil.isAcceptableOrUnknown(data['avg7_foil']!, _avg7FoilMeta),
      );
    }
    if (data.containsKey('avg30_foil')) {
      context.handle(
        _avg30FoilMeta,
        avg30Foil.isAcceptableOrUnknown(data['avg30_foil']!, _avg30FoilMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardmarketId};
  @override
  Price map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Price(
      cardmarketId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}cardmarket_id'],
          )!,
      avg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg'],
      ),
      low: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}low'],
      ),
      trend: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}trend'],
      ),
      avg1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg1'],
      ),
      avg7: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg7'],
      ),
      avg30: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg30'],
      ),
      avgFoil: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_foil'],
      ),
      lowFoil: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}low_foil'],
      ),
      trendFoil: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}trend_foil'],
      ),
      avg1Foil: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg1_foil'],
      ),
      avg7Foil: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg7_foil'],
      ),
      avg30Foil: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg30_foil'],
      ),
      fetchedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}fetched_at'],
          )!,
    );
  }

  @override
  $PricesTable createAlias(String alias) {
    return $PricesTable(attachedDatabase, alias);
  }
}

class Price extends DataClass implements Insertable<Price> {
  /// Cardmarket idProduct.
  final int cardmarketId;
  final double? avg;
  final double? low;
  final double? trend;
  final double? avg1;
  final double? avg7;
  final double? avg30;
  final double? avgFoil;
  final double? lowFoil;
  final double? trendFoil;
  final double? avg1Foil;
  final double? avg7Foil;
  final double? avg30Foil;
  final int fetchedAt;
  const Price({
    required this.cardmarketId,
    this.avg,
    this.low,
    this.trend,
    this.avg1,
    this.avg7,
    this.avg30,
    this.avgFoil,
    this.lowFoil,
    this.trendFoil,
    this.avg1Foil,
    this.avg7Foil,
    this.avg30Foil,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cardmarket_id'] = Variable<int>(cardmarketId);
    if (!nullToAbsent || avg != null) {
      map['avg'] = Variable<double>(avg);
    }
    if (!nullToAbsent || low != null) {
      map['low'] = Variable<double>(low);
    }
    if (!nullToAbsent || trend != null) {
      map['trend'] = Variable<double>(trend);
    }
    if (!nullToAbsent || avg1 != null) {
      map['avg1'] = Variable<double>(avg1);
    }
    if (!nullToAbsent || avg7 != null) {
      map['avg7'] = Variable<double>(avg7);
    }
    if (!nullToAbsent || avg30 != null) {
      map['avg30'] = Variable<double>(avg30);
    }
    if (!nullToAbsent || avgFoil != null) {
      map['avg_foil'] = Variable<double>(avgFoil);
    }
    if (!nullToAbsent || lowFoil != null) {
      map['low_foil'] = Variable<double>(lowFoil);
    }
    if (!nullToAbsent || trendFoil != null) {
      map['trend_foil'] = Variable<double>(trendFoil);
    }
    if (!nullToAbsent || avg1Foil != null) {
      map['avg1_foil'] = Variable<double>(avg1Foil);
    }
    if (!nullToAbsent || avg7Foil != null) {
      map['avg7_foil'] = Variable<double>(avg7Foil);
    }
    if (!nullToAbsent || avg30Foil != null) {
      map['avg30_foil'] = Variable<double>(avg30Foil);
    }
    map['fetched_at'] = Variable<int>(fetchedAt);
    return map;
  }

  PricesCompanion toCompanion(bool nullToAbsent) {
    return PricesCompanion(
      cardmarketId: Value(cardmarketId),
      avg: avg == null && nullToAbsent ? const Value.absent() : Value(avg),
      low: low == null && nullToAbsent ? const Value.absent() : Value(low),
      trend:
          trend == null && nullToAbsent ? const Value.absent() : Value(trend),
      avg1: avg1 == null && nullToAbsent ? const Value.absent() : Value(avg1),
      avg7: avg7 == null && nullToAbsent ? const Value.absent() : Value(avg7),
      avg30:
          avg30 == null && nullToAbsent ? const Value.absent() : Value(avg30),
      avgFoil:
          avgFoil == null && nullToAbsent
              ? const Value.absent()
              : Value(avgFoil),
      lowFoil:
          lowFoil == null && nullToAbsent
              ? const Value.absent()
              : Value(lowFoil),
      trendFoil:
          trendFoil == null && nullToAbsent
              ? const Value.absent()
              : Value(trendFoil),
      avg1Foil:
          avg1Foil == null && nullToAbsent
              ? const Value.absent()
              : Value(avg1Foil),
      avg7Foil:
          avg7Foil == null && nullToAbsent
              ? const Value.absent()
              : Value(avg7Foil),
      avg30Foil:
          avg30Foil == null && nullToAbsent
              ? const Value.absent()
              : Value(avg30Foil),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory Price.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Price(
      cardmarketId: serializer.fromJson<int>(json['cardmarketId']),
      avg: serializer.fromJson<double?>(json['avg']),
      low: serializer.fromJson<double?>(json['low']),
      trend: serializer.fromJson<double?>(json['trend']),
      avg1: serializer.fromJson<double?>(json['avg1']),
      avg7: serializer.fromJson<double?>(json['avg7']),
      avg30: serializer.fromJson<double?>(json['avg30']),
      avgFoil: serializer.fromJson<double?>(json['avgFoil']),
      lowFoil: serializer.fromJson<double?>(json['lowFoil']),
      trendFoil: serializer.fromJson<double?>(json['trendFoil']),
      avg1Foil: serializer.fromJson<double?>(json['avg1Foil']),
      avg7Foil: serializer.fromJson<double?>(json['avg7Foil']),
      avg30Foil: serializer.fromJson<double?>(json['avg30Foil']),
      fetchedAt: serializer.fromJson<int>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardmarketId': serializer.toJson<int>(cardmarketId),
      'avg': serializer.toJson<double?>(avg),
      'low': serializer.toJson<double?>(low),
      'trend': serializer.toJson<double?>(trend),
      'avg1': serializer.toJson<double?>(avg1),
      'avg7': serializer.toJson<double?>(avg7),
      'avg30': serializer.toJson<double?>(avg30),
      'avgFoil': serializer.toJson<double?>(avgFoil),
      'lowFoil': serializer.toJson<double?>(lowFoil),
      'trendFoil': serializer.toJson<double?>(trendFoil),
      'avg1Foil': serializer.toJson<double?>(avg1Foil),
      'avg7Foil': serializer.toJson<double?>(avg7Foil),
      'avg30Foil': serializer.toJson<double?>(avg30Foil),
      'fetchedAt': serializer.toJson<int>(fetchedAt),
    };
  }

  Price copyWith({
    int? cardmarketId,
    Value<double?> avg = const Value.absent(),
    Value<double?> low = const Value.absent(),
    Value<double?> trend = const Value.absent(),
    Value<double?> avg1 = const Value.absent(),
    Value<double?> avg7 = const Value.absent(),
    Value<double?> avg30 = const Value.absent(),
    Value<double?> avgFoil = const Value.absent(),
    Value<double?> lowFoil = const Value.absent(),
    Value<double?> trendFoil = const Value.absent(),
    Value<double?> avg1Foil = const Value.absent(),
    Value<double?> avg7Foil = const Value.absent(),
    Value<double?> avg30Foil = const Value.absent(),
    int? fetchedAt,
  }) => Price(
    cardmarketId: cardmarketId ?? this.cardmarketId,
    avg: avg.present ? avg.value : this.avg,
    low: low.present ? low.value : this.low,
    trend: trend.present ? trend.value : this.trend,
    avg1: avg1.present ? avg1.value : this.avg1,
    avg7: avg7.present ? avg7.value : this.avg7,
    avg30: avg30.present ? avg30.value : this.avg30,
    avgFoil: avgFoil.present ? avgFoil.value : this.avgFoil,
    lowFoil: lowFoil.present ? lowFoil.value : this.lowFoil,
    trendFoil: trendFoil.present ? trendFoil.value : this.trendFoil,
    avg1Foil: avg1Foil.present ? avg1Foil.value : this.avg1Foil,
    avg7Foil: avg7Foil.present ? avg7Foil.value : this.avg7Foil,
    avg30Foil: avg30Foil.present ? avg30Foil.value : this.avg30Foil,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  Price copyWithCompanion(PricesCompanion data) {
    return Price(
      cardmarketId:
          data.cardmarketId.present
              ? data.cardmarketId.value
              : this.cardmarketId,
      avg: data.avg.present ? data.avg.value : this.avg,
      low: data.low.present ? data.low.value : this.low,
      trend: data.trend.present ? data.trend.value : this.trend,
      avg1: data.avg1.present ? data.avg1.value : this.avg1,
      avg7: data.avg7.present ? data.avg7.value : this.avg7,
      avg30: data.avg30.present ? data.avg30.value : this.avg30,
      avgFoil: data.avgFoil.present ? data.avgFoil.value : this.avgFoil,
      lowFoil: data.lowFoil.present ? data.lowFoil.value : this.lowFoil,
      trendFoil: data.trendFoil.present ? data.trendFoil.value : this.trendFoil,
      avg1Foil: data.avg1Foil.present ? data.avg1Foil.value : this.avg1Foil,
      avg7Foil: data.avg7Foil.present ? data.avg7Foil.value : this.avg7Foil,
      avg30Foil: data.avg30Foil.present ? data.avg30Foil.value : this.avg30Foil,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Price(')
          ..write('cardmarketId: $cardmarketId, ')
          ..write('avg: $avg, ')
          ..write('low: $low, ')
          ..write('trend: $trend, ')
          ..write('avg1: $avg1, ')
          ..write('avg7: $avg7, ')
          ..write('avg30: $avg30, ')
          ..write('avgFoil: $avgFoil, ')
          ..write('lowFoil: $lowFoil, ')
          ..write('trendFoil: $trendFoil, ')
          ..write('avg1Foil: $avg1Foil, ')
          ..write('avg7Foil: $avg7Foil, ')
          ..write('avg30Foil: $avg30Foil, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cardmarketId,
    avg,
    low,
    trend,
    avg1,
    avg7,
    avg30,
    avgFoil,
    lowFoil,
    trendFoil,
    avg1Foil,
    avg7Foil,
    avg30Foil,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Price &&
          other.cardmarketId == this.cardmarketId &&
          other.avg == this.avg &&
          other.low == this.low &&
          other.trend == this.trend &&
          other.avg1 == this.avg1 &&
          other.avg7 == this.avg7 &&
          other.avg30 == this.avg30 &&
          other.avgFoil == this.avgFoil &&
          other.lowFoil == this.lowFoil &&
          other.trendFoil == this.trendFoil &&
          other.avg1Foil == this.avg1Foil &&
          other.avg7Foil == this.avg7Foil &&
          other.avg30Foil == this.avg30Foil &&
          other.fetchedAt == this.fetchedAt);
}

class PricesCompanion extends UpdateCompanion<Price> {
  final Value<int> cardmarketId;
  final Value<double?> avg;
  final Value<double?> low;
  final Value<double?> trend;
  final Value<double?> avg1;
  final Value<double?> avg7;
  final Value<double?> avg30;
  final Value<double?> avgFoil;
  final Value<double?> lowFoil;
  final Value<double?> trendFoil;
  final Value<double?> avg1Foil;
  final Value<double?> avg7Foil;
  final Value<double?> avg30Foil;
  final Value<int> fetchedAt;
  const PricesCompanion({
    this.cardmarketId = const Value.absent(),
    this.avg = const Value.absent(),
    this.low = const Value.absent(),
    this.trend = const Value.absent(),
    this.avg1 = const Value.absent(),
    this.avg7 = const Value.absent(),
    this.avg30 = const Value.absent(),
    this.avgFoil = const Value.absent(),
    this.lowFoil = const Value.absent(),
    this.trendFoil = const Value.absent(),
    this.avg1Foil = const Value.absent(),
    this.avg7Foil = const Value.absent(),
    this.avg30Foil = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  PricesCompanion.insert({
    this.cardmarketId = const Value.absent(),
    this.avg = const Value.absent(),
    this.low = const Value.absent(),
    this.trend = const Value.absent(),
    this.avg1 = const Value.absent(),
    this.avg7 = const Value.absent(),
    this.avg30 = const Value.absent(),
    this.avgFoil = const Value.absent(),
    this.lowFoil = const Value.absent(),
    this.trendFoil = const Value.absent(),
    this.avg1Foil = const Value.absent(),
    this.avg7Foil = const Value.absent(),
    this.avg30Foil = const Value.absent(),
    required int fetchedAt,
  }) : fetchedAt = Value(fetchedAt);
  static Insertable<Price> custom({
    Expression<int>? cardmarketId,
    Expression<double>? avg,
    Expression<double>? low,
    Expression<double>? trend,
    Expression<double>? avg1,
    Expression<double>? avg7,
    Expression<double>? avg30,
    Expression<double>? avgFoil,
    Expression<double>? lowFoil,
    Expression<double>? trendFoil,
    Expression<double>? avg1Foil,
    Expression<double>? avg7Foil,
    Expression<double>? avg30Foil,
    Expression<int>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (cardmarketId != null) 'cardmarket_id': cardmarketId,
      if (avg != null) 'avg': avg,
      if (low != null) 'low': low,
      if (trend != null) 'trend': trend,
      if (avg1 != null) 'avg1': avg1,
      if (avg7 != null) 'avg7': avg7,
      if (avg30 != null) 'avg30': avg30,
      if (avgFoil != null) 'avg_foil': avgFoil,
      if (lowFoil != null) 'low_foil': lowFoil,
      if (trendFoil != null) 'trend_foil': trendFoil,
      if (avg1Foil != null) 'avg1_foil': avg1Foil,
      if (avg7Foil != null) 'avg7_foil': avg7Foil,
      if (avg30Foil != null) 'avg30_foil': avg30Foil,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  PricesCompanion copyWith({
    Value<int>? cardmarketId,
    Value<double?>? avg,
    Value<double?>? low,
    Value<double?>? trend,
    Value<double?>? avg1,
    Value<double?>? avg7,
    Value<double?>? avg30,
    Value<double?>? avgFoil,
    Value<double?>? lowFoil,
    Value<double?>? trendFoil,
    Value<double?>? avg1Foil,
    Value<double?>? avg7Foil,
    Value<double?>? avg30Foil,
    Value<int>? fetchedAt,
  }) {
    return PricesCompanion(
      cardmarketId: cardmarketId ?? this.cardmarketId,
      avg: avg ?? this.avg,
      low: low ?? this.low,
      trend: trend ?? this.trend,
      avg1: avg1 ?? this.avg1,
      avg7: avg7 ?? this.avg7,
      avg30: avg30 ?? this.avg30,
      avgFoil: avgFoil ?? this.avgFoil,
      lowFoil: lowFoil ?? this.lowFoil,
      trendFoil: trendFoil ?? this.trendFoil,
      avg1Foil: avg1Foil ?? this.avg1Foil,
      avg7Foil: avg7Foil ?? this.avg7Foil,
      avg30Foil: avg30Foil ?? this.avg30Foil,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardmarketId.present) {
      map['cardmarket_id'] = Variable<int>(cardmarketId.value);
    }
    if (avg.present) {
      map['avg'] = Variable<double>(avg.value);
    }
    if (low.present) {
      map['low'] = Variable<double>(low.value);
    }
    if (trend.present) {
      map['trend'] = Variable<double>(trend.value);
    }
    if (avg1.present) {
      map['avg1'] = Variable<double>(avg1.value);
    }
    if (avg7.present) {
      map['avg7'] = Variable<double>(avg7.value);
    }
    if (avg30.present) {
      map['avg30'] = Variable<double>(avg30.value);
    }
    if (avgFoil.present) {
      map['avg_foil'] = Variable<double>(avgFoil.value);
    }
    if (lowFoil.present) {
      map['low_foil'] = Variable<double>(lowFoil.value);
    }
    if (trendFoil.present) {
      map['trend_foil'] = Variable<double>(trendFoil.value);
    }
    if (avg1Foil.present) {
      map['avg1_foil'] = Variable<double>(avg1Foil.value);
    }
    if (avg7Foil.present) {
      map['avg7_foil'] = Variable<double>(avg7Foil.value);
    }
    if (avg30Foil.present) {
      map['avg30_foil'] = Variable<double>(avg30Foil.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricesCompanion(')
          ..write('cardmarketId: $cardmarketId, ')
          ..write('avg: $avg, ')
          ..write('low: $low, ')
          ..write('trend: $trend, ')
          ..write('avg1: $avg1, ')
          ..write('avg7: $avg7, ')
          ..write('avg30: $avg30, ')
          ..write('avgFoil: $avgFoil, ')
          ..write('lowFoil: $lowFoil, ')
          ..write('trendFoil: $trendFoil, ')
          ..write('avg1Foil: $avg1Foil, ')
          ..write('avg7Foil: $avg7Foil, ')
          ..write('avg30Foil: $avg30Foil, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $CollectionEntriesTable collectionEntries =
      $CollectionEntriesTable(this);
  late final $PricesTable prices = $PricesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final CardsDao cardsDao = CardsDao(this as AppDatabase);
  late final CollectionDao collectionDao = CollectionDao(this as AppDatabase);
  late final PricesDao pricesDao = PricesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cards,
    collectionEntries,
    prices,
    settings,
  ];
}

typedef $$CardsTableCreateCompanionBuilder =
    CardsCompanion Function({
      Value<int> id,
      required String setCode,
      required int number,
      Value<String> language,
      required String simpleName,
      required String fullName,
      required String searchName,
      required String rarity,
      required String type,
      required String story,
      Value<String> ink,
      Value<String> inksJson,
      required int cost,
      required bool inkwell,
      Value<String?> promoGrouping,
      Value<String> foilTypesJson,
      Value<String> imagesJson,
      Value<String> externalLinksJson,
      Value<int?> cardmarketId,
    });
typedef $$CardsTableUpdateCompanionBuilder =
    CardsCompanion Function({
      Value<int> id,
      Value<String> setCode,
      Value<int> number,
      Value<String> language,
      Value<String> simpleName,
      Value<String> fullName,
      Value<String> searchName,
      Value<String> rarity,
      Value<String> type,
      Value<String> story,
      Value<String> ink,
      Value<String> inksJson,
      Value<int> cost,
      Value<bool> inkwell,
      Value<String?> promoGrouping,
      Value<String> foilTypesJson,
      Value<String> imagesJson,
      Value<String> externalLinksJson,
      Value<int?> cardmarketId,
    });

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get simpleName => $composableBuilder(
    column: $table.simpleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchName => $composableBuilder(
    column: $table.searchName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ink => $composableBuilder(
    column: $table.ink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inksJson => $composableBuilder(
    column: $table.inksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inkwell => $composableBuilder(
    column: $table.inkwell,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promoGrouping => $composableBuilder(
    column: $table.promoGrouping,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foilTypesJson => $composableBuilder(
    column: $table.foilTypesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalLinksJson => $composableBuilder(
    column: $table.externalLinksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardmarketId => $composableBuilder(
    column: $table.cardmarketId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get simpleName => $composableBuilder(
    column: $table.simpleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchName => $composableBuilder(
    column: $table.searchName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ink => $composableBuilder(
    column: $table.ink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inksJson => $composableBuilder(
    column: $table.inksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inkwell => $composableBuilder(
    column: $table.inkwell,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promoGrouping => $composableBuilder(
    column: $table.promoGrouping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foilTypesJson => $composableBuilder(
    column: $table.foilTypesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalLinksJson => $composableBuilder(
    column: $table.externalLinksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardmarketId => $composableBuilder(
    column: $table.cardmarketId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get simpleName => $composableBuilder(
    column: $table.simpleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get searchName => $composableBuilder(
    column: $table.searchName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get story =>
      $composableBuilder(column: $table.story, builder: (column) => column);

  GeneratedColumn<String> get ink =>
      $composableBuilder(column: $table.ink, builder: (column) => column);

  GeneratedColumn<String> get inksJson =>
      $composableBuilder(column: $table.inksJson, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<bool> get inkwell =>
      $composableBuilder(column: $table.inkwell, builder: (column) => column);

  GeneratedColumn<String> get promoGrouping => $composableBuilder(
    column: $table.promoGrouping,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foilTypesJson => $composableBuilder(
    column: $table.foilTypesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalLinksJson => $composableBuilder(
    column: $table.externalLinksJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cardmarketId => $composableBuilder(
    column: $table.cardmarketId,
    builder: (column) => column,
  );
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          Card,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
          Card,
          PrefetchHooks Function()
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> setCode = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> simpleName = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> searchName = const Value.absent(),
                Value<String> rarity = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> story = const Value.absent(),
                Value<String> ink = const Value.absent(),
                Value<String> inksJson = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<bool> inkwell = const Value.absent(),
                Value<String?> promoGrouping = const Value.absent(),
                Value<String> foilTypesJson = const Value.absent(),
                Value<String> imagesJson = const Value.absent(),
                Value<String> externalLinksJson = const Value.absent(),
                Value<int?> cardmarketId = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                setCode: setCode,
                number: number,
                language: language,
                simpleName: simpleName,
                fullName: fullName,
                searchName: searchName,
                rarity: rarity,
                type: type,
                story: story,
                ink: ink,
                inksJson: inksJson,
                cost: cost,
                inkwell: inkwell,
                promoGrouping: promoGrouping,
                foilTypesJson: foilTypesJson,
                imagesJson: imagesJson,
                externalLinksJson: externalLinksJson,
                cardmarketId: cardmarketId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String setCode,
                required int number,
                Value<String> language = const Value.absent(),
                required String simpleName,
                required String fullName,
                required String searchName,
                required String rarity,
                required String type,
                required String story,
                Value<String> ink = const Value.absent(),
                Value<String> inksJson = const Value.absent(),
                required int cost,
                required bool inkwell,
                Value<String?> promoGrouping = const Value.absent(),
                Value<String> foilTypesJson = const Value.absent(),
                Value<String> imagesJson = const Value.absent(),
                Value<String> externalLinksJson = const Value.absent(),
                Value<int?> cardmarketId = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                setCode: setCode,
                number: number,
                language: language,
                simpleName: simpleName,
                fullName: fullName,
                searchName: searchName,
                rarity: rarity,
                type: type,
                story: story,
                ink: ink,
                inksJson: inksJson,
                cost: cost,
                inkwell: inkwell,
                promoGrouping: promoGrouping,
                foilTypesJson: foilTypesJson,
                imagesJson: imagesJson,
                externalLinksJson: externalLinksJson,
                cardmarketId: cardmarketId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      Card,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
      Card,
      PrefetchHooks Function()
    >;
typedef $$CollectionEntriesTableCreateCompanionBuilder =
    CollectionEntriesCompanion Function({
      Value<int> cardId,
      Value<int> amount,
      Value<int> amountFoil,
      required int updatedAt,
    });
typedef $$CollectionEntriesTableUpdateCompanionBuilder =
    CollectionEntriesCompanion Function({
      Value<int> cardId,
      Value<int> amount,
      Value<int> amountFoil,
      Value<int> updatedAt,
    });

class $$CollectionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionEntriesTable> {
  $$CollectionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountFoil => $composableBuilder(
    column: $table.amountFoil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CollectionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionEntriesTable> {
  $$CollectionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountFoil => $composableBuilder(
    column: $table.amountFoil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionEntriesTable> {
  $$CollectionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get amountFoil => $composableBuilder(
    column: $table.amountFoil,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CollectionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionEntriesTable,
          CollectionEntry,
          $$CollectionEntriesTableFilterComposer,
          $$CollectionEntriesTableOrderingComposer,
          $$CollectionEntriesTableAnnotationComposer,
          $$CollectionEntriesTableCreateCompanionBuilder,
          $$CollectionEntriesTableUpdateCompanionBuilder,
          (
            CollectionEntry,
            BaseReferences<
              _$AppDatabase,
              $CollectionEntriesTable,
              CollectionEntry
            >,
          ),
          CollectionEntry,
          PrefetchHooks Function()
        > {
  $$CollectionEntriesTableTableManager(
    _$AppDatabase db,
    $CollectionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CollectionEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$CollectionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CollectionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> cardId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> amountFoil = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => CollectionEntriesCompanion(
                cardId: cardId,
                amount: amount,
                amountFoil: amountFoil,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> cardId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> amountFoil = const Value.absent(),
                required int updatedAt,
              }) => CollectionEntriesCompanion.insert(
                cardId: cardId,
                amount: amount,
                amountFoil: amountFoil,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollectionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionEntriesTable,
      CollectionEntry,
      $$CollectionEntriesTableFilterComposer,
      $$CollectionEntriesTableOrderingComposer,
      $$CollectionEntriesTableAnnotationComposer,
      $$CollectionEntriesTableCreateCompanionBuilder,
      $$CollectionEntriesTableUpdateCompanionBuilder,
      (
        CollectionEntry,
        BaseReferences<_$AppDatabase, $CollectionEntriesTable, CollectionEntry>,
      ),
      CollectionEntry,
      PrefetchHooks Function()
    >;
typedef $$PricesTableCreateCompanionBuilder =
    PricesCompanion Function({
      Value<int> cardmarketId,
      Value<double?> avg,
      Value<double?> low,
      Value<double?> trend,
      Value<double?> avg1,
      Value<double?> avg7,
      Value<double?> avg30,
      Value<double?> avgFoil,
      Value<double?> lowFoil,
      Value<double?> trendFoil,
      Value<double?> avg1Foil,
      Value<double?> avg7Foil,
      Value<double?> avg30Foil,
      required int fetchedAt,
    });
typedef $$PricesTableUpdateCompanionBuilder =
    PricesCompanion Function({
      Value<int> cardmarketId,
      Value<double?> avg,
      Value<double?> low,
      Value<double?> trend,
      Value<double?> avg1,
      Value<double?> avg7,
      Value<double?> avg30,
      Value<double?> avgFoil,
      Value<double?> lowFoil,
      Value<double?> trendFoil,
      Value<double?> avg1Foil,
      Value<double?> avg7Foil,
      Value<double?> avg30Foil,
      Value<int> fetchedAt,
    });

class $$PricesTableFilterComposer
    extends Composer<_$AppDatabase, $PricesTable> {
  $$PricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cardmarketId => $composableBuilder(
    column: $table.cardmarketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg => $composableBuilder(
    column: $table.avg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get low => $composableBuilder(
    column: $table.low,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get trend => $composableBuilder(
    column: $table.trend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg1 => $composableBuilder(
    column: $table.avg1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg7 => $composableBuilder(
    column: $table.avg7,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg30 => $composableBuilder(
    column: $table.avg30,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgFoil => $composableBuilder(
    column: $table.avgFoil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowFoil => $composableBuilder(
    column: $table.lowFoil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get trendFoil => $composableBuilder(
    column: $table.trendFoil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg1Foil => $composableBuilder(
    column: $table.avg1Foil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg7Foil => $composableBuilder(
    column: $table.avg7Foil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avg30Foil => $composableBuilder(
    column: $table.avg30Foil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PricesTableOrderingComposer
    extends Composer<_$AppDatabase, $PricesTable> {
  $$PricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cardmarketId => $composableBuilder(
    column: $table.cardmarketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg => $composableBuilder(
    column: $table.avg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get low => $composableBuilder(
    column: $table.low,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trend => $composableBuilder(
    column: $table.trend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg1 => $composableBuilder(
    column: $table.avg1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg7 => $composableBuilder(
    column: $table.avg7,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg30 => $composableBuilder(
    column: $table.avg30,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgFoil => $composableBuilder(
    column: $table.avgFoil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowFoil => $composableBuilder(
    column: $table.lowFoil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trendFoil => $composableBuilder(
    column: $table.trendFoil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg1Foil => $composableBuilder(
    column: $table.avg1Foil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg7Foil => $composableBuilder(
    column: $table.avg7Foil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avg30Foil => $composableBuilder(
    column: $table.avg30Foil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PricesTable> {
  $$PricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cardmarketId => $composableBuilder(
    column: $table.cardmarketId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avg =>
      $composableBuilder(column: $table.avg, builder: (column) => column);

  GeneratedColumn<double> get low =>
      $composableBuilder(column: $table.low, builder: (column) => column);

  GeneratedColumn<double> get trend =>
      $composableBuilder(column: $table.trend, builder: (column) => column);

  GeneratedColumn<double> get avg1 =>
      $composableBuilder(column: $table.avg1, builder: (column) => column);

  GeneratedColumn<double> get avg7 =>
      $composableBuilder(column: $table.avg7, builder: (column) => column);

  GeneratedColumn<double> get avg30 =>
      $composableBuilder(column: $table.avg30, builder: (column) => column);

  GeneratedColumn<double> get avgFoil =>
      $composableBuilder(column: $table.avgFoil, builder: (column) => column);

  GeneratedColumn<double> get lowFoil =>
      $composableBuilder(column: $table.lowFoil, builder: (column) => column);

  GeneratedColumn<double> get trendFoil =>
      $composableBuilder(column: $table.trendFoil, builder: (column) => column);

  GeneratedColumn<double> get avg1Foil =>
      $composableBuilder(column: $table.avg1Foil, builder: (column) => column);

  GeneratedColumn<double> get avg7Foil =>
      $composableBuilder(column: $table.avg7Foil, builder: (column) => column);

  GeneratedColumn<double> get avg30Foil =>
      $composableBuilder(column: $table.avg30Foil, builder: (column) => column);

  GeneratedColumn<int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$PricesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PricesTable,
          Price,
          $$PricesTableFilterComposer,
          $$PricesTableOrderingComposer,
          $$PricesTableAnnotationComposer,
          $$PricesTableCreateCompanionBuilder,
          $$PricesTableUpdateCompanionBuilder,
          (Price, BaseReferences<_$AppDatabase, $PricesTable, Price>),
          Price,
          PrefetchHooks Function()
        > {
  $$PricesTableTableManager(_$AppDatabase db, $PricesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> cardmarketId = const Value.absent(),
                Value<double?> avg = const Value.absent(),
                Value<double?> low = const Value.absent(),
                Value<double?> trend = const Value.absent(),
                Value<double?> avg1 = const Value.absent(),
                Value<double?> avg7 = const Value.absent(),
                Value<double?> avg30 = const Value.absent(),
                Value<double?> avgFoil = const Value.absent(),
                Value<double?> lowFoil = const Value.absent(),
                Value<double?> trendFoil = const Value.absent(),
                Value<double?> avg1Foil = const Value.absent(),
                Value<double?> avg7Foil = const Value.absent(),
                Value<double?> avg30Foil = const Value.absent(),
                Value<int> fetchedAt = const Value.absent(),
              }) => PricesCompanion(
                cardmarketId: cardmarketId,
                avg: avg,
                low: low,
                trend: trend,
                avg1: avg1,
                avg7: avg7,
                avg30: avg30,
                avgFoil: avgFoil,
                lowFoil: lowFoil,
                trendFoil: trendFoil,
                avg1Foil: avg1Foil,
                avg7Foil: avg7Foil,
                avg30Foil: avg30Foil,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> cardmarketId = const Value.absent(),
                Value<double?> avg = const Value.absent(),
                Value<double?> low = const Value.absent(),
                Value<double?> trend = const Value.absent(),
                Value<double?> avg1 = const Value.absent(),
                Value<double?> avg7 = const Value.absent(),
                Value<double?> avg30 = const Value.absent(),
                Value<double?> avgFoil = const Value.absent(),
                Value<double?> lowFoil = const Value.absent(),
                Value<double?> trendFoil = const Value.absent(),
                Value<double?> avg1Foil = const Value.absent(),
                Value<double?> avg7Foil = const Value.absent(),
                Value<double?> avg30Foil = const Value.absent(),
                required int fetchedAt,
              }) => PricesCompanion.insert(
                cardmarketId: cardmarketId,
                avg: avg,
                low: low,
                trend: trend,
                avg1: avg1,
                avg7: avg7,
                avg30: avg30,
                avgFoil: avgFoil,
                lowFoil: lowFoil,
                trendFoil: trendFoil,
                avg1Foil: avg1Foil,
                avg7Foil: avg7Foil,
                avg30Foil: avg30Foil,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PricesTable,
      Price,
      $$PricesTableFilterComposer,
      $$PricesTableOrderingComposer,
      $$PricesTableAnnotationComposer,
      $$PricesTableCreateCompanionBuilder,
      $$PricesTableUpdateCompanionBuilder,
      (Price, BaseReferences<_$AppDatabase, $PricesTable, Price>),
      Price,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$CollectionEntriesTableTableManager get collectionEntries =>
      $$CollectionEntriesTableTableManager(_db, _db.collectionEntries);
  $$PricesTableTableManager get prices =>
      $$PricesTableTableManager(_db, _db.prices);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
