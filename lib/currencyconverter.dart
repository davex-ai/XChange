import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController textEditingController = TextEditingController();
  double result = 0;
  String fromCurrency = "USD";
  String toCurrency = "NGN";


  List<String> currencyList = [
    "USD", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG",
    "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB",
    "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLF",
    "CLP", "CNH", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK",
    "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP",
    "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL",
    "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK",
    "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", "KRW",
    "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD",
    "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK",
    "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR",
    "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD",
    "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE",
    "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL", "THB", "TJS", "TMT",
    "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "UYU",
    "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XCG", "XDR", "XOF",
    "XPF", "YER", "ZAR", "ZMW", "ZWG", "ZWL"
  ];

  Map<String, String> currencyWithSymbols = {
    "USD": r"$", "AED": "د.إ", "AFN": "؋", "ALL": "L", "AMD": "֏", "ANG": "ƒ",
    "AOA": "Kz", "ARS": r"$", "AUD": r"$", "AWG": "ƒ", "AZN": "₼", "BAM": "KM",
    "BBD": r"$", "BDT": "৳", "BGN": "лв", "BHD": ".د.ب", "BIF": "FBu", "BMD": r"$",
    "BND": r"$", "BOB": "Bs.", "BRL": r"R$", "BSD": r"$", "BTN": "Nu.", "BWP": "P",
    "BYN": "Br", "BZD": r"BZ$", "CAD": r"$", "CDF": "FC", "CHF": "CHF", "CLF": "UF",
    "CLP": r"$", "CNH": "元", "CNY": "¥", "COP": r"$", "CRC": "₡", "CUP": r"$",
    "CVE": "Esc", "CZK": "Kč", "DJF": "Fdj", "DKK": "kr", "DOP": r"RD$", "DZD": "د.ج",
    "EGP": "E£", "ERN": "Nfk", "ETB": "Br", "EUR": "€", "FJD": r"$", "FKP": "£",
    "FOK": r"$", "GBP": "£", "GEL": "₾", "GGP": "£", "GHS": "GH₵", "GIP": "£",
    "GMD": "D", "GNF": "FG", "GTQ": "Q", "GYD": r"$", "HKD": r"$", "HNL": "L",
    "HRK": "kn", "HTG": "G", "HUF": "Ft", "IDR": "Rp", "ILS": "₪", "IMP": "£",
    "INR": "₹", "IQD": "ع.د", "IRR": "﷼", "ISK": "kr", "JEP": "£", "JMD": r"J$",
    "JOD": "د.ا", "JPY": "¥", "KES": "KSh", "KGS": "с", "KHR": "៛", "KID": r"$",
    "KMF": "CF", "KRW": "₩", "KWD": "د.ك", "KYD": r"$", "KZT": "₸", "LAK": "₭",
    "LBP": "ل.ل", "LKR": "₨", "LRD": r"$", "LSL": "L", "LYD": "ل.د", "MAD": "د.م.",
    "MDL": "L", "MGA": "Ar", "MKD": "ден", "MMK": "K", "MNT": "₮", "MOP": "P",
    "MRU": "UM", "MUR": "₨", "MVR": "Rf", "MWK": "MK", "MXN": r"$", "MYR": "RM",
    "MZN": "MT", "NAD": r"$", "NGN": "₦", "NIO": r"C$", "NOK": "kr", "NPR": "₨",
    "NZD": r"$", "OMR": "ر.ع.", "PAB": "B/.", "PEN": "S/.", "PGK": "K", "PHP": "₱",
    "PKR": "₨", "PLN": "zł", "PYG": "₲", "QAR": "ر.ق", "RON": "lei", "RSD": "дин.",
    "RUB": "₽", "RWF": "FRw", "SAR": "ر.س", "SBD": r"$", "SCR": "₨", "SDG": "ج.س.",
    "SEK": "kr", "SGD": r"$", "SHP": "£", "SLE": "Le", "SLL": "Le", "SOS": "S",
    "SRD": r"$", "SSP": "£", "STN": "Db", "SYP": "£", "SZL": "L", "THB": "฿",
    "TJS": "SM", "TMT": "T", "TND": "د.ت", "TOP": r"T$", "TRY": "₺", "TTD": r"TT$",
    "TVD": r"$", "TWD": r"NT$", "TZS": "TSh", "UAH": "₴", "UGX": "USh", "UYU": r"$",
    "UZS": "лв", "VES": "Bs.S", "VND": "₫", "VUV": "VT", "WST": "T", "XAF": "FCFA",
    "XCD": r"$", "XCG": "C", "XDR": "SDR", "XOF": "CFA", "XPF": "₣", "YER": "﷼",
    "ZAR": "R", "ZMW": "ZK", "ZWG": "ZiG", "ZWL": "ZiG"
  };



  String mapfunc(String code) {
    return currencyWithSymbols[code] ?? "\$";
  }


  Future<double> fetchRate(String toCurrency) async {
    final response = await http.get(
      Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['rates'] == null || data['rates'][toCurrency] == null) {
        throw Exception('Currency not supported');
      }

      return (data['rates'][toCurrency] as num).toDouble();
    } else {
      throw Exception('Failed to fetch rates');
    }
  }

  void convert() async {
    final input = double.parse(textEditingController.text.trim());
    final rate = await fetchRate(toCurrency);

    if (input.isNaN) return;

    setState(() {
      result = input * rate;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final border = OutlineInputBorder(
      borderSide: const BorderSide(width: 2.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(5),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text("XChange", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result != 0
                  ? result.toStringAsFixed(2)
                  : result.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter amount in $fromCurrency',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: Center(
                    widthFactor: 0.8,
                    child: Text(
                      mapfunc(fromCurrency),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsetsGeometry.all(10),
                  child: DropdownButton<String>(
                    value: fromCurrency,
                    items: currencyList.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        fromCurrency = newValue!;
                      });
                    },
                  ),

                ),
                Padding(
                  padding: const EdgeInsetsGeometry.all(10),
                  child: DropdownButton<String>(
                    value: toCurrency,
                    items: currencyList.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        toCurrency = newValue!;
                      });
                    },
                  ),

                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsGeometry.all(10),
              child: TextButton(
                onPressed: convert,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Convert'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
