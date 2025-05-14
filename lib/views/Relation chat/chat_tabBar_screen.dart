import 'package:flutter/material.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/views/Relation%20chat/chat/inbox_screen.dart';
import 'package:heirloom/views/Relation%20chat/friend/friend_screen.dart';
import 'package:heirloom/views/Relation%20chat/requested/requested_screen.dart';

import '../../utils/app_colors.dart';

class ChatTabBarScreen extends StatelessWidget {
  const ChatTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: TabBar(
                labelColor: AppColors.textColor,
                unselectedLabelColor: AppColors.textColor,
                dividerColor: AppColors.dividerColor,
                indicatorColor: AppColors.dividerColor,
            indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                indicatorAnimation: TabIndicatorAnimation.linear,
                tabs: [
                  // Messages Tab
                  Tab(
                    child: const Center(
                      child: CustomTextTwo(text: "Chat"),
                    ),
                  ),
                  //Group Messages Tab
                  Tab(
                    child: const Center(
                      child: CustomTextTwo(text: "Requested"),
                    ),
                  ),
                  Tab(
                    child: const Center(
                      child: CustomTextTwo(text: "Friend"),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  InboxScreen(),
                  RequestedScreen(),
                   FriendScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
