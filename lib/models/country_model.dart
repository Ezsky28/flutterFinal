class Country {
  String? flagPng;
  String? nameCommon;
  String? nameOfficial;
  String? region;
  String? subregion;
  double? area;
  int? population;
  String? continents;

  Country({
    this.flagPng,
    this.nameCommon,
    this.nameOfficial,
    this.region,
    this.subregion,
    this.area,
    this.population,
    this.continents,
  });

  Country.fromJsonList(Map<String, dynamic> json) {
    flagPng = json["flags"]["png"];
    nameCommon = json["name"]["common"];
    nameOfficial = json["name"]["official"];
    region = json["region"];
    subregion = json["subregion"] ?? 'No Subregion';
    area = json["area"];
    population = json["population"];
    continents = json["continents"][0];
  }
}
