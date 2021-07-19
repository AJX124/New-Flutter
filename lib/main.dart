// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:atompaynetz/atompaynetz.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => MyHomePage(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
  
  
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
   StreamSubscription _onDestroy;

  // On urlChanged stream
   StreamSubscription<String> _onUrlChanged;


  @override
  void initState() {
    super.initState();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {

      print('On URL change listener: ' + url);

      if (url.contains('/response.php')) {
        //var substringfromurl = url.substring(0, url.indexOf('?'));
        String separator = "?";
        int sepPos = url.indexOf(separator);
        if (sepPos == -1) {
          //print("No ? found in url...!");
        }
        var substringfromurl = url.substring(sepPos + separator.length);
        //print("substringformurl:" + substringfromurl);
        var urlarray = substringfromurl
            .split('&')
            .map((String text) => Text(text))
            .toList();
        print("Response Array:");
        print(urlarray);
        
        flutterWebViewPlugin.close();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Response: " + urlarray.toString())));
      } 
    });

   
  }

  getUrl() {
    var atompay = new AtomPaynetz(
        login: '192',
        pass: 'Test@123',
        prodid: 'NSE',
        amt: '100.00',
        date: '02/06/2020 16:50:00',
        txnid: '123',
        custacc: '0',
        udf1: 'Test Name',
        udf2: 'test@test.com',
        udf3: '9999999999',
        udf4: 'Mumbai',
        requesthashKey: 'KEY123657234',
        requestencryptionKey: '8E41C78439831010F81F61C344B7BFC7',
        requestsaltKey: '8E41C78439831010F81F61C344B7BFC7',
        responsehashKey: 'KEYRESP123657234',
        responseencypritonKey: '8E41C78439831010F81F61C344B7BFC7',
        responsesaltKey: '8E41C78439831010F81F61C344B7BFC7',
        mode: 'uat'); // put mode: 'live' in production

    var urlToSend = atompay.getUrl();
    print("StartPoint URL:" + urlToSend);
    return urlToSend;
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atom Paynetz Sample App'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                flutterWebViewPlugin.launch(getUrl());
              },
              child: const Text('Open'),
            ),
          ],
        ),
      ),
    );



  }
}