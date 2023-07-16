import Foundation

class SearchHistory {
    private static let SEARCH_HISTORY = "search_history"
    
    class func setSearchHistory(with dict: [String: String]) {
        ApplicationDefaults.setDict(value: dict, forKey: SEARCH_HISTORY)
    }
    
    class func getSearchHistory() -> [String: String] {
        let array = ApplicationDefaults.getDict(forKey: SEARCH_HISTORY) as! [String: String]
        return array
    }
}
