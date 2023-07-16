struct ErrorRemote: Decodable {
    let code: String
    let message: String
    let reference: String
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Message"
        case reference = "Reference"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
        self.reference = try container.decode(String.self, forKey: .reference)
    }
}
