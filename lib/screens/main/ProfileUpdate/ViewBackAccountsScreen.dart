import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/BankListBox.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/bankAccoutProvider.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/AddNackAccountScreen.dart';
import 'package:provider/provider.dart';

class ViewBankAccountScreen extends StatefulWidget {
  const ViewBankAccountScreen({super.key});

  @override
  State<ViewBankAccountScreen> createState() => _ViewBankAccountScreenState();
}

class _ViewBankAccountScreenState extends State<ViewBankAccountScreen> {
  @override
  void initState() {
    context.read<BankAccountProvider>().initLoadBanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("My Bank Accounts".toUpperCase()),
      ),
      body: Consumer<BankAccountProvider>(builder: (context, state, child) {
        if (state.bankModel == null) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
              strokeCap: StrokeCap.round,
            ),
          );
        }
        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: () async {
            await context.read<BankAccountProvider>().loadBankdata();
          },
          child: SizedBox(
            height: context.windowHeight,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    ...List.generate(
                      state.bankModel?.length ?? 0,
                      (index) {
                        return MyBackList(
                          bankModel: state.bankModel![index],
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        navigateme.push(routeMe(const AddBankAccountScreen()));
                      },
                      child: const AddNewBank(),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
