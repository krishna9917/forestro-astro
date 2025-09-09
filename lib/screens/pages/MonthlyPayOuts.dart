import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/PayoutsModel.dart';
import 'package:fore_astro_2/core/data/repository/dataLogsRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

Color getStatusColor(String type) {
  switch (type.toLowerCase()) {
    case "pending":
      return Color(0xFFFF8F00);
    case "cancelled":
      return Color.fromARGB(255, 255, 60, 0);
    case "cancel":
      return Color.fromARGB(255, 255, 60, 0);
    case "completed":
      return Color(0xFF00C853);
    default:
      return Color(0xFFFF8F00);
  }
}

class MouthlyPayOuts extends StatefulWidget {
  MouthlyPayOuts({super.key});

  @override
  State<MouthlyPayOuts> createState() => _MouthlyPayOutsState();
}

class _MouthlyPayOutsState extends State<MouthlyPayOuts> {
  bool loading = true;

  List<PayoutsModel> payouts = [];

  loadPayoutdata() async {
    try {
      Response response = await DataLogsRepo.payoutsLogs();

      setState(() {
        payouts = List.generate(response.data['data'].length,
            (index) => PayoutsModel.fromJson(response.data['data'][index]));
        loading = false;
      });
    } catch (e) {
      setState(() {
        payouts = [];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    loadPayoutdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monthly Pay-outs".toUpperCase()),
      ),
      body: Builder(builder: (context) {
        if (loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
              strokeCap: StrokeCap.round,
            ),
          );
        }
        if (payouts.isEmpty) {
          return Center(
            child: Text("No Payouts Found"),
          );
        }
        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: () async {
            await loadPayoutdata();
          },
          child: ListView.builder(
            itemCount: payouts.length,
            padding: EdgeInsets.all(18),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: PayoutBox(
                  payoutsModel: payouts[index],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class PayoutBox extends StatelessWidget {
  final PayoutsModel payoutsModel;
  const PayoutBox({
    super.key,
    required this.payoutsModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.windowWidth,
      padding: EdgeInsets.all(25),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${payoutsModel.startWeekDay} - ${payoutsModel.endWeekDay}',
                style: TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(
                      color: Color(0xFF908686),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    decoration: ShapeDecoration(
                      color: getStatusColor(payoutsModel.paymentStatus!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        payoutsModel.paymentStatus.toString().capitalize(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Text(
                '₹ ${payoutsModel.amount}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF201F1F),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
