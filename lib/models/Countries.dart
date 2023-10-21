class Country {
    var code;
    var name;
    List<CountryState>? states;

    Country({this.code, this.name, this.states});

    factory Country.fromJson(Map<String, dynamic> json) {
        return Country(
            code: json['code'],
            name: json['name'],
            states: json['states'] != null ? (json['states'] as List).map((i) => CountryState.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['code'] = this.code;
        data['name'] = this.name;
        if (this.states != null) {
            data['states'] = this.states!.map((v) => v.toJson()).toList();
        }

        return data;
    }
}

class CountryState {
    var code;
    var name;

    CountryState({this.code, this.name});

    factory CountryState.fromJson(Map<String, dynamic> json) {
        return CountryState(
            code: json['code'],
            name: json['name'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['code'] = this.code;
        data['name'] = this.name;
        return data;
    }
}
