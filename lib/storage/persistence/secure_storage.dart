import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_crypto_kit/crypto_cipher/aes256gcm.dart';
import 'package:dart_crypto_kit/crypto_kdf/scrypt_key_derivation.dart';
import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/utils/extensions/random.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SECRET_KEY_NAME_PREFIX = "ss_";

/// Represents secure storage based on [SharedPreferences].
class SecureStorage {
  Future<SharedPreferences> preferences;

  SecureStorage(this.preferences);

  var keyStorage = FlutterSecureStorage();

  /// Encrypts data using secure key from [FlutterSecureStorage]
  /// and saves cipher text in [SharedPreferences].
  /// Returns true on success, false otherwise
  Future<bool> save(String data, String key) async {
    var secretKey = (await _getSecretKey(key)) ?? _createSecretKey(key);

    try {
      final encrypter = _getEncryptCipher(secretKey);

      var iv = IV.fromLength(16);
      var encryptedData;
      try {
        encryptedData = encrypter.encrypt(data, iv: iv);
      } catch (e, stacktrace) {
        print(stacktrace);
        print(e);
      }
      var keychainData = KeychainData.fromRaw(iv.bytes, encryptedData.bytes);
      await _saveKeychainData(keychainData, key);
    } catch (e, stacktrace) {
      print(stacktrace);
      return false;
    }

    return true;
  }

  /// Loads data by given key and decrypts it with secure key from [FlutterSecureStorage]
  /// Return decrypted data or null if it is not exists or decryption failed
  Future<String?> load(String key) async {
    var secretKey = await _getSecretKey(key);
    if (secretKey == null) return null;
    try {
      var keychainData = (await _loadKeychainData(secretKey))!;
      return _getEncryptCipher(secretKey)
          .decrypt64(String.fromCharCodes(keychainData.cipherText));
    } catch (e, stacktrace) {
      print(stacktrace);
      throw e;
    }
  }

  /// Encrypts data with given password
  /// and saves cipher text in [SharedPreferences].
  Future<bool> saveWithPassword(
      Uint8List data, String key, String password) async {
    Uint8List keyBytes = Uint8List(0);
    var passwordBytes = Uint8List.fromList(password.codeUnits);
    try {
      var seed = getSecureRandomSeed(16);
      keyBytes =
          _getKeyDerivation().derive(passwordBytes, seed, _kdfParams.bytes);
      var encryptedData = Aes256GCM(seed).encrypt(data, keyBytes);
      keyBytes.fillRange(0, keyBytes.length, 0);

      var keychainData = KeychainData.fromRaw(seed, encryptedData);
      await _saveKeychainData(keychainData, key);
      return true;
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e);
      return false;
    } finally {
      keyBytes.fillRange(0, keyBytes.length, 0);
      passwordBytes.fillRange(0, passwordBytes.length, 0);
    }
  }

  /// Loads data by given key and decrypts it with password.
  /// Return decrypted data or null if it is not exists or decryption failed
  Future<Uint8List?> loadWithPassword(String key, String password) async{
    Uint8List keyBytes = Uint8List(0);
    var passwordBytes = Uint8List.fromList(password.codeUnits);

    try {
      var keychainData =(await _loadKeychainData(key))!;
      var seed = keychainData.iv;
      keyBytes =
          _getKeyDerivation().derive(passwordBytes, seed, _kdfParams.bytes);
      return Aes256GCM(seed).decrypt(keychainData.cipherText, keyBytes);
    } catch (e, stacktrace) {
      print(stacktrace);
      throw e;
    } finally {
      keyBytes.fillRange(0, keyBytes.length, 0);
      passwordBytes.fillRange(0, passwordBytes.length, 0);
    }
  }

  /// Clears encrypted data entry for given key.
  clear(String key) async {
    await (await preferences).remove(key);
  }

  Future<KeychainData?> _loadKeychainData(String key) async {
    var jsonString = (await preferences).getString(key);
    if (jsonString == null || jsonString.isEmpty == true) return null;
    try {
      return KeychainData.getFromJson(json.decode(jsonString));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _getSecretKey(String name) async {
    try {
      var keyStorage = FlutterSecureStorage();
      return await keyStorage.read(key: name);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Encrypter _getEncryptCipher(String key) {
    return Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
  }

  String _createSecretKey(String name) {
    var key = String.fromCharCodes(Key.fromUtf8(name).bytes);
    keyStorage.write(key: name, value: key);
    return key;
  }

  _saveKeychainData(KeychainData data, String key) async {
    await (await preferences).setString(key, json.encode(data));
  }

  ScryptKeyDerivation _getKeyDerivation() {
    return ScryptKeyDerivation(_kdfParams.n, _kdfParams.r, _kdfParams.p);
  }

  static var _kdfParams = KdfAttributes('scrypt', 256, 2048, 1, 4, '');
}
