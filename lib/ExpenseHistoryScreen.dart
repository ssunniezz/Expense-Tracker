import 'package:flutter/material.dart';
import 'package:money_tracker/CategoryDatabase.dart';
import 'package:money_tracker/CustomWidgets/NormalPageLayoutWidget.dart';

class ExpenseHistory extends StatefulWidget {
  const ExpenseHistory({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  State<ExpenseHistory> createState() => _ExpenseHistoryState();
}

class _ExpenseHistoryState extends State<ExpenseHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    )))),
        body: NormalPageLayoutWidget(
            title: "${widget.category.name}'s history", child: _listViewBody()),
      ),
    );
  }

  FutureBuilder _listViewBody() {
    final ScrollController homeController = ScrollController();
    return FutureBuilder<List<Log>>(
        future: CategoryDB.instance.getLogsByCategoryId(widget.category.id!),
        builder: (BuildContext context, AsyncSnapshot<List<Log>> snapshot) {
          print(widget.category.id);
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
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No History',
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
              children: snapshot.data!.map((log) {
                String note = log.note.isEmpty ? "-" : log.note;
                return SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Note: $note",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black54),
                        ),
                        // Expanded(child: Container(),),
                        Text('${log.expense.toStringAsFixed(2)} Baht',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black54))
                      ],
                    ));
              }).toList());
        });
  }
}
