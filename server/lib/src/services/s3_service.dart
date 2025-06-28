// server/lib/src/services/s3_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:ride_hailing_shared/shared.dart';
import '../utils/error_codes.dart';

/// Service for AWS S3 file operations
class S3Service {
  static const String _className = 'S3Service';

  // AWS configuration
  static String? _accessKeyId;
  static String? _secretAccessKey;
  static String? _region;
  static String? _bucketName;

  // S3 endpoints
  static String get _s3Endpoint => 'https://s3.$_region.amazonaws.com';
  static String get _bucketEndpoint => '$_s3Endpoint/$_bucketName';

  // File constraints
  static const int _maxFileSize = 50 * 1024 * 1024; // 50MB
  static const int _presignedUrlExpiry = 3600; // 1 hour

  // Allowed file types
  static const Map<String, List<String>> _allowedFileTypes = {
    'images': ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    'documents': ['pdf', 'doc', 'docx', 'txt'],
    'videos': ['mp4', 'mov', 'avi', 'mkv'],
    'audio': ['mp3', 'wav', 'aac', 'm4a'],
  };

  /// Initialize S3 service with AWS credentials
  static void initialize({
    required String accessKeyId,
    required String secretAccessKey,
    required String region,
    required String bucketName,
  }) {
    _accessKeyId = accessKeyId;
    _secretAccessKey = secretAccessKey;
    _region = region;
    _bucketName = bucketName;
  }

