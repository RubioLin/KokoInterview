import Foundation

enum FriendsSection: String, CaseIterable {
    case friends
    case invitation
}

struct Friends: Codable, Hashable {
    var response: [FriendInformation]
}

struct FriendInformation: Codable, Hashable {
    var name: String
    var status: Int
    var isTop: String
    var fid: String
    var updateDate: String
}
