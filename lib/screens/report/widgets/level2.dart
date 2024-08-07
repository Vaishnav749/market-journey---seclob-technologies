import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../resources/color.dart';
import '../../../services/report_service.dart';
import '../../../support/logger.dart';

class LevelTwoReport extends StatefulWidget {
  const LevelTwoReport({super.key});

  @override
  State<LevelTwoReport> createState() => _LevelTwoReportState();
}

class _LevelTwoReportState extends State<LevelTwoReport> {
  List<dynamic> inDirectIncome = [];
  bool _isLoading = true;

  Future<void> _fetchInDirectIncome() async {
    try {
      var response = await IncomeService.report2();
      log.i('API Response: $response');

      setState(() {
        inDirectIncome = response['inDirectIncome'] ?? [];
        log.i('inDirectIncome: $inDirectIncome');  // Log the inDirectIncome list
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
    _fetchInDirectIncome();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (inDirectIncome.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                      label: Text('Sino',
                          style: TextStyle(
                              color: black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(
                              color: black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text('AmountFrom',
                          style: TextStyle(
                              color: black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text('Franchise',
                          style: TextStyle(
                              color: black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text('Percentage',
                          style: TextStyle(
                              color: black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text('AmountCredited',
                          style: TextStyle(
                              color: black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500))),
                ],
                rows: inDirectIncome.map<DataRow>((income) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('${inDirectIncome.indexOf(income) + 1}',
                          style: TextStyle(color: bluem, fontSize: 12))),
                      DataCell(Text(_formatDate(income['createdAt'] ?? "No Date"),
                          style: TextStyle(
                              color: bluem,
                              fontSize: 12,
                              fontWeight: FontWeight.w600))),
                      DataCell(Text(income['name']?.toString() ?? "No Data",
                          style: TextStyle(
                              color: bluem,
                              fontSize: 12,
                              fontWeight: FontWeight.w600))),
                      DataCell(Text(income['franchise']?.toString() ?? "No Data",
                          style: TextStyle(
                              color: bluem,
                              fontSize: 12,
                              fontWeight: FontWeight.w600))),
                      DataCell(Text(income['percentageCredited']?.toString() ?? "No Data",
                          style: TextStyle(color: bluem, fontSize: 12))),
                      DataCell(Text(income['amountCredited']?.toString() ?? "No Data",
                          style: TextStyle(color: bluem, fontSize: 12))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}