import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/PaymentHistoryCard.dart';
import 'package:fore_astro_2/core/data/model/PaymentHistoryModel.dart';
import 'package:fore_astro_2/core/data/repository/dataLogsRepo.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<PaymentHistoryModel> _PaymentHistory = [];
  bool loading = true;

  @override
  void initState() {
    loadPaymentHistory();
    super.initState();
  }

  Future loadPaymentHistory() async {
    try {
      Response response = await DataLogsRepo.myPaymentHistory();
      List<PaymentHistoryModel> data = List.generate(
        response.data['data'].length,
        (index) => PaymentHistoryModel.fromJson(response.data['data'][index]),
      );

      setState(() {
        _PaymentHistory = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        _PaymentHistory = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Payment History".toUpperCase())),
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () async {
          loadPaymentHistory();
        },
        child: Builder(
          builder: (context) {
            if (loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.primary,
                  strokeCap: StrokeCap.round,
                ),
              );
            }

            if (_PaymentHistory.isEmpty) {
              return const Center(
                child: Text("NO Payment History Found"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _PaymentHistory.length,
              itemBuilder: (context, index) {
                return PaymentListCard(log: _PaymentHistory[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
