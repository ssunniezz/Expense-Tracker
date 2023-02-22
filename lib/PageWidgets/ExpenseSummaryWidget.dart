import 'package:flutter/material.dart';
import 'package:money_tracker/CustomWidgets/MyAlertDialog.dart';
import 'package:money_tracker/CustomWidgets/MyTextButton.dart';
import '../CategoryDatabase.dart';
import '../CustomWidgets/MyTextField.dart';
import '../CustomWidgets/NormalPageLayoutWidget.dart';

class ExpenseSummaryWidget extends StatefulWidget {
  const ExpenseSummaryWidget({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryWidget> createState() => _ExpenseSummaryWidgetState();
}

class _ExpenseSummaryWidgetState extends State<ExpenseSummaryWidget> {
  final TextEditingController budgetController = TextEditingController();

  double expense = 0;
  double budget = 0;

  static const double headerSize = 30;
  static const double normalSize = 25;

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NormalPageLayoutWidget(
        title: "SUMMARY",
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<List<Category>>(
              future: CategoryDB.instance.getCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Category>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 20),
                    ),
                  );
                }

                budget = 0;
                expense = 0;
                for (Category element in snapshot.data!) {
                  if (element.id == 1) {
                    budget = element.expense;
                    expense += 0;
                  } else {
                    expense += element.expense;
                  }
                }

                snapshot.data!.clear();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        const Text(
                          "Total Budget",
                          style: TextStyle(
                              fontSize: headerSize, color: Colors.black54),
                        ),
                        IconButton(
                          onPressed: () {
                            budgetController.text = budget.toStringAsFixed(0);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyAlertDialogWidget(
                                  title: "Edit Budget",
                                  content: MyTextFieldWidget(
                                      controller: budgetController,
                                      color: Colors.white),
                                  actions: <Widget>[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: MyTextButtonWidget(
                                          onPressed: () {
                                            double? newVal = double.tryParse(
                                                budgetController.text);
                                            setState(() {
                                              budget = newVal ?? budget;
                                              CategoryDB.instance.update(
                                                  Category(
                                                      id: 1,
                                                      name: 'Budget',
                                                      expense: budget));
                                              if (newVal == null) {
                                                budgetController.clear();
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                          color:
                                              Theme.of(context).backgroundColor,
                                          child: const Text('SAVE',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      budget.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: normalSize, color: Colors.black54),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Total Expenses",
                      style: TextStyle(
                          fontSize: headerSize, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      expense.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: normalSize, color: Colors.black54),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Remaining",
                      style: TextStyle(
                          fontSize: headerSize, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      (budget - expense).toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: normalSize,
                          color: budget - expense < 0
                              ? Colors.red
                              : Colors.black54),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
