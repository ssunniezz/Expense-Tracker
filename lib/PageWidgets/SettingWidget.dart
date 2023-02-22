import 'package:flutter/material.dart';
import 'package:money_tracker/CategoryDatabase.dart';
import 'package:money_tracker/CustomWidgets/MyAlertDialog.dart';
import 'package:money_tracker/CustomWidgets/MyTextButton.dart';
import 'package:money_tracker/CustomWidgets/NormalPageLayoutWidget.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalPageLayoutWidget(
        title: "SETTINGS",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
                width: double.infinity,
                child: MyTextButtonWidget(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    onPressed: () {
                      CategoryDB.instance.getCategories().then((list) {
                        // Remove budget row
                        list.remove(Category(id: 1, name: "Budget", expense: 0));;

                        List<Category> resetList = list.map((category) => Category(
                            id: category.id, name: category.name, expense: 0)).toList();

                        CategoryDB.instance.resetAll(resetList);
                      });

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyAlertDialogWidget(
                              title: "Success",
                              content: Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: const Text('All expenses were reset.',
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
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text('Reset All Expenses',
                        style: TextStyle(color: Colors.red, fontSize: 20))),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 75,
                width: double.infinity,
                child: MyTextButtonWidget(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    onPressed: () {
                      CategoryDB.instance.deleteAll();

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyAlertDialogWidget(
                              title: "Success",
                              content: Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: const Text('All data were erased.',
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
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text('Erase All Data',
                        style: TextStyle(color: Colors.red, fontSize: 20))),
              ),
            ],
          ),
        ));
  }
}
