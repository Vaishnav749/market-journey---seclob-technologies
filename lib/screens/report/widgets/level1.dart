import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../resources/color.dart';
import '../../../services/report_service.dart';
import '../../../support/logger.dart';

class LevelOneReport extends StatefulWidget {
  const LevelOneReport({super.key});

  @override
  State<LevelOneReport> createState() => _LevelOneReportState();
}

class _LevelOneReportState extends State<LevelOneReport> {
  List<dynamic> directIncome = [];
  bool _isLoading = true;

  Future<void> _fetchDirectIncome() async {
    try {
      var response = await IncomeService.report1();
      log.i('API Response: $response');

      setState(() {
        directIncome = response['directIncome'] ?? [];
        log.i('directIncome: $directIncome');  // Log the inDirectIncome list
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
    _fetchDirectIncome();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (directIncome.isEmpty) {
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
                rows: directIncome.map<DataRow>((income) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('${directIncome.indexOf(income) + 1}',
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