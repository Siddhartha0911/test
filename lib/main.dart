import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

const kParseApplicationId = "V1ySqTdg0tyBRKEqO5vPakBlLq4iuimtjvTsrF0U";
const kParseClientKey = 'imHRwgC0l6A37WPxe7GE5yNSN95l6BPY6fbh5BJ1';
const parseServerUrl = "https://parseapi.back4app.com";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //To connect to Back4app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); //To fix the orientation of APP
  await Parse().initialize(
    kParseApplicationId,
    parseServerUrl,
    clientKey: kParseClientKey, // Required for some setups
    debug: true, // When enabled, prints logs to console
    //liveQueryUrl: keyLiveQueryUrl, // Required if using LiveQuery
    autoSendSessionId: true, // Required for authentication and ACL
    // securityContext:  securityContext,// Again, required for some setups
    // coreStore: await CoreStoreSharedPrefsImp.getInstance()
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cloudFunction() async {
      ParseCloudFunction _cloudFunction =
          ParseCloudFunction('functionMigrationTest');
      await _cloudFunction.execute().then((_response) {
        if (_response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data = ${_response.result}')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error = ${_response.error!.message}')));
        }
      }).catchError((err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Frontend Error = $err')));
      });
    }

    return Scaffold(
        body: Center(
            child: ElevatedButton(
                onPressed: () => cloudFunction(),
                child: const Text("Get Data From cloud"))));
  }
}
