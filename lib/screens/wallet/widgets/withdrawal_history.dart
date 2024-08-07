import 'package:flutter/material.dart';
import 'package:master_journey/services/wallet_service.dart';
import 'package:master_journey/support/logger.dart';

import '../../../resources/color.dart';

class withdrawalhistory extends StatefulWidget {
  const withdrawalhistory({super.key});

  @override
  State<withdrawalhistory> createState() => _withdrawalhistoryState();
}

class _withdrawalhistoryState extends State<withdrawalhistory> {
  List<dynamic> walletWithdrawHistory = [];
  bool _isLoading = true;

  Future _getWithdrawalHistory() async {
    var response = await WalletService.wallet();
    log.i('withdrawal data show.... $response');
    setState(() {
      walletWithdrawHistory = response['walletWithdrawHistory'] ?? [];
      _isLoading = false;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _getWithdrawalHistory(),
      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return greenbg;
      case 'rejected':
        return appBlueColor;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Table(
            children: const [
              TableRow(
                children: [
                  Center(
                    child: Text("Amount",
                        style: TextStyle(color: black, fontSize: 12)),
                  ),
                  Center(
                    child: Text("TDS Amount",
                        style: TextStyle(color: black, fontSize: 12)),
                  ),
                  Center(
                    child: Text("Total Amount",
                        style: TextStyle(color: black, fontSize: 12)),
                  ),
                  Center(
                    child: Text("Status",
                        style: TextStyle(color: black, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: walletWithdrawHistory.length,
            itemBuilder: (BuildContext context, int index) {
              var item = walletWithdrawHistory[index];
              return Padding(
                padding: const EdgeInsets.only(right: 0, top: 10),
                child: Table(
                  columnWidths: const {},
                  children: [
                    TableRow(
                      children: [
                        Center(
                          child: Text(
                            '₹${item['requestedAmount'].toString()}',
                            style: TextStyle(
                              color: bluem,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            item['TDS'] != null ? item['TDS'].toString() : '',
                            style: TextStyle(
                              color: item['TDS'] != null
                                  ? greendark
                                  : appBlueColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            item['releasedAmount'] != null
                                ? '₹${item['releasedAmount'].toString()}'
                                : 'Not approved',
                            style: TextStyle(
                              color: item['releasedAmount'] != null
                                  ? greendark
                                  : appBlueColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 20,
                              margin: const EdgeInsets.symmetric(vertical: 0),
                              decoration: BoxDecoration(
                                color: _getStatusColor(item['status']),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                child: Text(
                                  item['status'] ?? '',
                                  style: const TextStyle(
                                    color: marketbg,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}