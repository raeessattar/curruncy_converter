import 'package:exchange_rate_app/api_calls.dart';
import 'package:exchange_rate_app/show_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? apiKey;
const String baseCurrencyIconHint = 'Base Currency';
const String targetCurrencyIconHint = 'Target Currency';
void main() async {
  await dotenv.load(fileName: ".env");
  apiKey = dotenv.env["API_KEY"];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Currency Converter'),
        '/second': (context) => const ShowList()
      },
      title: 'Currency Converter App',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light, seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, seedColor: Colors.blueGrey),
      ),
      themeMode: ThemeMode.light,
      //home: const MyHomePage(title: "Currency Converter"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //fetching the api data
  ExchangeRates? exchangeRatesList;
  Conversion? base;
  Conversion? target;
  double? enteredValue;
  double? convertedValue;
  final myController = TextEditingController();
  void fetchList() async {
    final response = await http.get(
        Uri.parse('https://v6.exchangerate-api.com//v6/$apiKey/latest/USD'));
    //returning data
    exchangeRatesList = ExchangeRates.fromJson(jsonDecode(response.body));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (exchangeRatesList == null)
              const Text(
                'Loading..',
              )
            else ...[
              DropdownButton<Conversion>(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: base,
                hint: const Text(baseCurrencyIconHint),
                items: exchangeRatesList!.conversion
                    .map<DropdownMenuItem<Conversion>>((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.code),
                        ))
                    .toList(),
                onChanged: (Conversion? currency) {
                  base = currency;
                  setState(() {});
                },
              ),
              const Icon(Icons.currency_exchange),
              DropdownButton<Conversion>(
                value: target,
                hint: const Text(targetCurrencyIconHint),
                items: exchangeRatesList!.conversion
                    .map<DropdownMenuItem<Conversion>>((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.code),
                        ))
                    .toList(),
                onChanged: (Conversion? currency) {
                  target = currency!;
                  setState(() {});
                },
              ),
            ]
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Value',
                  ),
                  controller: myController,
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Convert'),
              onPressed: () {
                enteredValue = double.parse(myController.text);
                convertedValue = enteredValue! * (target!.value).toDouble();
                setState(() {});
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                      child: Text(convertedValue?.toStringAsFixed(2) ?? '')),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          child: const Text('See Exchange Rates'),
          onPressed: () {
            Navigator.pushNamed(context, '/second', arguments: base?.code);
            setState(() {});
          },
        ),
      ]),
    );
  }
}
