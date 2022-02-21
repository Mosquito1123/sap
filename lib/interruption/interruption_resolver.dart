import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sap/sap.dart';
import 'package:sap/models/gigya_models.dart';

/// Determines the relevant interruption resolver according to given error.
class ResolverFactory {
  final MethodChannel _channel;

  ResolverFactory(this._channel);

  dynamic getResolver(GigyaResponse response) {
    switch (response.errorCode) {
      case 403043:
        return LinkAccountResolver(_channel);
      case 206001:
        return PendingRegistrationResolver(_channel);
      case 206002:
        return PendingVerificationResolver(response.regToken);
      default:
        return null;
    }
  }
}

/// Resolver used for link account flow interruption.
class LinkAccountResolver with DataMixin {
  final MethodChannel _channel;

  LinkAccountResolver(this._channel) {
    getConflictingAccounts();
  }

  /// Get the user conflicting account object to determine how to resolve the flow.
  Future<ConflictingAccounts> getConflictingAccounts() async {
    final result = await _channel
        .invokeMapMethod<String, dynamic>('getConflictingAccounts');
    return ConflictingAccounts.fromJson(result ?? {});
  }

  /// Link social account to existing site account.
  Future<Map<String, dynamic>> linkToSite(
      String loginId,
      String password,
      ) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'linkToSite',
      {
        'loginId': loginId,
        'password': password,
      },
    ).catchError((error) {
      throw GigyaResponse.fromJson(decodeError(error));
    });
    return result;
  }

  /// Link site account to existing social account.
  Future<Map<String, dynamic>> linkToSocial(SocialProvider provider) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'linkToSocial',
      {
        'provider': provider.name,
      },
    ).catchError((error) {
      throw GigyaResponse.fromJson(decodeError(error));
    });
    return result;
  }
}

/// Resolver used for pending registration interruption.
class PendingRegistrationResolver with DataMixin {
  final MethodChannel _channel;

  PendingRegistrationResolver(this._channel);

  /// Set the missing account data in order to resolve the interruption.
  Future<Map<String, dynamic>> setAccount(Map<String, dynamic> map) async {
    final result = await _channel
        .invokeMapMethod<String, dynamic>('resolveSetAccount', map)
        .catchError((error) {
      debugPrint('setAccount Error: $error');
      throw GigyaResponse.fromJson(decodeError(error));
    });
    return result;
  }
}

/// Resolver used for pending verification interruption.
///
/// Use available [regToken] value to resolve.
class PendingVerificationResolver {
  final String _regToken;

  PendingVerificationResolver(this._regToken);

  String get regToken => _regToken;
}