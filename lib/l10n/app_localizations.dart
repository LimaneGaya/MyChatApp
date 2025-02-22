import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get enter_username;

  /// No description provided for @username_3to25.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 3 and 25 characters'**
  String get username_3to25;

  /// No description provided for @username_special.
  ///
  /// In en, this message translates to:
  /// **'Username must not contain special characters'**
  String get username_special;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enter_password;

  /// No description provided for @password_6to25.
  ///
  /// In en, this message translates to:
  /// **'Password must be between 6 and 25 characters'**
  String get password_6to25;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LogIn'**
  String get login;

  /// No description provided for @donthaveaccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get donthaveaccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get enter_name;

  /// No description provided for @name_3to25.
  ///
  /// In en, this message translates to:
  /// **'Name must be between 3 and 25 characters'**
  String get name_3to25;

  /// No description provided for @name_special.
  ///
  /// In en, this message translates to:
  /// **'Name must not contain special characters'**
  String get name_special;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @enter_age.
  ///
  /// In en, this message translates to:
  /// **'Please enter age'**
  String get enter_age;

  /// No description provided for @age_2character.
  ///
  /// In en, this message translates to:
  /// **'Age must be 2 characters'**
  String get age_2character;

  /// No description provided for @enter_valid_num.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enter_valid_num;

  /// No description provided for @must18older.
  ///
  /// In en, this message translates to:
  /// **'You have to be 18 or older to register'**
  String get must18older;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get already_have_account;

  /// No description provided for @delete_conver.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation?'**
  String get delete_conver;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @no_match.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get no_match;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Please refresh the page'**
  String get refresh;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @dislike.
  ///
  /// In en, this message translates to:
  /// **'Dislike'**
  String get dislike;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @lastseen.
  ///
  /// In en, this message translates to:
  /// **'Last seen: '**
  String get lastseen;

  /// No description provided for @nothingtoshow.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show here'**
  String get nothingtoshow;

  /// No description provided for @enter_feedback.
  ///
  /// In en, this message translates to:
  /// **'Please enter feedback'**
  String get enter_feedback;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get match;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @advices.
  ///
  /// In en, this message translates to:
  /// **'Advices'**
  String get advices;

  /// No description provided for @meetpeople.
  ///
  /// In en, this message translates to:
  /// **'Get to meet interesting people all around the world'**
  String get meetpeople;

  /// No description provided for @gettoknow.
  ///
  /// In en, this message translates to:
  /// **'Get to know people from all around the world'**
  String get gettoknow;

  /// No description provided for @matchwithpeople.
  ///
  /// In en, this message translates to:
  /// **'Match with people from all around the world'**
  String get matchwithpeople;

  /// No description provided for @tryluck.
  ///
  /// In en, this message translates to:
  /// **'Try your luck, match with people from all around the world, maybe it\'s the start of something beautiful'**
  String get tryluck;

  /// No description provided for @gotissue.
  ///
  /// In en, this message translates to:
  /// **'Got issue? Ask AI for help'**
  String get gotissue;

  /// No description provided for @aiwillhelp.
  ///
  /// In en, this message translates to:
  /// **'In App AI will help you with all sort of issues'**
  String get aiwillhelp;

  /// No description provided for @readytostart.
  ///
  /// In en, this message translates to:
  /// **'Ready to get started?'**
  String get readytostart;

  /// No description provided for @getstartednow.
  ///
  /// In en, this message translates to:
  /// **'Get started now!'**
  String get getstartednow;

  /// No description provided for @getstarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getstarted;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