  /// Generate presigned URL for file upload
  static Future<FileUploadResponse> generateUploadUrl(
    Session session, {
    required int userId,
    required String fileName,
    required String mimeType,
    required int fileSize,
    required FileCategory category,
    bool isPublic = false,
    Map<String, dynamic>? metadata,
    Duration? expiry,
  }) async {
    try {
      session.log('$_className: Generating upload URL for file: $fileName',
          level: LogLevel.info);

      _ensureInitialized();

      // Validate file
      final validationResult =
          _validateFile(fileName, mimeType, fileSize, category);
      if (!validationResult['isValid']) {
        throw Exception(validationResult['error']);
      }

      // Generate unique key
      final fileExtension = fileName.split('.').last.toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final key = _generateFileKey(userId, category, timestamp, fileExtension);

      // Generate presigned URL
      final expiryDuration = expiry ?? Duration(seconds: _presignedUrlExpiry);
      final presignedUrl = await _generatePresignedUploadUrl(
        key: key,
        mimeType: mimeType,
        fileSize: fileSize,
        expiry: expiryDuration,
        isPublic: isPublic,
        metadata: metadata,
      );

      // Generate download URL (for after upload)
      final downloadUrl = isPublic
          ? '$_bucketEndpoint/$key'
          : await _generatePresignedDownloadUrl(key, Duration(days: 365));

      final response = FileUploadResponse(
        uploadId: key,
        uploadUrl: presignedUrl['url']!,
        downloadUrl: downloadUrl,
        uploadHeaders: presignedUrl['headers'],
        maxFileSize: _maxFileSize,
        allowedMimeTypes: _getAllowedMimeTypes(category),
        expiresAt: DateTime.now().add(expiryDuration),
      );

      session.log('$_className: Upload URL generated for key: $key',
          level: LogLevel.info);
      return response;
    } catch (e, stackTrace) {
      session.log('$_className: Failed to generate upload URL: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.fileUploadUrlGenerationFailed);
    }
  }

  /// Upload file directly to S3
  static Future<String> uploadFile(
    Session session, {
    required int userId,
    required String fileName,
    required Uint8List fileData,
    required String mimeType,
    required FileCategory category,
    bool isPublic = false,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: Uploading file directly: $fileName',
          level: LogLevel.info);

      _ensureInitialized();

      // Validate file
      final validationResult =
          _validateFile(fileName, mimeType, fileData.length, category);
      if (!validationResult['isValid']) {
        throw Exception(validationResult['error']);
      }

      // Generate unique key
      final fileExtension = fileName.split('.').last.toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final key = _generateFileKey(userId, category, timestamp, fileExtension);

      // Upload to S3
      final success = await _uploadToS3(
        key: key,
        data: fileData,
        mimeType: mimeType,
        isPublic: isPublic,
        metadata: metadata,
      );

      if (!success) {
        throw Exception('Failed to upload file to S3');
      }

      session.log('$_className: File uploaded successfully: $key',
          level: LogLevel.info);
      return key;
    } catch (e, stackTrace) {
      session.log('$_className: Failed to upload file: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.fileUploadFailed);
    }
  }

  /// Download file from S3
  static Future<Uint8List?> downloadFile(
    Session session, {
    required String key,
  }) async {
    try {
      session.log('$_className: Downloading file: $key', level: LogLevel.info);

      _ensureInitialized();

      final url = '$_bucketEndpoint/$key';
      final headers = await _generateAuthHeaders('GET', key);

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        session.log('$_className: File downloaded successfully: $key',
            level: LogLevel.info);
        return response.bodyBytes;
      } else {
        session.log(
            '$_className: Failed to download file: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return null;
      }
    } catch (e, stackTrace) {
      session.log('$_className: Error downloading file: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Delete file from S3
  static Future<bool> deleteFile(
    Session session, {
    required String key,
  }) async {
    try {
      session.log('$_className: Deleting file: $key', level: LogLevel.info);

      _ensureInitialized();

      final url = '$_bucketEndpoint/$key';
      final headers = await _generateAuthHeaders('DELETE', key);

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 204) {
        session.log('$_className: File deleted successfully: $key',
            level: LogLevel.info);
        return true;
      } else {
        session.log(
            '$_className: Failed to delete file: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return false;
      }
    } catch (e, stackTrace) {
      session.log('$_className: Error deleting file: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Generate presigned download URL
  static Future<String> generateDownloadUrl(
    Session session, {
    required String key,
    Duration? expiry,
  }) async {
    try {
      session.log('$_className: Generating download URL for: $key',
          level: LogLevel.info);

      _ensureInitialized();

      final expiryDuration = expiry ?? Duration(hours: 1);
      return await _generatePresignedDownloadUrl(key, expiryDuration);
    } catch (e, stackTrace) {
      session.log('$_className: Failed to generate download URL: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.fileDownloadUrlGenerationFailed);
    }
  }

  /// List files in bucket with prefix
  static Future<List<S3Object>> listFiles(
    Session session, {
    String? prefix,
    int? maxKeys,
    String? continuationToken,
  }) async {
    try {
      session.log('$_className: Listing files with prefix: $prefix',
          level: LogLevel.info);

      _ensureInitialized();

      var url = '$_bucketEndpoint?list-type=2';
      if (prefix != null) {
        url += '&prefix=${Uri.encodeComponent(prefix)}';
      }
      if (maxKeys != null) {
        url += '&max-keys=$maxKeys';
      }
      if (continuationToken != null) {
        url += '&continuation-token=${Uri.encodeComponent(continuationToken)}';
      }

      final headers = await _generateAuthHeaders('GET', '', queryParams: {
        'list-type': '2',
        if (prefix != null) 'prefix': prefix,
        if (maxKeys != null) 'max-keys': maxKeys.toString(),
        if (continuationToken != null) 'continuation-token': continuationToken,
      });

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return _parseListObjectsResponse(response.body);
      } else {
        session.log(
            '$_className: Failed to list files: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return [];
      }
    } catch (e, stackTrace) {
      session.log('$_className: Error listing files: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Copy file within S3
  static Future<bool> copyFile(
    Session session, {
    required String sourceKey,
    required String destinationKey,
    Map<String, String>? metadata,
  }) async {
    try {
      session.log(
          '$_className: Copying file from $sourceKey to $destinationKey',
          level: LogLevel.info);

      _ensureInitialized();

      final url = '$_bucketEndpoint/$destinationKey';
      final headers = await _generateAuthHeaders('PUT', destinationKey);
      headers['x-amz-copy-source'] = '/$_bucketName/$sourceKey';
      headers['x-amz-metadata-directive'] =
          metadata != null ? 'REPLACE' : 'COPY';

      if (metadata != null) {
        metadata.forEach((key, value) {
          headers['x-amz-meta-$key'] = value;
        });
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        session.log('$_className: File copied successfully',
            level: LogLevel.info);
        return true;
      } else {
        session.log(
            '$_className: Failed to copy file: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return false;
      }
    } catch (e, stackTrace) {
      session.log('$_className: Error copying file: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Get file metadata
  static Future<Map<String, String>?> getFileMetadata(
    Session session, {
    required String key,
  }) async {
    try {
      session.log('$_className: Getting metadata for file: $key',
          level: LogLevel.info);

      _ensureInitialized();

      final url = '$_bucketEndpoint/$key';
      final headers = await _generateAuthHeaders('HEAD', key);

      final response = await http.head(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final metadata = <String, String>{};

        response.headers.forEach((key, value) {
          if (key.startsWith('x-amz-meta-')) {
            metadata[key.substring(11)] = value;
          }
        });

        metadata['content-type'] = response.headers['content-type'] ?? '';
        metadata['content-length'] = response.headers['content-length'] ?? '';
        metadata['last-modified'] = response.headers['last-modified'] ?? '';
        metadata['etag'] = response.headers['etag'] ?? '';

        return metadata;
      } else {
        session.log(
            '$_className: Failed to get file metadata: ${response.statusCode}',
            level: LogLevel.error);
        return null;
      }
    } catch (e, stackTrace) {
      session.log('$_className: Error getting file metadata: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return null;
    }
  }

  // Private helper methods

  static void _ensureInitialized() {
    if (_accessKeyId == null ||
        _secretAccessKey == null ||
        _region == null ||
        _bucketName == null) {
      throw Exception('S3 service not initialized');
    }
  }

  static Map<String, dynamic> _validateFile(
    String fileName,
    String mimeType,
    int fileSize,
    FileCategory category,
  ) {
    // Check file size
    if (fileSize > _maxFileSize) {
      return {
        'isValid': false,
        'error': ErrorCodes.fileSizeExceeded,
      };
    }

    // Check file extension
    final extension = fileName.split('.').last.toLowerCase();
    final allowedExtensions = _getAllowedExtensions(category);

    if (!allowedExtensions.contains(extension)) {
      return {
        'isValid': false,
        'error': ErrorCodes.fileTypeNotAllowed,
      };
    }

    // Check MIME type
    final allowedMimeTypes = _getAllowedMimeTypes(category);
    if (!allowedMimeTypes.contains(mimeType)) {
      return {
        'isValid': false,
        'error': ErrorCodes.fileTypeNotAllowed,
      };
    }

    return {'isValid': true};
  }

  static List<String> _getAllowedExtensions(FileCategory category) {
    switch (category) {
      case FileCategory.profileImage:
      case FileCategory.vehicleImage:
        return _allowedFileTypes['images']!;
      case FileCategory.document:
      case FileCategory.driverLicense:
      case FileCategory.insurance:
        return _allowedFileTypes['documents']!;
      case FileCategory.video:
        return _allowedFileTypes['videos']!;
      case FileCategory.audio:
        return _allowedFileTypes['audio']!;
      default:
        return [..._allowedFileTypes.values.expand((x) => x)];
    }
  }

  static List<String> _getAllowedMimeTypes(FileCategory category) {
    final extensions = _getAllowedExtensions(category);
    final mimeTypes = <String>[];

    for (final ext in extensions) {
      switch (ext) {
        case 'jpg':
        case 'jpeg':
          mimeTypes.add('image/jpeg');
          break;
        case 'png':
          mimeTypes.add('image/png');
          break;
        case 'gif':
          mimeTypes.add('image/gif');
          break;
        case 'webp':
          mimeTypes.add('image/webp');
          break;
        case 'pdf':
          mimeTypes.add('application/pdf');
          break;
        case 'doc':
          mimeTypes.add('application/msword');
          break;
        case 'docx':
          mimeTypes.add(
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
          break;
        case 'txt':
          mimeTypes.add('text/plain');
          break;
        case 'mp4':
          mimeTypes.add('video/mp4');
          break;
        case 'mov':
          mimeTypes.add('video/quicktime');
          break;
        case 'avi':
          mimeTypes.add('video/x-msvideo');
          break;
        case 'mkv':
          mimeTypes.add('video/x-matroska');
          break;
        case 'mp3':
          mimeTypes.add('audio/mpeg');
          break;
        case 'wav':
          mimeTypes.add('audio/wav');
          break;
        case 'aac':
          mimeTypes.add('audio/aac');
          break;
        case 'm4a':
          mimeTypes.add('audio/mp4');
          break;
      }
    }

    return mimeTypes;
  }

  static String _generateFileKey(
    int userId,
    FileCategory category,
    int timestamp,
    String extension,
  ) {
    final categoryPath = category.toString().split('.').last;
    return 'users/$userId/$categoryPath/$timestamp.$extension';
  }

  static Future<Map<String, dynamic>> _generatePresignedUploadUrl({
    required String key,
    required String mimeType,
    required int fileSize,
    required Duration expiry,
    required bool isPublic,
    Map<String, dynamic>? metadata,
  }) async {
    final expiresAt = DateTime.now().add(expiry);
    final expires = (expiresAt.millisecondsSinceEpoch ~/ 1000).toString();

    final headers = <String, String>{
      'Content-Type': mimeType,
      'Content-Length': fileSize.toString(),
    };

    if (isPublic) {
      headers['x-amz-acl'] = 'public-read';
    }

    if (metadata != null) {
      metadata.forEach((key, value) {
        headers['x-amz-meta-$key'] = value.toString();
      });
    }

    final authHeaders =
        await _generateAuthHeaders('PUT', key, headers: headers);
    headers.addAll(authHeaders);

    final queryParams = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential':
          '${_accessKeyId!}/${_getDateStamp()}/${_region!}/s3/aws4_request',
      'X-Amz-Date': _getTimestamp(),
      'X-Amz-Expires': expiry.inSeconds.toString(),
      'X-Amz-SignedHeaders': headers.keys.map((k) => k.toLowerCase()).join(';'),
    };

    final canonicalRequest =
        _buildCanonicalRequest('PUT', key, queryParams, headers);
    final signature = _generateSignature(canonicalRequest, 'PUT', key);
    queryParams['X-Amz-Signature'] = signature;

    final url = '$_bucketEndpoint/$key?' +
        queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');

    return {
      'url': url,
      'headers': headers,
    };
  }

  static Future<String> _generatePresignedDownloadUrl(
      String key, Duration expiry) async {
    final expiresAt = DateTime.now().add(expiry);
    final expires = (expiresAt.millisecondsSinceEpoch ~/ 1000).toString();

    final queryParams = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential':
          '${_accessKeyId!}/${_getDateStamp()}/${_region!}/s3/aws4_request',
      'X-Amz-Date': _getTimestamp(),
      'X-Amz-Expires': expiry.inSeconds.toString(),
      'X-Amz-SignedHeaders': 'host',
    };

    final canonicalRequest = _buildCanonicalRequest(
        'GET', key, queryParams, {'host': 's3.$_region.amazonaws.com'});
    final signature = _generateSignature(canonicalRequest, 'GET', key);
    queryParams['X-Amz-Signature'] = signature;

    return '$_bucketEndpoint/$key?' +
        queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
  }

  static Future<bool> _uploadToS3({
    required String key,
    required Uint8List data,
    required String mimeType,
    required bool isPublic,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final url = '$_bucketEndpoint/$key';
      final headers = await _generateAuthHeaders('PUT', key);
      headers['Content-Type'] = mimeType;
      headers['Content-Length'] = data.length.toString();

      if (isPublic) {
        headers['x-amz-acl'] = 'public-read';
      }

      if (metadata != null) {
        metadata.forEach((key, value) {
          headers['x-amz-meta-$key'] = value.toString();
        });
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: data,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, String>> _generateAuthHeaders(
    String method,
    String key, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final timestamp = _getTimestamp();
    final dateStamp = _getDateStamp();

    final authHeaders = <String, String>{
      'host': 's3.$_region.amazonaws.com',
      'x-amz-date': timestamp,
      'x-amz-content-sha256': 'UNSIGNED-PAYLOAD',
      ...?headers,
    };

    final canonicalRequest =
        _buildCanonicalRequest(method, key, queryParams ?? {}, authHeaders);
    final signature = _generateSignature(canonicalRequest, method, key);

    final credential =
        '${_accessKeyId!}/$dateStamp/${_region!}/s3/aws4_request';
    final signedHeaders =
        authHeaders.keys.map((k) => k.toLowerCase()).join(';');

    authHeaders['authorization'] =
        'AWS4-HMAC-SHA256 Credential=$credential, SignedHeaders=$signedHeaders, Signature=$signature';

    return authHeaders;
  }

  static String _buildCanonicalRequest(
    String method,
    String key,
    Map<String, String> queryParams,
    Map<String, String> headers,
  ) {
    final canonicalUri = '/$key';

    final sortedQueryParams = Map.fromEntries(
        queryParams.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    final canonicalQueryString = sortedQueryParams.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final sortedHeaders = Map.fromEntries(
        headers.entries.map((e) => MapEntry(e.key.toLowerCase(), e.value))
          ..sort((a, b) => a.key.compareTo(b.key)));
    final canonicalHeaders =
        sortedHeaders.entries.map((e) => '${e.key}:${e.value}\n').join('');

    final signedHeaders = sortedHeaders.keys.join(';');
    const payloadHash = 'UNSIGNED-PAYLOAD';

    return '$method\n$canonicalUri\n$canonicalQueryString\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
  }

  static String _generateSignature(
      String canonicalRequest, String method, String key) {
    final timestamp = _getTimestamp();
    final dateStamp = _getDateStamp();

    final algorithm = 'AWS4-HMAC-SHA256';
    final credentialScope = '$dateStamp/${_region!}/s3/aws4_request';
    final stringToSign =
        '$algorithm\n$timestamp\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest))}';

    final signingKey =
        _getSignatureKey(_secretAccessKey!, dateStamp, _region!, 's3');
    final signature =
        Hmac(sha256, signingKey).convert(utf8.encode(stringToSign));

    return signature.toString();
  }

  static List<int> _getSignatureKey(
      String key, String dateStamp, String regionName, String serviceName) {
    final kDate =
        Hmac(sha256, utf8.encode('AWS4$key')).convert(utf8.encode(dateStamp));
    final kRegion = Hmac(sha256, kDate.bytes).convert(utf8.encode(regionName));
    final kService =
        Hmac(sha256, kRegion.bytes).convert(utf8.encode(serviceName));
    final kSigning =
        Hmac(sha256, kService.bytes).convert(utf8.encode('aws4_request'));

    return kSigning.bytes;
  }

  static String _getTimestamp() {
    return DateTime.now()
            .toUtc()
            .toIso8601String()
            .replaceAll(RegExp(r'[:\-]'), '')
            .split('.')[0] +
        'Z';
  }

  static String _getDateStamp() {
    return DateTime.now()
        .toUtc()
        .toIso8601String()
        .split('T')[0]
        .replaceAll('-', '');
  }

  static List<S3Object> _parseListObjectsResponse(String xmlResponse) {
    // Simplified XML parsing - in production, use a proper XML parser
    final objects = <S3Object>[];

    final keyRegex = RegExp(r'<Key>(.*?)</Key>');
    final sizeRegex = RegExp(r'<Size>(\d+)</Size>');
    final lastModifiedRegex = RegExp(r'<LastModified>(.*?)</LastModified>');
    final etagRegex = RegExp(r'<ETag>"?(.*?)"?</ETag>');

    final keyMatches = keyRegex.allMatches(xmlResponse);
    final sizeMatches = sizeRegex.allMatches(xmlResponse);
    final lastModifiedMatches = lastModifiedRegex.allMatches(xmlResponse);
    final etagMatches = etagRegex.allMatches(xmlResponse);

    for (int i = 0; i < keyMatches.length; i++) {
      objects.add(S3Object(
        key: keyMatches.elementAt(i).group(1)!,
        size: int.parse(sizeMatches.elementAt(i).group(1)!),
        lastModified:
            DateTime.parse(lastModifiedMatches.elementAt(i).group(1)!),
        etag: etagMatches.elementAt(i).group(1)!,
      ));
    }

    return objects;
  }
}

/// S3 Object information
class S3Object {
  final String key;
  final int size;
  final DateTime lastModified;
  final String etag;

  S3Object({
    required this.key,
    required this.size,
    required this.lastModified,
    required this.etag,
  });
}
