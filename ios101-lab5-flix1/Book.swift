
import Foundation

struct BookFeed: Decodable {
    let works: [Book]
}

struct Book: Decodable {
   
    let title: String
    let authors: [Author]
    let firstPublishYear: Int?
    let availability: Availability?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authors
        case firstPublishYear = "first_publish_year"
        case availability
    }
}

struct Author: Decodable {
    let key: String
    let name: String
}


struct Availability: Decodable {
    
    let isbn: String?
    enum CodingKeys: String, CodingKey {
        case isbn
    }
}

