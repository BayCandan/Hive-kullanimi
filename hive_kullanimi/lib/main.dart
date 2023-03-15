import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_kullanimi/model/ogrenci.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // encryted // asagidaki kodlar sifreleme islemi yapilmasi icin duzenlenmis olup verilmi sonuc alinanamamistir.
  // FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  // var containsEncryptionKey = await secureStorage.containsKey(key: "key");
  // if (!containsEncryptionKey) {
  //   var key = Hive.generateSecureKey();
  //   await secureStorage.write(key: "key", value: base64UrlEncode(key));
  // }
  // var encryptionKey =
  //     base64Url.decode(await secureStorage.read(key: "key") ?? "ErSiN");
  // print("Encryption key: $encryptionKey");

  // var sifleriKutu = await Hive.openBox("ozel",
  //     encryptionCipher: HiveAesCipher(encryptionKey));

  // await sifleriKutu.put("gizli", "gizli deger");
  // await sifleriKutu.put("sifre", "12345");
  // print(sifleriKutu.getAt(0));    
  // print(sifleriKutu.getAt(1));    

  await Hive.initFlutter('uygulama');
  await Hive.openBox('test');

  Hive.registerAdapter(OgrenciAdapter());
  Hive.registerAdapter(GozRenkAdapter());
  await Hive.openBox<Ogrenci>("ogrenciler");
  await Hive.openLazyBox<int>("sayilar");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Hive Kullanimi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() async {
    var box = Hive.box("test");
    await box.clear();
    box.add("candan"); // index 0, key 0 value emre
    box.add("ersin");
    box.add(true);
    box.add(15);
    // await box.addAll(['liste1',"liste2",false,3213]);

    // box.values.forEach((element) {
    //   debugPrint(element.toString());
    // });

    await box.put("tc", "123456789");
    await box.put("tema", "dark");
    // await box.putAll({
    //   'araba':"mercedes",
    //   "yil" : 1999
    // });

    // box.values.forEach((element) {
    //   debugPrint(element.toString());
    // });

    debugPrint(box.get("tema")); // key ile erisim
    debugPrint(box.getAt(5));
    debugPrint(box.length.toString());
    await box.delete("tc");
    await box.deleteAt(0);
    await box.putAt(1, "KRAL");
    debugPrint(box.toMap().toString());
  }

  void _customData() async {
    var emre = Ogrenci(5, "candan", GozRenk.SIYAH);
    var ersin = Ogrenci(7, "ersin", GozRenk.MAVI);

    var box = Hive.box<Ogrenci>("ogrenciler");

    await box.clear();
    box.add(emre);
    box.add(ersin);

    debugPrint(box.toMap().toString());
  }

  void _lazyAndEncrytedBox() async {
    var sayilar = Hive.lazyBox<int>("sayilar");
    for (int i = 0; i <= 50; i++) {
      await sayilar.add(i * 50);
    }
    for (int i = 0; i <= 50; i++) {
      debugPrint((await sayilar.getAt(i)).toString());
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Default uyuglama arayuzu ',
            ),
            Text(
              'Kodlara Bakin',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _lazyAndEncrytedBox,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
