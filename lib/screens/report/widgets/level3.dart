import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../resources/color.dart';
import '../../../services/report_service.dart';
import '../../../support/logger.dart';

class LevelThreeReport extends StatefulWidget {
  const LevelThreeReport({super.key});

  @override
  State<LevelThreeReport> createState() => _LevelReportState();
}

class _LevelReportState extends State<LevelThreeReport> {
  List<dynamic> levelIncome = [];
  bool _isLoading = true;

  Future<void> _fetchIncome() async {
    try {

      var response = await IncomeService.report3();



      log.i('Profile data show.... $response');
      setState(() {
        levelIncome = response['levelIncome'] ?? [];
        _isLoading = false;
      });
    } catch (error) {
      log.e('Failed to fetch data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initLoad() async {
    await Future.wait([
      _fetchIncome(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd ');
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(
        strokeWidth: 6.0,
        valueColor: AlwaysStoppedAnimation(yellow),
      ),);
    }

    if (levelIncome.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: levelIncome.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime formattedDate =
          DateTime.parse(levelIncome![index]['createdAt']);
          var income = levelIncome[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 80,
              width: 300,
              decoration: BoxDecoration(
                color: bluem,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/wallet.svg',
                      fit: BoxFit.none,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          income['name'] ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: marketbg,
                          ),
                        ),
                        Text(
                          income['reportName'] ?? "",
                          style: TextStyle(fontSize: 12, color: whitegray),
                        ),
                        Text(
                          dateFormat.format(formattedDate),
                          style: TextStyle(fontSize: 12, color: whitegray),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          income['amountCredited']?.toString() ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: marketbg,
                          ),
                        ),
                        Container(
                          height: 15,
                          width: 55,
                          decoration: BoxDecoration(
                            color: greenbg,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              income['status'] ?? "",
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }  );
  }
}