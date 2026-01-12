import 'dart:async';
import 'dart:convert';
import 'dart:math';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:prabandh_app/DashBoard.dart';
import 'package:prabandh_app/utility/AppLocalizations.dart';
import 'package:prabandh_app/CommanMethod.dart';
import 'package:prabandh_app/CommanWidget.dart';
// import 'package:pmposhan/Dashboard.dart';
// import 'package:pmposhan/SchoolConfirmation.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'CommanWidget.dart';
import 'package:intl/intl.dart';





class Login extends StatelessWidget{
  Login({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF77bad1), // Background color of the status bar
      // statusBarIconBrightness: Brightness.light, // For white icons
      // statusBarBrightness: Brightness.dark, // For dark mode
    ));

    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.green,

      ),
      home: LoginPage(title: 'Login'),
      debugShowCheckedModeBanner: false,
    );
  }

}

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.title});

  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{


  bool visibilityOTP=false;
  bool visibilityPassword=true;
  bool visibilityCaptcha=true;
  bool visibilitySendOTPBUTTON=false;
  bool visibilityLoginBUTTON=true;
  bool isOTPSend=false;

  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerCaptcha = TextEditingController();
  final TextEditingController _controllerPswd = TextEditingController();
  final TextEditingController _controllerOTP = TextEditingController();
  // final GlobalKey<State> _loaderDialog = GlobalKey<State>();
  bool _isLoading = false;
  bool verifiedUser=false;
  String schoolCode='',schoolName='',districtName='',blockName='',villageName='',stateName='',loginTime ='';
  AppLocalizations appLocalizations= AppLocalizations(Locale(CommanMethod.locale, ''));
  late AnimationController _controllerAnimation;
  late Animation<double> _animation;
  String randomString="";
  final TextEditingController textCaptchaController = TextEditingController();
  bool isLoginWithMobile=false;

  String email="",password="",type="email",captcha="",mobile="",otp="",otc="",secure="",token="";
   String? ots;
  bool dataObjSecure=true;

  bool _isCheckedOTP = false;



  bool checkValidation(){
    if(_controllerUser.text.isEmpty){
      CommanWidget().showToast("Please enter user name");
      return false;
    }else if(_controllerUser.text.length>15){
      CommanWidget().showToast("Please enter valid user name");
      return false;
    }else if(_controllerPswd.text.isEmpty && !isOTPSend){
      CommanWidget().showToast("Please enter password");
      return false;
    }else if(_controllerPswd.text.length>20 && !isOTPSend){
      CommanWidget().showToast("Please enter valid password");
      return false;
    }else if(_controllerOTP.text.isEmpty && isOTPSend){
      CommanWidget().showToast("Please enter OTP");
      return false;
    }else if(_controllerOTP.text.length>6 && isOTPSend){
      CommanWidget().showToast("Please enter valid OTP");
      return false;
    }else if(_controllerCaptcha.text.isEmpty){
      CommanWidget().showToast("Please enter captcha");
      return false;
    }else if(_controllerCaptcha.text.length>6){
      CommanWidget().showToast("Please enter valid captcha");
      return false;
    }else{
      return true;
    }
  }

  // Future<void> getGAID() async {
  //   try {
  //     // Retrieve GAID
  //     final adInfo = await MobileAds.instance.getAdInfo();
  //     final gaid = adInfo?.advertiserId; // Retrieve the GAID
  //     print('GAID: $gaid');
  //   } catch (e) {
  //     print('Error retrieving GAID: $e');
  //   }
  // }

  Future<void> getAndroidId() async {

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //
    // // Get the Android ID
    // String androidId = androidInfo.id; // Unique ID for each device
    // Map<String,dynamic> androidIdmap = androidInfo.data; // Unique ID for each device
    //
    // print('Android ID: $androidId');

  }

  // Logic for creating Captcha
  void buildCaptcha() {
    // Letter from which we want to generate the captach
    // We have taken A to Z all small nand
    // caps letters along with numbers
    // You can change this as per your convience
    const letters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    const length = 6;
    // Length of Captcha to be generated
    final random = Random();
    // Select random letters from above list
    randomString = String.fromCharCodes(List.generate(
        length, (index) => letters.codeUnitAt(random.nextInt(letters.length))));
    setState(() {});
    print("the random string is $randomString");
  }


  @override
  void initState() {
    super.initState();

    getCaptchaData();

    _controllerAnimation = AnimationController(
      vsync: this, // vsync is set to this for performance reasons
      duration: Duration(seconds: 2), // Set the duration of the animation
    );

    _animation = Tween<double>(
      begin: 0, // Start rotation angle
      end: 2 * 3.141, // End rotation angle (2 * pi for a full circle)
    ).animate(_controllerAnimation);

    _controllerAnimation.repeat();

    // AppLocalizations.load(Locale(CommanMethod.locale, '')).then((onValue){
    //   setState(() {
    //     appLocalizations=onValue;
    //   });
    // });

    // buildCaptcha();



    // WidgetsFlutterBinding.ensureInitialized();
    // MobileAds.instance.initialize();

    // getAndroidId();
    // getGAID();

  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    _controllerUser.dispose();
    _controllerPswd.dispose();
    _controllerOTP.dispose();
    _controllerCaptcha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
        // backgroundColor: Color(0xFFb7ebff),
        body: SingleChildScrollView(child: Container(

          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [

                Color.fromRGBO(102, 94, 243, 0.45),
                Color.fromRGBO(102, 94, 243, 0.45),
                Color.fromRGBO(255, 169, 169, 0.34),
                // Color.fromRGBO(255, 169, 169, 0.34),
                Color.fromRGBO(237, 237, 237, 0.4),

                // Color.fromRGBO(102, 94, 243, 0.43),
                // Color.fromRGBO(255, 169, 169, 0.13),
                // Color.fromRGBO(237, 237, 237, 0.4),

                // Color(0xFFB4ECFF),
                // Color(0xFFA4E9FF),
                // Color(0xFFA8C6FE),
                // Color(0xFFC0D6FF),

              ],
            ),
          ),

          child: Stack(
            children: <Widget>[
              //Header
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                child: Container(
                  height: 120,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100.0,
                      child: Align(alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/appbarlogo.png', // Replace with your image path
                                  // Adjust fit as needed (e.g., BoxFit.contain, BoxFit.fill)
                                ),


                                // Container(
                                //   height: 1.0, // Height defines the thickness of the line
                                //   color: Colors.black, // Color of the line
                                //   margin: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Add horizontal margin
                                // ),
                                SizedBox(width: 10,),

                                Text('PRABANDH',//appLocalizations.translate('school_confirmation'),
                                  style: TextStyle(fontSize: 16.0,fontFamily: 'NunitoExtraBold',fontWeight: FontWeight.w800),),
                              ],
                            )
                        ),)
                  ),
                ),
              ),

              // Column(children: [
              //   SizedBox(height: 120,),
              //   Align(alignment: Alignment.bottomRight,
              //
              //     child:Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: RichText(
              //         text: TextSpan(
              //           style: const TextStyle(
              //             fontSize: 14.0,
              //             color: Colors.black,
              //           ),
              //           children: <TextSpan>[
              //             TextSpan(text: 'Login to\n',style: const TextStyle(fontFamily: 'Nunito')),
              //             TextSpan(text: 'PRABANDH\n', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: 'NunitoExtraBold')),
              //             TextSpan(text: 'Project Appraisal, Budgeting, Achievements & Data Handling System',style: const TextStyle(fontFamily: 'Nunito')),
              //           ],
              //         ),
              //       ),
              //     ),
              //     //Image(height:96,width: 96,image: AssetImage('assets/images/pm_poshan_logo.png')),
              //   )
              // ],),


              // _isLoading ? Center(child: CircularProgressIndicator(
              //   backgroundColor: Colors.grey[200],
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              //   strokeWidth: 6.0,
              //   semanticsLabel: 'Loading data',
              //   value: 0.7,
              // ),)
              _isLoading ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(0xFF665EF3),
                  size: 80,
                ),
              )
                  :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 100,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                    child: Align(alignment: Alignment.centerLeft,
                      child: Text('Login to',//appLocalizations.translate('enter_udise_code'),
                          style: TextStyle(fontSize: 14,fontFamily: 'Nunito',fontWeight: FontWeight.w300),textAlign: TextAlign.left),),
                  ),
                  // SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                    child: Align(alignment: Alignment.centerLeft,
                      child: Text('PRABANDH',//appLocalizations.translate('enter_udise_code'),
                          style: TextStyle(fontSize: 24,fontFamily: 'NunitoBold',fontWeight: FontWeight.w900),textAlign: TextAlign.left),),
                  ),
                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                    child: Row(
                      children: [
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            color:isLoginWithMobile?Colors.transparent:Color(0xFFFFFFFF), // Example color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              // bottomRight: Radius.circular(100.0),
                              // bottomRight: Radius.elliptical(50, 120)
                              // bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          // color:Color(0xFF365DA8),
                          child: TextButton(onPressed: () {
                            setState(() {
                              isLoginWithMobile=false;
                              type="email";
                              cleanAllField();
                            });

                          },
                            child: Text('Email',style: TextStyle(fontSize: 18,fontFamily: isLoginWithMobile?'UbuntuRegular':'UbuntuBold',color: Color(0xFF000000),fontWeight: isLoginWithMobile?FontWeight.w400:FontWeight.w700),),),
                        ),),
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            // color:isLoginWithMobile?Color(0xFF365DA8):Color(0xFFF8F8F8), // Example color
                            color:isLoginWithMobile?Color(0xFFFFFFFF):Colors.transparent, // Example color
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              // bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          // color: Color(0xFFF8F8F8),
                          child: TextButton(onPressed: () {
                            setState(() {
                              isLoginWithMobile=true;
                              type="mobile";
                              cleanAllField();
                            });

                          },
                            child: Text('Mobile',style: TextStyle(fontSize: 18,fontFamily: isLoginWithMobile?'UbuntuBold':'UbuntuRegular',color: Color(0xFF000000),fontWeight: isLoginWithMobile?FontWeight.w700:FontWeight.w400)),),
                        ))
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Container(
                      // elevation: 0,
                      //   color: Color(0xFFFFFFFF),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF), // Example color
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16),topLeft: isLoginWithMobile?Radius.circular(16):Radius.circular(0),topRight: isLoginWithMobile?Radius.circular(0):Radius.circular(16)), // Uniform radius of 15.0
                        ),
                        // shape: RoundedRectangleBorder(
                        //   // borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16),bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
                        //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
                          child: Column(

                            children: [

                              // Text('School Name: $schoolName'):SizedBox.shrink(),



                              Column(
                                children: [



                                  // isLoginWithMobile?SizedBox(height: 0,):SizedBox(height: 20,),
                                  isLoginWithMobile?SizedBox(height: 40,child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Checkbox(
                                        activeColor: Color(0xFF124C9C),
                                        checkColor: Colors.white,
                                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        // side: BorderSide(color: Colors.grey, width: 2.0),
                                        value: _isCheckedOTP, // Current value of the checkbox
                                        onChanged: (newValue) {
                                          setState(() {// Update the state and rebuild UI

                                            if(isOTPSend){
                                              _isCheckedOTP = true;
                                            }else{
                                              _isCheckedOTP = newValue!;

                                              if(_isCheckedOTP){
                                                visibilityPassword=false;
                                                visibilityCaptcha=false;
                                                visibilitySendOTPBUTTON=true;
                                                visibilityLoginBUTTON=false;

                                              }else{
                                                visibilityPassword=true;
                                                visibilityCaptcha=true;
                                                visibilitySendOTPBUTTON=false;
                                                visibilityLoginBUTTON=true;
                                              }

                                            }
                                          });
                                        },
                                      ),
                                      Text('Login with OTP?',style: TextStyle(fontSize: 14,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w300),textAlign: TextAlign.left)
                                    ],),):SizedBox(height: 40,),
                                  Row(
                                    children: [
                                      Text(isLoginWithMobile?'Mobile Number':'Email ID',//appLocalizations.translate('enter_udise_code'),
                                          style: TextStyle(fontSize: 16,fontFamily: 'UbuntuLight',fontWeight: FontWeight.w300),textAlign: TextAlign.left),
                                      Expanded(child: Text(''))
                                    ],
                                  ),
                                  // const SizedBox(height: 2,),
                                  SizedBox(
                                    height: 48,
                                    child: TextField(
                                      maxLength: isLoginWithMobile?10:25,
                                      // validator: validateEmailRegex,

                                      buildCounter: (
                                          BuildContext context, {
                                            int? currentLength,
                                            int? maxLength,
                                            bool? isFocused,
                                          }) => null,
                                      controller: _controllerUser,
                                      // onSubmitted: (sub){
                                      //   CommanWidget().showToast(sub);
                                      // },
                                      // onChanged: (text){
                                      //   CommanWidget().showToast(text);
                                      // },
                                      decoration: InputDecoration(
                                        // suffixIcon: IconButton(
                                        //     onPressed: () {
                                        //
                                        //     },
                                        //     // onPressed: () => setState(() {
                                        //     //            hidden = !hidden;
                                        //     //             }),
                                        //     icon: verifiedUser?Lottie.asset('assets/verified.json',repeat: true,):SizedBox.shrink()),
                                        contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(color: Color(0xFFD1D1D1)),
                                        ),
                                        // labelText: 'User Name',
                                        // hintText: 'Enter email ID here',//appLocalizations.translate('enter_udise_code'),
                                        // hintStyle: TextStyle(
                                        //   color: Color(0xFF929292), // Set the hint text color
                                        //   fontSize: 14, // You can also adjust font size
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                              Column(children: [
                                visibilityOTP?Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text('OTP',//appLocalizations.translate('enter_udise_code'),
                                            style: TextStyle(fontSize: 16,fontFamily: 'UbuntuLight',fontWeight: FontWeight.w300),textAlign: TextAlign.left),
                                        Expanded(child: Text(''))
                                      ],
                                    ),
                                    // const SizedBox(height: 2,),
                                    SizedBox(
                                      height: 48,
                                      child: TextField(
                                        obscureText: true,
                                        maxLength: 7,
                                        // validator: validateEmailRegex,

                                        buildCounter: (
                                            BuildContext context, {
                                              int? currentLength,
                                              int? maxLength,
                                              bool? isFocused,
                                            }) => null,
                                        controller: _controllerOTP,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {

                                              },
                                              // onPressed: () => setState(() {
                                              //            hidden = !hidden;
                                              //             }),
                                              icon: verifiedUser?Lottie.asset('assets/verified.json',repeat: true,):SizedBox.shrink()),
                                          contentPadding:
                                          const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                          enabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(color: Color(0xFFD1D1D1)),
                                          ),
                                          // labelText: 'User Name',
                                          // hintText: 'Enter password here',//appLocalizations.translate('enter_udise_code'),
                                          // hintStyle: TextStyle(
                                          //   color: Color(0xFF929292), // Set the hint text color
                                          //   fontSize: 14, // You can also adjust font size
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ):SizedBox.shrink(),
                                visibilityPassword?Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text('Password',//appLocalizations.translate('enter_udise_code'),
                                            style: TextStyle(fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w300),textAlign: TextAlign.left),
                                        Expanded(child: Text(''))
                                      ],
                                    ),
                                    // const SizedBox(height: 2,),
                                    SizedBox(
                                      height: 48,
                                      child: TextField(
                                        obscureText: true,
                                        maxLength: 15,
                                        // validator: validateEmailRegex,

                                        buildCounter: (
                                            BuildContext context, {
                                              int? currentLength,
                                              int? maxLength,
                                              bool? isFocused,
                                            }) => null,
                                        controller: _controllerPswd,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {

                                              },
                                              // onPressed: () => setState(() {
                                              //            hidden = !hidden;
                                              //             }),
                                              icon: verifiedUser?Lottie.asset('assets/verified.json',repeat: true,):SizedBox.shrink()),
                                          contentPadding:
                                          const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                          enabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(color: Color(0xFFD1D1D1)),
                                          ),
                                          // labelText: 'User Name',
                                          // hintText: 'Enter password here',//appLocalizations.translate('enter_udise_code'),
                                          // hintStyle: TextStyle(
                                          //   color: Color(0xFF929292), // Set the hint text color
                                          //   fontSize: 14, // You can also adjust font size
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ):SizedBox.shrink(),
                                SizedBox(height: 5,),
                                visibilityCaptcha?Row(
                                  children: [
                                    Text('Captcha',//appLocalizations.translate('enter_udise_code'),
                                        style: TextStyle(fontSize: 16,fontFamily: 'UbuntuLight',fontWeight: FontWeight.w300),textAlign: TextAlign.left),

                                  ],
                                ):SizedBox.shrink(),
                                visibilityCaptcha?Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(flex: 5,child: TextField(
                                      controller: _controllerCaptcha,
                                      maxLength: 7,
                                      // validator: validateEmailRegex,

                                      buildCounter: (
                                          BuildContext context, {
                                            int? currentLength,
                                            int? maxLength,
                                            bool? isFocused,
                                          }) => null,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {

                                            },
                                            // onPressed: () => setState(() {
                                            //            hidden = !hidden;
                                            //             }),
                                            icon: verifiedUser?Lottie.asset('assets/verified.json',repeat: true,):SizedBox.shrink()),
                                        contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(color: Color(0xFFD1D1D1))),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(color: Color(0xFFD1D1D1)),
                                        ),
                                        // labelText: 'User Name',
                                        // hintText: 'Enter captcha here',//appLocalizations.translate('enter_udise_code'),
                                        // hintStyle: TextStyle(
                                        //   color: Color(0xFF929292), // Set the hint text color
                                        //   fontSize: 14, // You can also adjust font size
                                        // ),
                                      ),
                                    )
                                      // TextFormField(
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       // isVerified = false;
                                      //     });
                                      //   },
                                      //   decoration: const InputDecoration(
                                      //       border: OutlineInputBorder(),
                                      //       hintText: "Enter Captcha Value",
                                      //       labelText: "Enter Captcha Value"),
                                      //   controller: textCaptchaController,
                                      // ),
                                    ),


                                    Expanded(flex: 2,child: Container(
                                      // padding: const EdgeInsets.all(10),
                                        color: Color(0xFFF8F9FA),
                                        // decoration: BoxDecoration(
                                        //     border: Border.all(width: 0),
                                        //     borderRadius: BorderRadius.circular(0)),
                                        child: Center(child: Text(
                                          captcha,
                                          style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17,fontFamily: 'Nunito',color: Color(0xFF090909)),
                                        ),)),),
                                    // Shown Captcha value to user

                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    // Regenerate captcha value
                                    Expanded(flex: 1,child: Container(
                                      color: Color(0xFFE9ECEF),
                                      child: IconButton(
                                          onPressed: () {
                                            // buildCaptcha();
                                            getCaptchaData();
                                          },
                                          icon: ImageIcon(AssetImage('assets/images/capchareload.png'),
                                            color: Color(0xFF0D6EFD),)),),)


                                    // TextFormField to enter captcha value

                                    // const SizedBox(
                                    //   height: 10,
                                    // ),

                                  ],
                                ):SizedBox.shrink(),

                                SizedBox(height: 15,),

                                visibilityLoginBUTTON?SizedBox(
                                  width: 600,
                                  height: 50,
                                  child: ElevatedButton(style:
                                  ElevatedButton.styleFrom(backgroundColor: const Color(0xFF665EF3),shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5), // <-- Radius
                                  ),),
                                    // onPressed:null,
                                    onPressed: (){

                                      if(checkValidation()){
                                        login();
                                      }


                                      // Navigator.push(
                                      //   context,
                                      //   // MaterialPageRoute(builder: (context) => SearchBy()),
                                      //   MaterialPageRoute(builder: (context) =>  DashBoard()),
                                      // );

                                      // CommanWidget().showToast('API Implementation In Progress');

                                    },

                                    child: Text('Login',//appLocalizations.translate('submit'),
                                        style: TextStyle(fontSize: 18,fontFamily: 'UbuntuMedium',fontWeight: FontWeight.w400,color: Colors.white)),),):SizedBox.shrink(),
                              ],),



                              visibilitySendOTPBUTTON?SizedBox(
                                width: 600,
                                height: 50,
                                child: ElevatedButton(style:
                                ElevatedButton.styleFrom(backgroundColor: const Color(0xFF665EF3),shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // <-- Radius
                                ),),
                                  onPressed: (){

                                    // Navigator.push(
                                    //   context,
                                    //   // MaterialPageRoute(builder: (context) => SearchBy()),
                                    //   MaterialPageRoute(builder: (context) =>  DashBoard()),
                                    // );

                                    sendOTP();

                                    // CommanWidget().showToast('API Implementation In Progress');

                                  }, child: Text('Send OTP',//appLocalizations.translate('submit'),
                                      style: TextStyle(fontSize: 18,fontFamily: 'UbuntuMedium',fontWeight: FontWeight.w400,color: Colors.white)),),):SizedBox.shrink(),




                            ],),
                        )
                    ),
                  ),

                  SizedBox(height: 15,),
                  Align(alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Text('Forget Password?',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w500,color: Color(0xFF365DA8))),
                      )),
                  SizedBox(height: 10,),
                  Align(alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Text('Download 2FA User Manual',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w500,color: Color(0xFF365DA8))),
                      ))
                ],),

            ],),
        ),)
    );
  }

  String? validateEmailRegex(String? value) {
    const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      CommanWidget().showToast('Please enter an email address');
      return 'Please enter an email address';
    }
    if (!regex.hasMatch(value)) {
      CommanWidget().showToast('Please enter a valid email address');
      return 'Please enter a valid email address';
    }
    return null;
  }



  getCaptchaData() async {
    var result;

    setState(() {
      _isLoading = true;
    });

    // var jsonRequest = jsonEncode(<String, dynamic>{
    //   'udiseCode': _controllerUserName.text,
    // });
    //
    // final publicPem = await rootBundle.loadString('assets/publ.pem');
    //
    // final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
    //
    // String? encryptedData = CommanMethod().encrypt(jsonRequest,publicKey);
    //
    // var jsonEncryptedRequest = jsonEncode(<String, dynamic>{
    //   'encryptedData': encryptedData,
    // });

    try {
      final response = await http.get(
        Uri.parse('https://prabandh.education.gov.in/apitesting/auth/captcha'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        // body: jsonEncryptedRequest
      ).timeout(const Duration(seconds: 10));

      print('${response.statusCode}\n${response.request}\n${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        final responseData = jsonDecode(response.body);

        setState(() {
          captcha = responseData['captcha'].toString();
          otc = responseData['OTC'].toString();
        });


        // String status = responseData['status'].toString();
        // if (status == "true") {
        //
        // } else {
        //   // Map<String,dynamic> error= responseData['errorDetails'];
        //   String msg = responseData['errorDetails'].toString();
        //   CommanWidget().showToast(msg);
        // }
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String responseCode =
        jsonResponse["errorDetails"]['responseCode'].toString();
        String type = jsonResponse["errorDetails"]['type'].toString();
        if (responseCode == '974' && type == 'invalid_authorization_token') {
          CommanWidget()
              .showToast('Invalid authorization token. Please login again');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isEmpty) {
          CommanWidget().showToast('Failed to post data');
        } else {
          CommanWidget()
              .showToast(jsonResponse["errorDetails"]['message'].toString());
        }
      }
    } on TimeoutException catch (ee) {
      CommanWidget().showToast('Timeout exception');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      CommanWidget().showToast('Failed to post data');

      setState(() {
        _isLoading = false;
        result = 'Error: $e';
      });
    }
  }

  sendOTP() async {
    var result;

    String bearerToken='null';
    setState(() {
      _isLoading = true;
    });

    var jsonRequest = jsonEncode(<String, dynamic>{
      "flag": "admin",
      "mobile": _controllerUser.text,
    });

    // var jsonRequest = '{"flag": "admin","mobile": "${_controllerUser.text}"}';

    // final publicPem = await rootBundle.loadString('assets/publ.pem');
    //
    // final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
    //
    // String? encryptedData = CommanMethod().encrypt(jsonRequest,publicKey);
    //
    // var jsonEncryptedRequest = jsonEncode(<String, dynamic>{
    //   'encryptedData': encryptedData,
    // });

    try {
      final response = await http
          .post(
          Uri.parse(
              'https://prabandh.education.gov.in/apitesting/auth/otp/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
          body: jsonRequest)
          .timeout(const Duration(seconds: 10));

      print('${response.statusCode}\n${response.request}\n${response.body}');

      if (response.statusCode == 200) {

        // Future.delayed(Duration(seconds: 100), () {
        //
        //
        //   // Code to be executed after a 2-second delay
        //   print('This code runs after 2 seconds.');
        // });

        setState(() {
          _isLoading = false;
        });

        final responseData = jsonDecode(response.body);

        String status = responseData['status'].toString();
        if (status == "true") {
          ots = responseData['ots'].toString();
          otp = responseData['OTP'].toString();
          token = responseData['token'].toString();
          setState(() {
            visibilityOTP=true;
            visibilityCaptcha=true;
            visibilitySendOTPBUTTON=false;
            visibilityLoginBUTTON = true;
            isOTPSend=true;
          });
        } else {
          // Map<String,dynamic> error= responseData['errorDetails'];
          String msg = responseData['errorDetails'].toString();
          CommanWidget().showToast(msg);
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String responseCode =
        jsonResponse["errorDetails"]['responseCode'].toString();
        String type = jsonResponse["errorDetails"]['type'].toString();
        if (responseCode == '974' && type == 'invalid_authorization_token') {
          CommanWidget()
              .showToast('Invalid authorization token. Please login again');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isEmpty) {
          CommanWidget().showToast('Failed to post data');
        } else {
          CommanWidget()
              .showToast(jsonResponse["errorDetails"]['message'].toString());
        }
      }
    } on TimeoutException catch (ee) {
      CommanWidget().showToast('Timeout exception');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      CommanWidget().showToast('Failed to post data');

      setState(() {
        _isLoading = false;
        result = 'Error: $e';
      });
    }
  }

  login() async {
    var result;

    setState(() {
      _isLoading = true;
    });

    // var jsonRequest = jsonEncode(<String, dynamic>{
    //   'udiseCode': _controllerUserName.text,
    // });

    // int currentDate= DateTime.now().millisecondsSinceEpoch;
    int currentDate= DateTime.now().microsecondsSinceEpoch;
    String pswd = "";
    if(_controllerPswd.text.isNotEmpty){
      pswd = CommanMethod().encryptText(_controllerPswd.text);
    }

    // if(ots!.isNotEmpty){
    //   ots="$ots";
    // }

    String dataForEncryption = '{"flag": "admin","email": "${isLoginWithMobile?"":_controllerUser.text}","password": "$pswd","ots":"$ots","type": "$type","captcha": "${_controllerCaptcha.text}","mobile": "${isLoginWithMobile?_controllerUser.text:""}","otp": "${_controllerOTP.text}","otc": "$otc","secure": $dataObjSecure,"check": $currentDate,"token": "$token"}';

    String data ='"data": {"flag": "admin","email": "${isLoginWithMobile?"":_controllerUser.text}","password": "$pswd","ots": "$ots","type": "$type","captcha": "${_controllerCaptcha.text}","mobile": "${isLoginWithMobile?_controllerUser.text:""}","otp": "${_controllerOTP.text}","otc": "$otc","secure": $dataObjSecure,"check": $currentDate,"token": "$token"}';

    secure = CommanMethod().encryptText(dataForEncryption);

    var jsonRequest =
        '{$data,"secure": "$secure"}';

    // final publicPem = await rootBundle.loadString('assets/publ.pem');
    //
    // final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
    //
    // String? encryptedData = CommanMethod().encrypt(jsonRequest,publicKey);
    //
    // var jsonEncryptedRequest = jsonEncode(<String, dynamic>{
    //   'encryptedData': encryptedData,
    // });

    try {
      final response = await http
          .post(
          Uri.parse(
              'https://prabandh.education.gov.in/apitesting/auth/user/login'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonRequest)
          .timeout(const Duration(seconds: 10));

      print('${response.statusCode}\n${response.request}\n${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        final responseData = jsonDecode(response.body);

        String status = responseData['status'].toString();
        if (status == "true") {



          CommanMethod.decodedToken = JwtDecoder.decode(responseData['token'].toString());
          CommanMethod.token=responseData['token'].toString();
          print('TOKEN: ${CommanMethod.token}');



          // CommanMethod().decryptText(, '8fac2bb68ff0a57ee01d379a92ebf5d0e65a4648');
          CommanWidget().showToast("Login successfully");
               Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoard()),
                  );

        } else {
          // Map<String,dynamic> error= responseData['errorDetails'];
          String msg = responseData['message'].toString();
          CommanWidget().showToast(msg);
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String responseCode =
        jsonResponse["errorDetails"]['responseCode'].toString();
        String type = jsonResponse["errorDetails"]['type'].toString();
        if (responseCode == '974' && type == 'invalid_authorization_token') {
          CommanWidget()
              .showToast('Invalid authorization token. Please login again');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isEmpty) {
          CommanWidget().showToast('Failed to post data');
        } else {
          CommanWidget()
              .showToast(jsonResponse["errorDetails"]['message'].toString());
        }
      }
    } on TimeoutException catch (ee) {
      CommanWidget().showToast('Timeout exception');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      CommanWidget().showToast('Failed to post data');

      setState(() {
        _isLoading = false;
        result = 'Error: $e';
      });
    }
  }

  visibility(){
    if((isLoginWithMobile && _isCheckedOTP) || sendOTP()){

    }
  }

  void cleanAllField() {

    _controllerUser.clear();
    _controllerCaptcha.clear();
    _controllerPswd.clear();
    _controllerOTP.clear();
    // setState(() {
      _isCheckedOTP=false;
      isOTPSend=false;

     visibilityOTP=false;
    visibilityPassword=true;
    visibilityCaptcha=true;
    visibilitySendOTPBUTTON=false;
    visibilityLoginBUTTON=true;
    // });
  }



  // Future<void> login() async {
  //   // var apiUrl =
  //   var result;
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //
  //   var jsonRequest = jsonEncode(<String, dynamic>{
  //     // 'udiseCode': _controllerUserName.text,
  //     "udiseCode":_controllerUserName.text,
  //     "password":_controllerPswd.text,
  //     "deviceId":""
  //   });
  //
  //
  //   try {
  //
  //     final response = await http.post(Uri.parse('http://164.100.68.163/AMSNICApi/api/validatePwdUdise'),
  //         headers: <String, String>{'Content-Type': 'application/json',},
  //         body: jsonRequest
  //     ).timeout(const Duration(seconds: 10));
  //
  //     print('${response.statusCode}\n${response.request}\n${response.body}');
  //
  //     if (response.statusCode == 200) {
  //
  //       setState(() {
  //         _isLoading = false;
  //       });
  //
  //       final encryptedData = jsonDecode(response.body);
  //       final responseData = jsonDecode(CommanMethod().AESDecrypt(encryptedData['encryptedData'].toString(),base64Encode(utf8.encode('b14ca5898a4e4133bbce2ea2315a1916')))!);
  //
  //       // Successful POST request, handle the response here
  //       // final responseData = jsonDecode(response.body);
  //
  //       String status = responseData['status'].toString();
  //       if(status == "true") {
  //
  //         // CommanMethod().login(context,loginTime,schoolCode,schoolName,villageName,blockName,districtName,stateName);
  //         // CommanMethod().secureLogin(context,loginTime,schoolCode,schoolName,villageName,blockName,districtName,stateName);
  //
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => Dashboard(title: 'Dashboard')),
  //         // );
  //
  //
  //       }else{
  //         // String msg= responseData['errorDetails'].toString();
  //         CommanWidget().showToast("Invalid username and password.");
  //
  //       }
  //       // String core = responseData['core'];
  //       // String pore = responseData['pore'];
  //       //
  //       // String decryptKey = EncryptData.decryptAES(core);
  //       // String decryptData = EncryptData.decryptAESWithKey(decryptKey, pore);
  //
  //
  //
  //     }else if(response.statusCode == 401){
  //
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       CommanWidget().showToast('Invalid authorization token. Please login again');
  //
  //       // Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       // String responseCode = jsonResponse["errorDetails"]['responseCode'].toString();
  //       // String type = jsonResponse["errorDetails"]['type'].toString();
  //       // if(responseCode == '974' && type == 'invalid_authorization_token'){
  //       //   CommanWidget().showToast('Invalid authorization token. Please login again');
  //       //   CommanMethod().logout();
  //       //   Navigator.pushAndRemoveUntil(
  //       //     context,
  //       //     // MaterialPageRoute(builder: (context) => SearchBy()),
  //       //     MaterialPageRoute(builder: (context) => Login()),
  //       //         (route) => false,
  //       //   );
  //       // }
  //
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //
  //       CommanWidget().showToast('Failed to post data');
  //
  //       // Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       // if(jsonResponse.isEmpty){
  //       //   CommanWidget().showToast('Failed to post data');
  //       // }else{
  //       //   CommanWidget().showToast(jsonResponse["errorDetails"]['message'].toString());
  //       // }
  //
  //     }
  //
  //   } on TimeoutException catch(ee){
  //     CommanWidget().showToast('Timeout exception');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }catch (e) {
  //     CommanWidget().showToast('Failed to post data');
  //     // Navigator.of(_loaderDialog.currentContext!,rootNavigator: true).pop();
  //     setState(() {
  //       _isLoading = false;
  //       result = 'Error: $e';
  //     });
  //   }
  // }

  // Future<bool> onVerified() async{
  //
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       // title:  Text('Select Reject Reason',style: TextStyle(fontSize: 16),),
  //       content:  Text('Do you want login with this school'),
  //       actions: <Widget>[
  //
  //
  //         Align(child: Text('District Name: $districtName'),alignment: Alignment.topLeft,),
  //         Align(alignment: Alignment.topLeft,child: Text('Block Name: $blockName'),),
  //         Align(alignment: Alignment.topLeft,child: Text('Village Name: $villageName'),),
  //         Align(alignment: Alignment.topLeft,child: Text('School Name: $schoolName'),),
  //
  //         Row(children: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(false),
  //             child:  Text('No'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 verifiedUser = true;
  //               });
  //               CommanWidget().showToast('User verified, Please enter password for login');
  //               Navigator.of(context).pop(false);
  //             },
  //             child:  Text('Yes'),
  //           ),
  //         ],)
  //
  //       ],
  //     ),
  //   )) ?? false;
  // }


}