import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPError: Error {
    case invalidURL
    case decodingError
}

protocol APIRequest {
    var method: HTTPMethod { get set }
    var path: String { get set }
    var parameters: [String: Any] { get set }
    var authorizationRequired: Bool { get set }
    var version: String { get set }
}

class RestService {
    static let shared = RestService()
    
    private init() { }
    
    public func performRequest<T: Decodable>(apiRequest: APIRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let urlString = NetworkDefaults.apiURLString(for: apiRequest.path).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: urlString) else {
            print("error making url from string: \(apiRequest.path)")
            completion(Result.failure(HTTPError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        if !apiRequest.parameters.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: apiRequest.parameters, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                fatalError("There should be data at this moment")
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(HTTPError.decodingError))
            }
        }
        task.resume()
    }
}
