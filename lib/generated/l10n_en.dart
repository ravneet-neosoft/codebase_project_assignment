// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get userDirectory => 'User Directory';

  @override
  String get searchHint => 'Search by name...';

  @override
  String get noUsersFound => 'No users found.';

  @override
  String get userDetails => 'User Details';

  @override
  String get errorLoadingUsers => 'Error loading users';

  @override
  String get backOnline => 'You\'re back online!';

  @override
  String get offline => 'You\'re offline';

  @override
  String get errorMsg => 'Something went wrong. Please try again later.';

  @override
  String get serverError => 'Server Error, try again later';

  @override
  String get noInternetAndCached => 'No Internet and No Cached Data Found.';

  @override
  String get noInternet => 'No Internet Connection.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';
}
