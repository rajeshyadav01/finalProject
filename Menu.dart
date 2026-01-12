import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:prabandh_app/DashBoard.dart';
import 'package:prabandh_app/Support.dart';
import 'package:prabandh_app/UserManagement.dart';
import 'package:prabandh_app/presentation/resources/app_resources.dart';
import 'package:prabandh_app/util/extensions/color_extensions.dart';
import 'package:flutter/material.dart';


// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:async/async.dart';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CommanMethod.dart';
import 'CommanWidget.dart';
import 'Reports.dart';

class Menu extends StatefulWidget {
  final Color leftBarColor = AppColors.contentColorYellow;
  final Color rightBarColor = AppColors.contentColorRed;
  final Color avgColor =
  AppColors.contentColorOrange.avg(AppColors.contentColorRed);
  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
  ];




  String text = "HelloRajesh";






  final double width = 15;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  bool annulClicked=false;

  @override
  void initState() {
    super.initState();

    String encrypted = CommanMethod().encryptText(text);
    print(encrypted);

    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      // barGroup3,
      // barGroup4,
      // barGroup5,
      // barGroup6,
      // barGroup7,
    ];



    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getCaptchaData();
  //   login();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<List<String>> menuItems=[
      ['assets/images/ic_menu_dashboard.png','Dashboard',],
      ['assets/images/ic_menu_user_management.png','User Management',],
      ['assets/images/ic_menu_annual_work_plan.png','Annual Work Plan',],
      ['assets/images/ic_menu_fund_management.png','Fund Management',],
      ['assets/images/ic_menu_osc.png','KGBV',],
      ['assets/images/ic_menu_reports.png','Reports',],
      ['assets/images/ic_menu_support.png','Support',],


    ];
    var items = [
      'AWP&B',
      'PAAB',//'Progress Against\nApproved Budget',
      'OSC',//'Out of School\n Child',
    ];
    List<String> financeYear = [
      '2023-2024',
      '2024-2025',
      '2025-2026',
    ];
    String dropdownvalue = 'AWP&B';
    String dropdownFinanceValue = '2023-2024';

    return Scaffold(

      body: Container(
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
              Color.fromRGBO(255, 169, 169, 0.34),
              // Color.fromRGBO(255, 169, 169, 0.34),
              // Color.fromRGBO(237, 237, 237, 0.4),

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

        child: Column(
          children: [
            SizedBox(height: 15,),
            //Header
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80.0,
                  // margin: EdgeInsets.only(top: 10),
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
                            SizedBox(width: 5,),

                            Container(color: Color(0xFFF1F1F1),
                            width: 1,height: 30,),

                            SizedBox(width: 5,),
                            Text('PRABANDH',//appLocalizations.translate('school_confirmation'),
                              style: TextStyle(fontSize: 16.0,fontFamily: 'NunitoExtraBold',fontWeight: FontWeight.w800),),
                            SizedBox(width: 45,),
                            CircleAvatar(
                              radius: 20,
                            backgroundImage: AssetImage('assets/images/ic_profile.png'),),
                            SizedBox(width: 5,),
                            Container(color: Color(0xFFF1F1F1),
                              width: 1,height: 25,),
                            SizedBox(width: 5,),
                            InkWell(
                              onTap: (){

                                CommanWidget().alertDialog(context, "Logout", "Do you want logout?");

                              },
                              child: Image.asset(
                              'assets/images/logout.png', // Replace with your image path
                              // Adjust fit as needed (e.g., BoxFit.contain, BoxFit.fill)
                            ),)

                          ],
                        )
                    ),)
              ),
            ),
            Container(
              // height: 60,
              margin: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Row(children: [

                Expanded(flex:1,child: Container(
                  decoration:BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color: Colors.white,),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child: Column(children: [
                      Text("Dashboard"),
                      Text("Plan Year:2025-2026",style: TextStyle(fontSize: 10,fontFamily: 'UbuntuRegular',color: Color(0xFF000000),fontWeight: FontWeight.w200)),
                    ],),),
                  ),),),
                // Expanded(flex:1,child: Container(margin: EdgeInsets.only(left: 5),decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),child: Center(child:
                // DropdownButtonHideUnderline(child: DropdownButton(
                //     value: dropdownvalue,
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     items: items.map((String items) {
                //       return DropdownMenuItem(value: items, child: Text(items,style: TextStyle(fontSize: 12,fontFamily: 'UbuntuRegular',color: Color(0xFF000000),fontWeight: FontWeight.w200),));
                //     }).toList(), onChanged: (String? newValue){
                //   setState(() {
                //     dropdownvalue = newValue!;
                //   });
                // })))),),
                Expanded(flex:1,child: Container(margin: EdgeInsets.only(left: 5),decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),child: Center(child: 
                DropdownButtonHideUnderline(child: DropdownButton(
                    value: dropdownFinanceValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: financeYear.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items,style: TextStyle(fontSize: 12,fontFamily: 'UbuntuRegular',color: Color(0xFF000000),fontWeight: FontWeight.w200),));
                    }).toList(), onChanged: (String? newValue){
                  setState(() {
                    dropdownFinanceValue = newValue!;
                  });
                })))),),

              ],),
            ),

            Expanded(child: Container(
              color: Colors.white,
              height: screenHeight,
              margin: EdgeInsets.only(left: 10.0,right: 10.0,),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (BuildContext context, int index){

                      return InkWell(
                        onTap: (){
                          // CommanWidget().showToast(menuItems[index][1]);
                          if(menuItems[index][1]=='Dashboard'){
                            CommanMethod.footerClicked=1;
                            Navigator.of(context).push(PageRouteBuilder(

                              pageBuilder: (context, animation, secondaryAnimation) => DashBoard(),

                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);  // Start from the right
                                const end = Offset.zero; // End at the original position
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ));
                          }
                          if(menuItems[index][1]=='Support'){
                            Navigator.of(context).push(PageRouteBuilder(

                              pageBuilder: (context, animation, secondaryAnimation) => Support(),

                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);  // Start from the right
                                const end = Offset.zero; // End at the original position
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ));
                          }
                          if(menuItems[index][1]=='User Management'){
                            Navigator.of(context).push(PageRouteBuilder(

                              pageBuilder: (context, animation, secondaryAnimation) => UserManagement(),

                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);  // Start from the right
                                const end = Offset.zero; // End at the original position
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ));
                          }
                          if(menuItems[index][1]=='Reports'){
                            Navigator.of(context).push(PageRouteBuilder(

                              pageBuilder: (context, animation, secondaryAnimation) => Reports(),

                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);  // Start from the right
                                const end = Offset.zero; // End at the original position
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ));
                          }
                          if(menuItems[index][1]=='Annual Work Plan'){
                            setState(() {
                              if(annulClicked){
                                annulClicked=false;
                              }else{
                                annulClicked=true;
                              }

                            });
                          }else{
                            setState(() {
                              annulClicked=false;
                            });
                          }
                        },
                        child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(children: [

                          menuItems[index][1]=='Annual Work Plan'?Column(children: [
                            Row(children: [
                              Image.asset(
                                menuItems[index][0],
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 15,),
                              Text(menuItems[index][1],style: TextStyle(fontSize: 16.0,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w400),),
                              Expanded(child: SizedBox()),
                              annulClicked?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                            ],),
                            annulClicked?SizedBox(
                              // height: menuItems.length*20,
                              height: 40,
                              child: ListView(
                                children: [
                                  Container(margin: EdgeInsets.only(left: 40,top: 5),child: Text('Config plan/Fill Plan',style: TextStyle(fontSize: 12.0,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w400),),),
                                  Container(margin: EdgeInsets.only(left: 40,top: 5),child: Text('Submit District Plan',style: TextStyle(fontSize: 12.0,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w400),),)

                                  // Text('Submit District Plan'),
                                ],
                              ),


                            ):SizedBox.shrink(),
                          ],):Row(children: [
                            // ListTile(
                            //   leading: ImageIcon(AssetImage(menuItems[index][0]),size: 24,),
                            //   title: Text(menuItems[index][1],style: TextStyle(fontSize: 16.0,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w400),),
                            // )
                            // SizedBox(width: 10,),
                            Image.asset(
                              menuItems[index][0],
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 15,),
                            Text(menuItems[index][1],style: TextStyle(fontSize: 16.0,fontFamily: 'UbuntuRegular',fontWeight: FontWeight.w400),),
                          ],),
                          // annulClicked || menuItems[index][1]=='Annual Work Plan'?SizedBox(height: 50,child: ListView.builder(
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     shrinkWrap: true,
                          //     itemCount: 2,
                          //     itemBuilder: (BuildContext context, int index){
                          //       return Text('sdflsd');
                          //     }),):SizedBox.shrink()
                        ],)
                      ),);
                    }),
              ),
            )),


          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Card(
          margin: EdgeInsets.all(0.0),
          // elevation: 20,
          // height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)), // More rounded corners
            // side: BorderSide(color: Colors.white, width: 1.0), // Blue border
          ),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(flex:4,child: Center(child:
              TextButton(child: Text("Dashboard",style: TextStyle(fontSize: 16.0,color:CommanMethod.footerClicked==1?Color(0xFF665EF3):Color(0xFF686868),fontFamily: 'UbuntuRegular',fontWeight: CommanMethod.footerClicked==1?FontWeight.w700:FontWeight.w400)),onPressed: (){

                CommanMethod.footerClicked=1;
                Navigator.of(context).push(PageRouteBuilder(

                  pageBuilder: (context, animation, secondaryAnimation) => DashBoard(),

                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);  // Start from the right
                    const end = Offset.zero; // End at the original position
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));

              },),)),
              Expanded(flex:1,child: Center(child: Container(
                margin: EdgeInsets.only(top: 10,bottom: 10),
                color: Color(0xFFE5E5E5),
                width: 1,
              ),)),
              Expanded(flex:4,child: Center(child: TextButton(onPressed:(){
                CommanMethod.footerClicked=2;
                Navigator.of(context).push(PageRouteBuilder(

                  pageBuilder: (context, animation, secondaryAnimation) => Menu(),

                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Start from the right
                    const end = Offset.zero; // End at the original position
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));
                // CommanWidget().showToast("Menu");
              },child: Text("Menu",style: TextStyle(fontSize: 16.0,color: CommanMethod.footerClicked==2?Color(0xFF665EF3):Color(0xFF686868),fontFamily: 'UbuntuRegular',fontWeight: CommanMethod.footerClicked==2?FontWeight.w700:FontWeight.w400)),),)),
            ],
          ),
        ),
      ),

      // Column(
      //   children: [
      //     Text("Dashboard"),
      //
      //     // MultiBlocProvider(
      //     //   providers: [
      //     //     BlocProvider<AppCubit>(create: (BuildContext context) => AppCubit()),
      //     //   ],
      //     //   child: MaterialApp.router(
      //     //     title: AppTexts.appName,
      //     //     theme: ThemeData(
      //     //       brightness: Brightness.dark,
      //     //       useMaterial3: true,
      //     //       textTheme: GoogleFonts.assistantTextTheme(
      //     //         Theme.of(context).textTheme.apply(
      //     //           bodyColor: AppColors.mainTextColor3,
      //     //         ),
      //     //       ),
      //     //       scaffoldBackgroundColor: AppColors.pageBackground,
      //     //     ),
      //     //     routerConfig: appRouterConfig,
      //     //   ),
      //     // );
      //
      //     // PieChart(
      //     //   dataMap: dataMap,
      //     //   animationDuration: Duration(milliseconds: 800),
      //     //   chartLegendSpacing: 20,
      //     //   chartRadius: MediaQuery.of(context).size.width / 3,
      //     //   colorList: colorList,
      //     //   initialAngleInDegree: 0,
      //     //   chartType: ChartType.ring,  // Use 'ring' for donut chart
      //     //   ringStrokeWidth: 10,  // Adjust for the thickness of the donut
      //     //   centerText: '${feedPercentage.round()}%', // Optional center text
      //     //   centerTextStyle: TextStyle(
      //     //     // fontSize: 20,
      //     //     fontWeight: FontWeight.bold,
      //     //     color: Colors.black,
      //     //   ),
      //     //   // showChartValues: true,
      //     //   chartValuesOptions:ChartValuesOptions(
      //     //     // showChartValuesInPercentage: true,
      //     //     showChartValues: false,
      //     //     chartValueBackgroundColor: Colors.transparent,
      //     //     chartValueStyle: TextStyle(
      //     //
      //     //       color: Colors.white,  // Color of the text on the chart
      //     //
      //     //     ),
      //     //   ),
      //     //
      //     //   legendOptions: LegendOptions(
      //     //     showLegendsInRow: false,
      //     //     showLegends: false,
      //     //     legendPosition: LegendPosition.right,
      //     //     legendTextStyle: TextStyle(
      //     //       fontWeight: FontWeight.normal,
      //     //       fontSize: 14,
      //     //     ),
      //     //   ),),
      //
      //
      //
      //
      //     // SfCartesianChart(
      //     //   primaryXAxis: CategoryAxis(),
      //     //   // Chart title
      //     //   title: ChartTitle(text: 'Half yearly sales analysis'),
      //     //   // Enable legend
      //     //   legend: Legend(isVisible: true),
      //     //   // Enable tooltip
      //     //   tooltipBehavior: TooltipBehavior(enable: true),
      //     //   series: <CartesianSeries<_SalesData, String>>[
      //     //     LineSeries<_SalesData, String>(
      //     //       dataSource: data,
      //     //       xValueMapper: (_SalesData sales, _) => sales.year,
      //     //       yValueMapper: (_SalesData sales, _) => sales.sales,
      //     //       name: 'Sales',
      //     //       // Enable data label
      //     //       dataLabelSettings: DataLabelSettings(isVisible: true),
      //     //     ),
      //     //   ],
      //     // ),
      //   ],
      // ),
    );
  }



  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 10) {
      text = '10K';
    } else if (value == 20) {
      text = '20K';
    } else if (value == 30) {
      text = '30K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Elementary', 'Secondary', 'Wd', 'Tu', 'Fr', 'St', 'Su'];
    // final titles = <String>['Mn', 'Te'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        // fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
          borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.zero,bottomRight: Radius.zero),
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
          borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.zero,bottomRight: Radius.zero),
      //     rodStackItems: [
      //     BarChartRodStackItem(
      //     0, 8, Colors.blue,
      //     // Add text on top of the bar segment
      //     to:'8', // This is where you put the value
      //     text: 'Value 8', // This is for display
      //     textStyle: TextStyle(color: Colors.white, fontSize: 12),
      //   ),
      // ],
        ),
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
          borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.zero,bottomRight: Radius.zero),
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 7.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withValues(alpha: 1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ],
    );
  }

}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
