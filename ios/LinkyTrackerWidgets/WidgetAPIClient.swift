import Foundation

enum WidgetAPIClient {
    private static let defaultURL = "http://localhost:3000"
    private static let serverURLKey = "serverURL"

    private static var baseURL: URL {
        let defaults = UserDefaults(suiteName: "group.com.thibaut.linkytracker")
            ?? UserDefaults.standard
        let stored = defaults.string(forKey: serverURLKey) ?? defaultURL
        return URL(string: stored) ?? URL(string: defaultURL)!
    }

    private static var apiToken: String {
        let defaults = UserDefaults(suiteName: "group.com.thibaut.linkytracker")
            ?? UserDefaults.standard
        return defaults.string(forKey: "apiToken") ?? ""
    }

    static func fetchWidgetData() async throws -> WidgetData {
        let url = baseURL.appendingPathComponent("/widget/data")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = formatter.date(from: string) ?? fallbackFormatter.date(from: string) {
                return date
            }
            throw DecodingError.dataCorrupted(.init(
                codingPath: decoder.codingPath,
                debugDescription: "Invalid date: \(string)"
            ))
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try decoder.decode(WidgetDataResponse.self, from: data)
        return response.data
    }
}
