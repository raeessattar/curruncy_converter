import 'dart:convert';

import 'package:exchange_rate_app/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  ExchangeRates? exchangeRates;
  String? arg;
  void fetchData(String value) async {
    final response = await http.get(Uri.parse(
        'https://v6.exchangerate-api.com//v6/0a9a46f3bcd3746201b7c7ed/latest/$value'));
    //returning data
    exchangeRates = ExchangeRates.fromJson(jsonDecode(response.body));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        arg = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'USD';
      });
      fetchData(arg!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('List '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Text('Base Currency: $arg', style: const TextStyle(fontSize: 20)),
            if (exchangeRates == null)
              const Text(
                'Data is loading',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            else
              Expanded(
                child: ListView.builder(
                    itemCount:
                        exchangeRates!.conversion.length, //length of object,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ListTile(
                        // leading: Container(
                        //   width: 30,
                        //   height: 30,
                        //   child: Image.network(
                        //       'https://img.freepik.com/free-vector/illustration-usa-flag_53876-18165.jpg?w=826&t=st=1709193088~exp=1709193688~hmac=af023f594cc5277973615956eef02d53d4bdd75cbbdfc592640aed46533975f0'),
                        // ),
                        title: Text(
                          exchangeRates!.conversion[index].code,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '${exchangeRates!.conversion[index].value}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                      );
                    }),
              )
          ],
        ),
      ),
    );
  }
}
