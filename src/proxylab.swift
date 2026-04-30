import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public class Proxylab{
    private let api = "https://proxylab.live/api"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"*/*",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "Host":"proxylab.live",
        "Referer":"https://proxylab.live/",
        "Origin":"https://proxylab.live",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    public func my_ip() async throws -> Any {
        let urlString = "\(api)/myip"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func check_proxy(proxy: String) async throws -> Any {
        let urlString = "\(api)/check"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["text": proxy]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        let (responseData, _) = try await URLSession.shared.data(for: request)
        guard let content = String(data: responseData, encoding: .utf8) else {
            throw NSError(domain: "Encoding Error", code: -2)
        }
        let lines = content.components(separatedBy: .newlines)
        var jsonArray: [[String: Any]] = []
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty, 
                let lineData = trimmed.data(using: .utf8),
                let jsonObject = try? JSONSerialization.jsonObject(with: lineData) as? [String: Any] {
                    jsonArray.append(jsonObject)
                 }
        }
        return jsonArray
    }

    public func convert_proxy(proxy: String,format: String) async throws -> Any {
        let urlString = "\(api)/convert"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["text": proxy,"format": format]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: responseData)
        return json
    }

}
