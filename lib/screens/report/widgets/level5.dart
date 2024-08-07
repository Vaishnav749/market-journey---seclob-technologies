import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../resources/color.dart';
import '../../../services/report_service.dart';
import '../../../support/logger.dart';

class LevelFiveReport extends StatefulWidget {
  const LevelFiveReport({super.key});

  @override
  State<LevelFiveReport> createState() => _LevelFiveReportState();
}

class _LevelFiveReportState extends State<LevelFiveReport> {
  List<dynamic> Bonus = [];
  bool _isLoading = true;

  Future<void> _fetchBonus() async {
    try {
      var response = await IncomeService.report5();
      log.i('API Response: $response');

      setState(() {
        Bonus = response['creditBonusHistory'] ?? [];
        log.i('Bonus: $Bonus'); // Log the Bonus list
        _isLoading = false;
      });
    } catch (error) {
      log.e('Failed to fetch data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      log.e('Date format error: $e');
      return date;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBonus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation(yellow),
        ),
      );
    }

    if (Bonus.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 5),
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(color: whitegray),
            child: Center(
              child: Table(
                children: const [
                  TableRow(
                    children: [
                      Center(
                        child: Text("Sino",
                            style: TextStyle(
                                color: black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500)),
                      ),
                      Center(
                        child: Text("Date",
                            style: TextStyle(
                                color: black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500)),
                      ),
                      Center(
                        child: Text(" Bonus Amount",
                            style: TextStyle(
                                color: black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Table(
              children: Bonus.map<TableRow>((income) {
                return TableRow(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text(
                          '${Bonus.indexOf(income) + 1}',
                          style: TextStyle(
                              color: bluem,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        _formatDate(income['createdAt'] ?? "No Date"),
                        style: TextStyle(
                            color: bluem,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Center(
                      child: Text(
                        income['bonusAmount']?.toString() ?? "No Data",
                        style: TextStyle(
                            color: bluem,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
