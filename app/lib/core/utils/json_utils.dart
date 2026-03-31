import 'dart:convert';

/// Safely decode a JSON string to a `List<String>`.
List<String> decodeStringList(String json) {
  try {
    return (jsonDecode(json) as List).cast<String>();
  } catch (_) {
    return [];
  }
}

/// Encode a `List<String>` to a JSON string.
String encodeStringList(List<String> list) => jsonEncode(list);
