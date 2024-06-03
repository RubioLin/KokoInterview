import Foundation

struct APIEndpoints {
    private static let baseUrl = "https://dimanyen.github.io"
    private static let userInformation = "/man.json"
    private static let friend1 = "/friend1.json"
    private static let friend2 = "/friend2.json"
    private static let friend3 = "/friend3.json"
    private static let friend4 = "/friend4.json"
    
    static let fetchUserInformation = baseUrl + userInformation
    static let fetchFriend1 = baseUrl + friend1
    static let fetchFriend2 = baseUrl + friend2
    static let fetchFriend3 = baseUrl + friend3
    static let fetchFriend4 = baseUrl + friend4
}

