struct Location: Decodable {
    let cityName: String
    let key: String
    let country: Country
    
    enum CodingKeys: String, CodingKey {
        case cityname = "LocalizedName"
        case key = "Key"
        case country = "Country"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try values.decode(String.self, forKey: .cityname)
        key = try values.decode(String.self, forKey: .key)
        country = try values.decode(Country.self, forKey: .country)
    }
}
