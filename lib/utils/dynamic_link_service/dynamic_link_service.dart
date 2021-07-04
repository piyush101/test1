import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinksService {
  Future<String> createDynamicLink(String page, String articleId) async {
    String uriPrefix = "https://app.finxpress.co";
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.parse(uriPrefix + '?page=$page&articleId=$articleId'),
        androidParameters: AndroidParameters(
          packageName: 'com.finexpress',
          // packageName: packageInfo.packageName,
          // minimumVersion: 125,
        ),
        // iosParameters: IosParameters(
        //   bundleId: packageInfo.packageName,
        //   minimumVersion: packageInfo.version,
        //   appStoreId: '123456789',
        // ),
        // googleAnalyticsParameters: GoogleAnalyticsParameters(
        //   campaign: 'example-promo',
        //   medium: 'social',
        //   source: 'orkut',
        // ),
        // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        //   providerToken: '123456',
        //   campaignToken: 'example-promo',
        // ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "Let's step forward towards financial journey with FinXpress",
          description: 'Get your app now.!!',
          // imageUrl: Uri.parse(
          //     "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),
        ));

    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }
}
