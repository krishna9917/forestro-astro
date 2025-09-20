import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/CouponModel.dart';
import 'package:fore_astro_2/core/data/repository/couponRepo.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/CouponProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CouponProvider>().loadCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Coupons".toUpperCase()),
          bottom: TabBar(
              dividerColor: AppColor.primary.withOpacity(0.1),
              labelColor: AppColor.primary,
              overlayColor: MaterialStatePropertyAll(
                AppColor.primary.withOpacity(0.1),
              ),
              indicatorColor: AppColor.primary,
              tabs: const [
                Tab(text: "Chat Coupons"),
                Tab(text: "Audio Call Coupons"),
                Tab(text: "Video Call Coupons"),
              ]),
        ),
        body: Consumer<CouponProvider>(builder: (context, state, child) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
              ),
            );
          }
          return TabBarView(children: [
            CouponListView(coupons: state.chatCoupons!),
            CouponListView(coupons: state.audioCallCoupons!),
            CouponListView(coupons: state.videoCallCoupons!),
          ]);
        }),
      ),
    );
  }
}

class CouponListView extends StatelessWidget {
  final List<CouponModel> coupons;
  const CouponListView({
    super.key,
    required this.coupons,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (coupons.isEmpty) {
        return const Center(
          child: Text("No Coupons Found"),
        );
      }
      return ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: CouponViewBox(
              coupon: coupons[index],
            ),
          );
        },
      );
    });
  }
}

class CouponViewBox extends StatefulWidget {
  final CouponModel coupon;
  const CouponViewBox({
    super.key,
    required this.coupon,
  });

  @override
  State<CouponViewBox> createState() => _CouponViewBoxState();
}

class _CouponViewBoxState extends State<CouponViewBox> {
  bool loading = false;

  activeCoupon() async {
    try {
      setState(() {
        loading = true;
      });
      Response response;
      if (widget.coupon.activeStatus == true) {
        response = await CouponRepo.deActiveCoupon(couponId: widget.coupon.id!);
      } else {
        response = await CouponRepo.activeCoupon(
            couponId: widget.coupon.id!, type: widget.coupon.type!);
      }

      await context.read<CouponProvider>().loadCoupons();
      showToast(response.data['message']);
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showToast("Field to update Coupon status");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CouponCard(
          height: 250,
          curvePosition: 130,
          curveRadius: 30,
          border: BorderSide(
            width: widget.coupon.activeStatus == true ? 6 : 2,
            color: AppColor.primary,
          ),
          curveAxis: Axis.horizontal,
          backgroundColor: Colors.white,
          firstChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.coupon.code.toString().toUpperCase(),
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColor.primary.withOpacity(0.7)),
              ),
              const SizedBox(height: 5),
              Text(
                "${widget.coupon.discount}${widget.coupon.discountType == "percent" ? "%" : " RS"} ",
                style:  GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
               Text(
                "OFF",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black26),
              ),
            ],
          ),
          secondChild: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "apply discount on your ${widget.coupon.type == "chat" ? "" : widget.coupon.type} chats",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: loading ? null : activeCoupon,
                  child: Text(
                    loading
                        ? widget.coupon.activeStatus == true
                            ? "Deactivating..."
                            : "Activating..."
                        : widget.coupon.activeStatus == true
                            ? "Deactivate".toUpperCase()
                            : "ACTIVATE",
                    style:  GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Builder(builder: (context) {
          if (widget.coupon.activeStatus != true) {
            return const SizedBox();
          }
          return Positioned(
            right: 20,
            top: 20,
            child: Icon(
              Icons.check_circle,
              color: AppColor.primary,
              size: 40,
            ),
          );
        }),
      ],
    );
  }
}
