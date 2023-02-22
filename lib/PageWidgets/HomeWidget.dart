import "package:flutter/material.dart";
import 'package:money_tracker/CategoryDatabase.dart';
import 'package:money_tracker/CustomWidgets/MyTextButton.dart';
import 'package:money_tracker/ExpenseHistoryScreen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<List<Category>> categoryList = CategoryDB.instance.getCategories();

  TextStyle headingStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30);
  TextStyle subheadingStyle =
      const TextStyle(color: Colors.white, fontSize: 30);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("TOTAL EXPENSES", style: headingStyle),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<Category>>(
                      future: categoryList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        double totalExpense = !snapshot.hasData
                            ? 0
                            : snapshot.data!.fold(0,
                                (total, element) => total += element.id == 1 ? 0 :element.expense);
                        return Text("${totalExpense.toStringAsFixed(2)} Baht",
                            style: subheadingStyle);
                      })
                ],
              ),
            )),
        Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                children: [
                  Text(
                    "Expense List",
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 30,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(child: _listViewBody())
                ],
              ),
            ))
      ],
    );
  }

  FutureBuilder _listViewBody() {
    final ScrollController homeController = ScrollController();
    return FutureBuilder<List<Category>>(
        future: categoryList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
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
          // Remove budget row
          snapshot.data!.remove(Category(id: 1, name: "Budget", expense: 0));
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Expense',
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 20),
              ),
            );
          }

          return ListView(
              controller: homeController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data!.map((category) {
                return SizedBox(
                    height: 70,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseHistory(category: category)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black54),
                          ),
                          // Expanded(child: Container(),),
                          Text('${category.expense.toStringAsFixed(2)} Baht',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black54))
                        ],
                      ),
                    ));
              }).toList());
        });
  }
}
