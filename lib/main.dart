import 'dart:convert';
import 'dart:math';
import 'package:expenses/Components/chart.dart';
import 'package:expenses/Components/transaction_form.dart';
import 'package:expenses/Components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({super.key});
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); Serve para a app apenas ficar numa posição

    return MaterialApp(
      home: const MyHomePage(),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.lime,
        ),
        textTheme: theme.textTheme.copyWith(
          headlineMedium: const TextStyle(
            fontFamily: "Lora",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: "Lora", fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [];
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsList = prefs.getStringList("transactions") ?? [];
    setState(() {
      _transaction.clear();
      _transaction.addAll(
        transactionsList
            .map((trJson) => Transaction.fromJson(json.decode(trJson))),
      );
    });
  }

  List<Transaction> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) async {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    final prefs = await SharedPreferences.getInstance();
    final transactionsList = prefs.getStringList("transactions") ?? [];
    transactionsList.add(json.encode(newTransaction.toJson()));
    await prefs.setStringList("transactions", transactionsList);

    setState(() {
      _transaction.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = prefs.getStringList("transactions") ?? [];
    transactions.removeWhere((trJson) {
      final transaction = json.decode(trJson);
      return transaction.id == id;
    });
    await prefs.setStringList("transactions", transactions);
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      backgroundColor: const Color.fromARGB(255, 197, 153, 205),
      centerTitle: true,
      title: const Text("Personal Expenses"),
      actions: [
        IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
            icon: Icon(_showChart ? Icons.list : Icons.show_chart))
      ],
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // if (isLandscape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text("Graphic"),
            //       Switch(
            //           value: _showChart,
            //           onChanged: (value) {
            //             setState(() {
            //               _showChart = value;
            //             });
            //           }),
            //     ],
            //   ),
            if (_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.6 : 0.25),
                child: Chart(
                  _recentTransactions,
                ),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * 0.75,
                child: TransactionList(_transaction, _deleteTransaction),
              ), //comunicação direta - passo já os dados
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
