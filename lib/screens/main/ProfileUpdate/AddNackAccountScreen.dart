import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/constants/BankNames.dart';
import 'package:fore_astro_2/core/data/model/BankModel.dart';
import 'package:fore_astro_2/core/data/repository/bankRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/providers/bankAccoutProvider.dart';
import 'package:provider/provider.dart';

class AddBankAccountScreen extends StatefulWidget {
  final BankModel? bankModel;
  const AddBankAccountScreen({super.key, this.bankModel});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  String bankName = "";
  TextEditingController bankNumberController = TextEditingController();
  TextEditingController confirmBankNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();

  Future saveBankAccount() async {
    try {
      setState(() {
        loading = true;
      });
      Response response;
      if (widget.bankModel != null) {
        response = await BankRepo.updateNewBank(
          bankid: widget.bankModel!.id.toString(),
          name: bankName,
          accountNumber: bankNumberController.text,
          ifsc: ifscCodeController.text,
        );
      } else {
        response = await BankRepo.addNewBank(
          name: bankName,
          accountNumber: bankNumberController.text,
          ifsc: ifscCodeController.text,
        );
      }

      if (response.data['status'] == true) {
        showToast(response.data['message'] ?? "Bank Added Successfully");
        context.read<BankAccountProvider>().loadBankdata();
        navigateme.pop();
      } else {}
      setState(() {
        loading = false;
      });
    } on DioException catch (e) {
      Map? data = e.response?.data['data'];
      if (data != null) {
        showToast(
            data[data.keys.first][0] ?? "Bank Not Added. Try Again later");
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      showToast("Bank Not Added. Try Again later");

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.bankModel != null) {
      bankName = widget.bankModel!.name!;
      bankNumberController.text = widget.bankModel!.accountNumber!;
      ifscCodeController.text = widget.bankModel!.ifsc!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
            "${widget.bankModel != null ? "Update" : "Enter"} Bank Details"
                .toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SearchSelectBox(
                  title: "Bank Name",
                  list: bankNames.values.toList(),
                  hintText: "Select Your Bank",
                  initialItem: widget.bankModel?.name,
                  onListChanged: (e) {
                    setState(() {
                      bankName = e;
                    });
                  },
                ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "Bank Account Number",
                  keyboardType: TextInputType.number,
                  textEditingController: bankNumberController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter Your Account Number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "Confirm Bank Account Number",
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textEditingController: confirmBankNumberController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter Confirm Account Number";
                    }
                    if (e != bankNumberController.text) {
                      return "Account Number Not be Match!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "IFSC Code",
                  textEditingController: ifscCodeController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter Bank IFSC Code";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: context.windowWidth,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              if (bankName.isEmpty) {
                                showToast("Please Select Your Bank");
                              } else {
                                saveBankAccount();
                              }
                            }
                          },
                    child: Text(
                      loading ? "Saving Bank info.." : "Save Bank Details",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
