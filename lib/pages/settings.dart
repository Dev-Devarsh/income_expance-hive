
import 'package:income_expance/core/constants/common_strings.dart';
import 'package:income_expance/core/local_db/hive_local.dart';
import 'package:income_expance/core/local_db/prefrence_utils.dart';
import 'package:income_expance/pages/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          12.0,
        ),
        children: [
          ListTile(
            onTap: () async {
              bool answer = await showConfirmDialog(context, "Warning", "This is irreversible. Your entire data will be Lost");
              if (answer) {
                await DbHelper.cleanData();
                Navigator.of(context).pop();
              }
            },
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: const Text(
              "Clean Data",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: const Text(
              "This is irreversible",
            ),
            trailing: const Icon(
              Icons.delete_forever,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          const SizedBox(
            height: 20.0,
          ),
          //
          ListTile(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[300],
                  title: const Text(
                    "Enter new name",
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Your Name",
                        border: InputBorder.none,
                      ),
                      controller: _controller,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      onFieldSubmitted: (val) async => await _saveNewName(),
                      maxLength: 12,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async => await _saveNewName(),
                      child: const Text(
                        "OK",
                      ),
                    ),
                  ],
                ),
              );
            },
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: const Text(
              "Change Name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              "Welcome ${Sf.getString(Keys.name)}",
            ),
            trailing: const Icon(
              Icons.change_circle,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          const SizedBox(
            height: 20.0,
          ),

          SwitchListTile(
            onChanged: (val) async {
              await Sf.setBoolean(Keys.biomatric, val);
              setState(() {});
            },
            value: Sf.getBoolean(Keys.biomatric),
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: const Text(
              "Local Bio Auth",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: const Text(
              "Secure This app, Use Fingerprint to unlock the app.",
            ),
          )
        ],
      ),
    );
  }

  Future<void> _saveNewName() async {
    await Sf.setString(Keys.name, _controller.text.trim());
    Navigator.of(context).pop();
    _controller.clear();
    setState(() {});
  }
}
