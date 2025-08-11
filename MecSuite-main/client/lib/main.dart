import 'package:flutter/material.dart';
import 'package:elevarm_ui/elevarm_ui.dart';
import 'package:elevarm_icons/elevarm_icons.dart';

void main() {
  ElevarmFontFamilies.init();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ElevarmThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const AppBarExample()
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElevarmAppBarSearchAndAction(
        context: context,
        searchHintText: 'Cari kebutuhan harian di sini ...',
        actionWidgets: const [],
        callbackSubmittingSearch: (keyword) {},
      ),
      body: Center(
        child: ElevarmOutlineButton.text(
            text: 'Button CTA',
            onPressed: () {},
        ),
      ),
      bottomNavigationBar: ElevarmBottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {},
        items: [
          ElevarmBottomNavigationBarItem(
            labelText: 'Beranda',
            iconAssetName: ElevarmIconsOutline.airplay,
            iconColor: ElevarmColors.primary500,
          ),
          ElevarmBottomNavigationBarItem(
            labelText: 'Pembelanjaan',
            iconAssetName: ElevarmIconsOutline.airplay,
            badge: Container(
              height: 16,
              width: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ElevarmColors.danger,
              ),
              child: Center(
                child: Text(
                  '5',
                  style: ElevarmFontFamilies.inter(
                    fontSize: 10,
                    color: ElevarmColors.white,
                    fontWeight: ElevarmFontWeights.semibold,
                  ),
                ),
              ),
            ),
            iconColor: ElevarmColors.primary500,
          ),
          ElevarmBottomNavigationBarItem(
            labelText: 'Penjualan',
            iconAssetName: ElevarmIconsOutline.airplay,
            iconColor: ElevarmColors.primary500,
          ),
          ElevarmBottomNavigationBarItem(
            labelText: 'Akun',
            iconAssetName: ElevarmIconsOutline.airplay,
            iconColor: ElevarmColors.primary500,
          ),
        ],
    ),
    );
  }
}