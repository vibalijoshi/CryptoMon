import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker IOSpicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.0,
        title: Text(
          'Crypto💲Mon',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.tealAccent[400],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Expanded(
            child: CryptoCard(
              cryptoCurrency: 'BTC',
              value: isWaiting ? '?' : coinValues['BTC'],
              selectedCurrency: selectedCurrency,
            ),
          ),
          Expanded(
            child: CryptoCard(
              cryptoCurrency: 'ETH',
              value: isWaiting ? '?' : coinValues['ETH'],
              selectedCurrency: selectedCurrency,
            ),
          ),
          Expanded(
            child: CryptoCard(
              cryptoCurrency: 'LTC',
              value: isWaiting ? '?' : coinValues['LTC'],
              selectedCurrency: selectedCurrency,
            ),
          ),
          SizedBox(height: 80.0),
          Expanded(
            child: Container(
              height: 30.0,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(top: 30, bottom: 30.0),
              color: Colors.tealAccent[400],
              child: Platform.isIOS ? IOSpicker() : androidPicker(),
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    @required this.cryptoCurrency,
    @required this.selectedCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.tealAccent[400],
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Row(
            children: <Widget>[
              Image(
                height: 50.0,
                width: 50.0,
                image: AssetImage('assets/$cryptoCurrency.png'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $cryptoCurrency = $value $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
//
