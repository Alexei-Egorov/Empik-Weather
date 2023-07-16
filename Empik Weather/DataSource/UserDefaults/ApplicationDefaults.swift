import Foundation

class ApplicationDefaults: NSObject {
    class func setStrings(value: [String], forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    class func getArray(forKey key: String) -> [Any] {
        return UserDefaults.standard.array(forKey: key) ?? []
    }
    
    class func setDict(value: [String: String], forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    class func getDict(forKey key: String) -> [String: Any] {
        UserDefaults.standard.dictionary(forKey: key) ?? [:]
    }
}
