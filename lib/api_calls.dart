///
///1st: entered target currency will be stored in a variable and its value
///2nd: entered value of base currency will also be stored
///3rd: then multiplied and data will show in a container

//class to make objects from api data
class ExchangeRates {
  final String result;
  final String documentation;
  final String timeLastUpdate;
  final String baseCode;
  final List<Conversion> conversion;

  const ExchangeRates(
      {required this.result,
      required this.documentation,
      required this.timeLastUpdate,
      required this.baseCode,
      required this.conversion});

  factory ExchangeRates.fromJson(Map<String, dynamic> map) {
    return ExchangeRates(
        result: map["result"],
        documentation: map["documentation"],
        timeLastUpdate: map["time_last_update_utc"],
        baseCode: map["base_code"], //Conversion.fromJson()
        conversion: (map["conversion_rates"])
            .entries
            .map<Conversion>((e) => Conversion.fromJson(e.key, e.value))
            .toList());
  }
}

//a class to deal map data in the api data
class Conversion {
  final String code;
  final num value;

  const Conversion({required this.code, required this.value});

  factory Conversion.fromJson(String kkey, num vvalue) {
    return Conversion(code: kkey, value: vvalue);
  }
}































//class to make objects from api data
// class ExchangeRates {
//   final String result;
//   final String imageURL;
//   final String timeLastUpdate;
//   final String baseCode;
//   final List<Conversion> conversion;

//   const ExchangeRates(
//       {required this.result,
//       required this.imageURL,
//       required this.timeLastUpdate,
//       required this.baseCode,
//       required this.conversion});

//   factory ExchangeRates.fromJson() {
//     return ExchangeRates(
//         result: "Success",
//         imageURL:
//             "https://img.freepik.com/free-vector/illustration-usa-flag_53876-18165.jpg?w=826&t=st=1709193088~exp=1709193688~hmac=af023f594cc5277973615956eef02d53d4bdd75cbbdfc592640aed46533975f0",
//         timeLastUpdate: "Now",
//         baseCode: "PKR", //Conversion.fromJson()
//         conversion: [Conversion.fromJson("USD", 300),
//         Conversion.fromJson("GBP", 380),
//         Conversion.fromJson("AUS", 220),
//         Conversion.fromJson("YEN", 180),
//         Conversion.fromJson("EUR", 303),
//         ]);
//   }
// }

// //a class to deal map data in the api data
// class Conversion {
//   final String key;
//   final num value;

//   const Conversion({required this.key, required this.value});

//   factory Conversion.fromJson(String kkey, num vvalue) {
//     return Conversion(key: kkey, value: vvalue);
//   }
// }
