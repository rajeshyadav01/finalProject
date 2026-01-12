import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:prabandh_app/CommanMethod.dart';
import 'CommanWidget.dart';
import 'Login.dart';
import 'MyHttpOverrides.dart';



void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    


      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Background color of the status bar
      // statusBarIconBrightness: Brightness.light, // For white icons
      // statusBarBrightness: Brightness.dark, // For dark mode
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Makes the status bar transparent
          // You can also adjust other properties like statusBarIconBrightness
          // to ensure icons are visible on your background
        ), child: MyHomePage(title: '',),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      // backgroundColor: Color(0xFFb7ebff),

      body:  Container(

        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Color.fromARGB(102, 94, 243, 0.43)
              Color.fromRGBO(102, 94, 243, 0.45),
              Color.fromRGBO(255, 169, 169, 0.34),
              Color.fromRGBO(237, 237, 237, 0.4),

              // Color(0xFF665EF3),
              // Color(0xFFFFA9A9),
              // Color(0xFFEDEDED),
              // Color(0xFFC0D6FF),

            ],
          ),
        ),

        child: Stack(
          children: [
            Column(

              // mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically
              // crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(height: 60,),
                Image(image: AssetImage('assets/images/splashlogo.png')),
                Text('PRABANDH',//appLocalizations.translate('enter_udise_code'),
                    style: TextStyle(fontSize: 41,fontFamily: 'UbuntuBold',fontWeight: FontWeight.w700,color: Color(0xFF090909)),textAlign: TextAlign.center,),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Text('Project Appraisal, Budgeting, Achievements & Data Handling System',//appLocalizations.translate('enter_udise_code'),
                      style: TextStyle(fontSize: 16,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w400,color: Color(0xFF090909)),textAlign: TextAlign.center),
                ),
                SizedBox(height: 50,),
                Center(child: Image(image: AssetImage('assets/images/splashimg.png')),)
                // Image(image: AssetImage('assets/images/splashbottlogo.png')),
              ],
            ),
            Positioned(
              bottom: 25.0, // Aligns the image to the bottom of the Stack
              left: 0.0,   // Aligns the image to the left of the Stack
              right: 0.0,  // Aligns the image to the right of the Stack
              child: Center(
                child: Image.asset(
                  'assets/images/splashbottlogo.png',
                  fit: BoxFit.fill,// Replace with your image path
                         // Adjust fit as needed (e.g., BoxFit.contain, BoxFit.fill)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // initPlatformState();




    // CommanMethod().checkLoginStatus();
    //
    // appState.counter.addListener((){
    //   CommanMethod().deleteAllMealsOffline();
    // });



    Timer(const Duration(seconds: 3),
            () async {



          // if(CommanMethod.isLoggedIn=='true'){
          //
          //   await CommanMethod().retrieveLoginData();
          //
          //   await CommanMethod().getLanguage();
          //
          //   await getReasonData();
          //
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder:
          //           (context) => Dashboard(title: 'Dashboard')
          //       )
          //   );
          //
          //
          //
          // }else{



            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => Login()
                )
            );

          // }
        });
  }



  // Future<void> getReasonData() async {
  //
  //   try {
  //
  //     var jsonRequest1 = jsonEncode(<String, dynamic>{
  //       "udiseCode":CommanMethod.schoolCode});
  //
  //     final publicPem = await rootBundle.loadString('assets/publ.pem');
  //     // final publicPem = await rootBundle.loadString('assets/sample.crt');
  //     // final publicPem = await rootBundle.loadString('assets/udisepublic.pem');
  //     final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
  //
  //     String? encrypt = CommanMethod().encrypt(jsonRequest1,publicKey);
  //
  //
  //     var encryptedData = jsonEncode(<String, dynamic>{
  //       "encryptedData":encrypt});
  //
  //     final response = await http.post(Uri.parse('http://164.100.68.163/amsapp/api/getReasonDtl'),
  //         headers: <String, String>{'Content-Type': 'application/json',},
  //         body: encryptedData
  //     ).timeout(const Duration(seconds: 10));
  //
  //     print('${response.statusCode}\n${response.request}\n${response.body}');
  //
  //     if (response.statusCode == 200) {
  //
  //       final encryptedData = jsonDecode(response.body);
  //       final responseData = jsonDecode(CommanMethod().AESDecrypt(encryptedData['encryptedData'].toString(),base64Encode(utf8.encode('b14ca5898a4e4133bbce2ea2315a1916')))!);
  //
  //       // final responseData = jsonDecode(response.body);
  //
  //       String status = responseData['status'].toString();
  //       if(status == "true") {
  //
  //         // List<dynamic> jsonResponse = json.decode(response.body);
  //         // List<dynamic> jsonResponse = json.decode(responseData['data']);
  //
  //         // Map<String, dynamic> jsonResponse = json.decode(response.body);
  //         //
  //         // String jsonData = jsonResponse['data'].toString();
  //
  //         ApiResponseReasonList apiResponse = ApiResponseReasonList.fromJson(responseData);
  //
  //
  //
  //         // List<RejectRemarkPOJO> reasonListDate =[];
  //         // apiResponse.data.forEach((school) {
  //         //   reasonListDate.add(school);
  //         // });
  //
  //         // CommanMethod.reasonList = reasonListDate;
  //         CommanMethod.reasonList = apiResponse.data;
  //
  //         CommanMethod().reasonListData(apiResponse.data);
  //
  //         // SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //         // await prefs.setStringList("reasonList", );
  //
  //
  //         // Map<String, dynamic> jsonResponse = json.decode(response.body);
  //         //
  //         // List<dynamic> responseList = jsonResponse['data'] as List;
  //         //
  //         // // Map the dynamic list to a list of RejectRemarkPOJO
  //         // CommanMethod.reasonList=responseList.map((remark) => RejectRemarkPOJO.fromJson(remark)).toList();
  //         //
  //         //
  //         // // CommanMethod.reasonList = responseData['data'];
  //         //
  //         print(CommanMethod.reasonList);
  //
  //
  //       }
  //       else{
  //         // String msg= responseData['errorDetails'].toString();
  //         CommanWidget().showToast("getting error");
  //
  //       }
  //
  //     }else if(response.statusCode == 401){
  //
  //       CommanWidget().showToast('Invalid authorization token. Please login again');
  //
  //     } else {
  //
  //       CommanWidget().showToast('Failed to post data');
  //
  //     }
  //
  //   } on TimeoutException catch(ee){
  //     CommanWidget().showToast('Timeout exception');
  //
  //   }catch (e) {
  //     CommanWidget().showToast('Failed to post data');
  //
  //   }
  // }
}
