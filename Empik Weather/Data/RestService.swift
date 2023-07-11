import Foundation

class RestService {
    
    static let shared = RestService()
    let apiKey: String?
    
    private init() {
        apiKey = APIKey.apiKey
    }
}
