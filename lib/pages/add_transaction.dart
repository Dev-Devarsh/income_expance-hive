import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:income_expance/core/local_db/hive_local.dart';
import 'package:income_expance/core/theme/static.dart' as Static;
import 'package:flutter/services.dart';

class AddIncomeExpanseNoGradient extends StatefulWidget {
  const AddIncomeExpanseNoGradient({Key? key}) : super(key: key);

  @override
  AddIncomeExpanseNoGradientState createState() => AddIncomeExpanseNoGradientState();
}

class AddIncomeExpanseNoGradientState extends State<AddIncomeExpanseNoGradient> {
  DateTime selectedDate = DateTime.now();
  int? amount;
  String note = "Expence";
  String type = "Income";

  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Transaction",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: const Color(0xffe2e7ef),
      //
      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: const Icon(
                    Icons.currency_rupee_rounded,
                    size: 24.0,
                    // color: Colors.grey[700],
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "0",
                      counter: Offstage(),
                      border: InputBorder.none,
                    ),

                    maxLength: 6,
                    style: const TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } catch (e) {
                        // show Error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(
                              seconds: 2,
                            ),
                            content: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  "Enter only Numbers as Amount",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            //
            const SizedBox(
              height: 20.0,
            ),
            //
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: const Icon(
                    Icons.description,
                    size: 24.0,
                    // color: Colors.grey[700],
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Note on Transaction",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (val) {
                      note = val;
                    },
                  ),
                ),
              ],
            ),
            //
            const SizedBox(
              height: 20.0,
            ),
            //
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: const Icon(
                    Icons.currency_rupee_rounded,
                    size: 24.0,
                    // color: Colors.grey[700],
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Income",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: type == "Income" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryColor,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Income";
                        if (note.isEmpty || note == "Expance") {
                          note = 'Income';
                        }
                      });
                    }
                  },
                  selected: type == "Income" ? true : false,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Expance",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: type == "Expance" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryColor,
                  onSelected: (val) {
                    if (val) {
                      type = "Expance";
                    } else {
                      type = "Income";
                    }
                    setState(() {});
                  },
                  selected: type == "Expance" ? true : false,
                ),
              ],
            ),
            //
            const SizedBox(
              height: 20.0,
            ),
            //
            SizedBox(
              height: 50.0,
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                  //
                  // to make sure that no keyboard is shown after selecting Date
                  FocusScope.of(context).unfocus();
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.zero,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Static.PrimaryColor,
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(
                        12.0,
                      ),
                      child: const Icon(
                        Icons.date_range,
                        size: 24.0,
                        // color: Colors.grey[700],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "${selectedDate.day} ${months[selectedDate.month - 1]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            const Spacer(),
            //
            GestureDetector(
              behavior:HitTestBehavior.translucent,
              onTap: () {
                if (amount.toString().length > 7) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[700],
                      content: const Text(
                        "Amount should be less than 7 digit",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                  return;
                }
                if (amount != null) {
                  DbHelper.addData(amount!, selectedDate, type, note);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[700],
                      content: const Text(
                        "Please enter a valid Amount !",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [const BoxShadow(blurRadius: 10, spreadRadius: 0.5, color: Colors.black54)]),
                height: 50.0,
                width: MediaQuery.sizeOf(context).width,
                child: const Center(
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
