// All API calls
// Includes schema conversion from the API returning JSON to parsed SmRecord
// Probably enough to decrypt and run it through a loop as the data is omio
class ApiClient {
  final String baseUrl = "http://localhost:8000/api";
  final String syncPushPoint = "/sync/push";
  final String syncPullPoint = "/sync/pull";
}
