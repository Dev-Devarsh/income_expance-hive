// not just splash , will ask use for their name here

import 'package:income_expance/core/constants/common_strings.dart';
import 'package:income_expance/core/local_db/prefrence_utils.dart';
import 'package:income_expance/pages/add_name.dart';
import 'package:income_expance/core/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:income_expance/pages/home/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool authFailed = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 1500),
      () async {
        getName();
      },
    );
  }

  Future getName() async {
    String name = Sf.getString(Keys.name);
    if (name.isNotEmpty) {
      // user has entered a name
      // since name is also important and can't be null
      // we will check for auth here and will show , auth if it is on;
      bool isAuthOn = Sf.getBoolean(Keys.biomatric);
      if (isAuthOn) {
        bool auth = await LocalAuth.authenticate();
        if (auth) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        } else {
          authFailed = true;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(Str.bioMatricFailed),
          ));
          setState(() {});
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AddName(),
        ),
      );
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      //
      backgroundColor: const Color(0xffe2e7ef),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Image.asset(
                "assets/icon.png",
                width: 64.0,
                height: 64.0,
              ),
            ),
          ),
          if (authFailed)
            Positioned(
                child: TextButton(
              child: const Text('Try Again'),
              onPressed: () async {
                bool isAuthOn = Sf.getBoolean(Keys.biomatric);
                if (isAuthOn) {
                  bool auth = await LocalAuth.authenticate();
                  if (auth) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  } else {
                    authFailed = true;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(Str.bioMatricFailed),
                    ));
                    setState(() {});
                  }
                }
              },
            ))
        ],
      ),
    );
  }
}
