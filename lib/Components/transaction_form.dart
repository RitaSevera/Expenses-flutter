import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate!);
  }

  _showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(fontFamily: "Lora"),
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: _valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                    labelStyle: TextStyle(fontFamily: "Lora"),
                    labelText: "Value €"),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat("dd/MM/y").format(_selectedDate!),
                        style: const TextStyle(fontFamily: "Lora"),
                      ),
                    ),
                    TextButton(
                      onPressed: _showDate,
                      child: const Text(
                        "Select a date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: "Lora"),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: _submitForm,
                child: const Text(
                  "New transaction",
                  style: TextStyle(
                      color: Color.fromARGB(255, 180, 122, 165),
                      fontFamily: "Lora-bold"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
