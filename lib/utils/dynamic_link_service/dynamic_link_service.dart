import 'package:FinXpress/screens/home/home.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          int id = deepLink.queryParameters['id'] as int;
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Home(pageIndex: id)));
        }
      }
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        if (deepLink.queryParameters.containsKey('id')) {
          int id = deepLink.queryParameters['id'] as int;
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Home(pageIndex: id)));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> createDynamicLink(int pageId, String title) async {
    String title_substring = title.substring(0, 10);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://app.finxpress.co',
      link: Uri.parse(
          'https://finbox.page.link.com/?id=$pageId&title=$title_substring'),
      androidParameters: AndroidParameters(
        packageName: 'com.finexpress',
        //   minimumVersion: 1,
      ),
      //TODO uncomment these for IOS
      // iosParameters: IosParameters(
      //   bundleId: 'your_ios_bundle_identifier',
      //   minimumVersion: '1',
      //   appStoreId: 'your_app_store_id',
      // ),
    );
    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl.toString();
  }
}
