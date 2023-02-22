import "package:flutter/material.dart";
import 'package:money_tracker/CategoryDatabase.dart';
import 'package:money_tracker/CustomWidgets/MyAlertDialog.dart';
import 'package:money_tracker/CustomWidgets/MyTextButton.dart';
import 'package:money_tracker/CustomWidgets/MyTextField.dart';
import 'package:money_tracker/CustomWidgets/NormalPageLayoutWidget.dart';

Category? currentDropdown;

class AddExpenseWidget extends StatefulWidget {
  AddExpenseWidget({Key? key}) : super(key: key);
  final GlobalKey<MyDropdownButtonState> _key = GlobalKey();

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String amount = "";
  String note = "";

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentDropdown = null;
    return NormalPageLayoutWidget(
        title: "ADD NEW EXPENSE",
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "What did you pay for",
                style: TextStyle(fontSize: 25, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: MyDropdownButton(
                    key: widget._key,
                  ))),
              const SizedBox(height: 50),
              const Text(
                "Amount",
                style: TextStyle(fontSize: 25, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              MyTextFieldWidget(
                  controller: amountController,
                  color: Theme.of(context).scaffoldBackgroundColor),
              const SizedBox(height: 50),
              const Text(
                "Note",
                style: TextStyle(fontSize: 25, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              MyTextFieldWidget(
                controller: noteController,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              const SizedBox(height: 85),
              SizedBox(
                height: 65,
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 8,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    amount = amountController.text;
                    note = noteController.text;
                    double? parsedAmount = double.tryParse(amount);
                    if (amount.isNotEmpty &&
                        parsedAmount != null &&
                        currentDropdown != null) {
                      Category updated = Category(
                          id: currentDropdown!.id,
                          name: currentDropdown!.name,
                          expense: currentDropdown!.expense + parsedAmount);

                      CategoryDB.instance.update(updated);

                      Log log = Log(
                          categoryId: currentDropdown!.id!,
                          note: noteController.text,
                          expense: parsedAmount);
                      CategoryDB.instance.insertLog(log);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyAlertDialogWidget(
                            title: "Success",
                            content: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Text(
                                  'You paid $amount baht for ${currentDropdown!.name}.',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            actions: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: MyTextButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        widget._key.currentState!
                                            .setState(() {});
                                      });
                                      Navigator.pop(context);
                                    },
                                    color: Theme.of(context).backgroundColor,
                                    child: const Text('OK',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyAlertDialogWidget(
                            title: "Error",
                            content: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: currentDropdown == null
                                  ? const Text('Please select category',
                                      style: TextStyle(color: Colors.white))
                                  : const Text('Invalid Amount',
                                      style: TextStyle(color: Colors.white)),
                            ),
                            actions: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: MyTextButtonWidget(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Theme.of(context).backgroundColor,
                                    child: const Text('OK',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    amountController.clear();
                    noteController.clear();
                  },
                  child: Text("SAVE",
                      style: TextStyle(color: Theme.of(context).canvasColor)),
                ),
              )
            ],
          ),
        ));
  }
}

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({super.key});

  @override
  State<MyDropdownButton> createState() => MyDropdownButtonState();
}

class MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Category>>(
        future: CategoryDB.instance.getCategories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          late List<DropdownMenuItem<Category>> items;
          if (!snapshot.hasData) {
            items = <DropdownMenuItem<Category>>[];
          } else {
            // Remove budget
            snapshot.data!.remove(Category(id: 1, name: "Budget", expense: 0));

            items = snapshot.data!
                .map<DropdownMenuItem<Category>>((Category value) {
              return DropdownMenuItem<Category>(
                value: value,
                child: Text(value.name),
              );
            }).toList();
          }

          String hints = items.isNotEmpty ? "Choose Category" : "No Category Available";

          return DropdownButton<Category>(
            value: currentDropdown,
            icon: const Icon(Icons.list),
            iconEnabledColor: Theme.of(context).canvasColor,
            iconSize: 20,
            elevation: 16,
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(30),
            menuMaxHeight: 200,
            style:
                TextStyle(fontSize: 20, color: Theme.of(context).canvasColor),
            underline: Container(),
            isExpanded: true,
            hint: Text(hints,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).canvasColor)),
            onChanged: (Category? value) {
              // This is called when the user selects an item.
              setState(() {
                currentDropdown = value!;
              });
            },
            items: items,
          );
        },
      ),
    );
  }
}
