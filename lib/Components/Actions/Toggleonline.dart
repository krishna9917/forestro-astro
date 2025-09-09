import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:provider/provider.dart';

class LiveToggleButton extends StatelessWidget {
  const LiveToggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dynamic state = _toggleMenuKey.currentState;
        state.showButtonMenu();
      },
      child: Container(
        width: 80,
        height: 30,
        decoration: ShapeDecoration(
          color: Color(0x2DFF6500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Consumer<UserProfileProvider>(builder: (context, state, child) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: ShapeDecoration(
                    color: (state.userProfileModel?.isOnline
                                .toString()
                                .toLowerCase() ==
                            "online")
                        ? Color(0xFF0DA300)
                        : Colors.grey,
                    shape: OvalBorder(),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${state.userProfileModel?.isOnline.toString().capitalize()}',
                  style: TextStyle(
                    color: Color(0xFFFF6500),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

final GlobalKey _toggleMenuKey = GlobalKey();
final toggleButtons = PopupMenuButton(
  key: _toggleMenuKey,
  color: Colors.white,
  surfaceTintColor: Colors.transparent,
  icon: LiveToggleButton(),
  itemBuilder: (context) => <PopupMenuItem<String>>[
    PopupMenuItem<String>(
      value: 'online',
      child: Text('Online'),
      onTap: () {
        context.read<UserProfileProvider>().toggleOnline(true);
      },
    ),
    PopupMenuItem<String>(
      value: 'offline',
      child: Text('Offline'),
      onTap: () {
        context.read<UserProfileProvider>().toggleOnline(false);
      },
    ),
  ],
);
