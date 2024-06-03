import Foundation

struct User: Codable {
    var response: [UserInfomation]?
}

struct UserInfomation: Codable {
    var name: String?
    var kokoid: String?
}
