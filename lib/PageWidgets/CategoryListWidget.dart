import 'package:flutter/material.dart';
import 'package:money_tracker/CustomWidgets/NormalPageLayoutWidget.dart';

import '../CategoryDatabase.dart';
import '../CustomWidgets/MyAlertDialog.dart';
import '../CustomWidgets/MyTextButton.dart';
import '../CustomWidgets/MyTextField.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  TextEditingController addingController = TextEditingController();
  TextEditingController editingController = TextEditingController();

  List<Widget> buttonWidgets = [];
  Set<String> buttonsName = {};

  @override
  void dispose() {
    super.dispose();
    addingController.dispose();
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NormalPageLayoutWidget(
        title: "CATEGORY",
        child: Column(
          children: [
            Expanded(
                flex: 10,
                child: FutureBuilder<List<Category>>(
                    future: CategoryDB.instance.getCategories(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Category>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 20),
                          ),
                        );
                      }

                      buttonWidgets.clear();
                      buttonsName.clear();
                      // Remove budget row
                      snapshot.data!.remove(Category(id: 1, name: "Budget", expense: 0));

                      int index = 0;
                      for (var category in snapshot.data!) {
                        Color color = index % 4 == 0 || index % 4 == 3
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).backgroundColor;

                        index++;
                        buttonsName.add(category.name);
                        buttonWidgets.add(_createCategoryButton(
                            category, color, editingController, context));
                      }

                      snapshot.data!.clear();

                      return buttonWidgets.isNotEmpty
                          ? GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 30,
                              children: buttonWidgets,
                            )
                          : Center(
                              child: Text(
                                "No Category",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: 20),
                              ),
                            );
                    })),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                width: 200,
                height: 50,
                child: MyTextButtonWidget(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyAlertDialogWidget(
                            title: "Enter Category Name",
                            content: MyTextFieldWidget(
                              controller: addingController,
                              color: Colors.white,
                            ),
                            actions: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: MyTextButtonWidget(
                                    onPressed: () {
                                      String input = addingController.text;
                                      input = input[0].toUpperCase() +
                                          input.substring(1).toLowerCase();
                                      if (!buttonsName.contains(input)) {
                                        String newCategory =
                                            addingController.text;
                                        newCategory =
                                            newCategory[0].toUpperCase() +
                                                newCategory
                                                    .substring(1)
                                                    .toLowerCase();

                                        Category toInsert = Category(
                                            name: newCategory, expense: 0);

                                        CategoryDB.instance
                                            .insert(toInsert).then((_) =>
                                        setState(() {
                                          // categoryList = DatabaseHelper.instance.getCategories();
                                          addingController.text = '';
                                        }));
                                      }
                                      Navigator.pop(context);
                                    },
                                    color: Theme.of(context).backgroundColor,
                                    child: const Text('ADD',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Text('ADD CATEGORY',
                        style: TextStyle(color: Colors.white))),
              ),
            )
          ],
        ));
  }

  Widget _createCategoryButton(Category category, Color color,
      TextEditingController controller, BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: color,
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      onPressed: () {
        controller.text = category.name;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialogWidget(
              title: "Edit ${category.name}",
              content: MyTextFieldWidget(
                  controller: controller, color: Colors.white),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 125,
                      height: 50,
                      child: MyTextButtonWidget(
                          onPressed: () {
                            String input = controller.text;
                            input = input[0].toUpperCase() +
                                input.substring(1).toLowerCase();
                            if (!buttonsName.contains(input)) {
                              String newName = controller.text;
                              newName = newName[0].toUpperCase() +
                                  newName.substring(1).toLowerCase();

                              Category edited = Category(
                                  id: category.id,
                                  name: newName,
                                  expense: category.expense);

                              CategoryDB.instance.update(edited).then((_) =>
                              setState(() {
                              }));
                            }
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).backgroundColor,
                          child: const Text('SAVE',
                              style: TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 125,
                      height: 50,
                      child: MyTextButtonWidget(
                          onPressed: () {
                            CategoryDB.instance
                                .delete(category.id!).then((_) =>
                                setState(() {
                                //   categoryList = DatabaseHelper.instance.getCategories();
                                }));

                            Navigator.pop(context);
                          },
                          color: Colors.redAccent,
                          child: const Text('DELETE',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Center(
          child: Text(
        category.name,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      )),
    );
  }
}
