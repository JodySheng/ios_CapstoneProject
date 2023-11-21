
import Foundation

struct BookFeed: Decodable, Encodable, Equatable {
    let works: [Book]
}

struct Book: Decodable, Encodable, Equatable {
   
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

extension Book {
    static var favoritesKey: String {
        return "Favorites"
    }
    
    static func save(_ books: [Book], forKey key: String) {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(books)
        // 3.
        defaults.set(encodedData, forKey: key)
    }
    
    static func getBooks(forKey key: String) -> [Book] {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        if let data = defaults.data(forKey: key) {
            // 3.
            let decodedBooks = try! JSONDecoder().decode([Book].self, from: data)
            // 4.
            return decodedBooks
        } else {
            // 5.
            return []
        }
    }
    
    func addToFavorites() {
        // 1.
        var favoriteBooks = Book.getBooks(forKey: Book.favoritesKey)
        // 2.
        favoriteBooks.append(self)
        // 3.
        Book.save(favoriteBooks, forKey: Book.favoritesKey)
    }
    
    func removeFromFavorites() {
        // 1.
        var favoriteBooks = Book.getBooks(forKey: Book.favoritesKey)
        // 2.
        favoriteBooks.removeAll { book in
            // 3.
            return self == book
        }
        // 4.
        Book.save(favoriteBooks, forKey: Book.favoritesKey)
    }
}

struct Author: Decodable, Encodable, Equatable {
    let key: String
    let name: String
}


struct Availability: Decodable, Encodable, Equatable {
    
    let isbn: String?
    enum CodingKeys: String, CodingKey {
        case isbn
    }
}

