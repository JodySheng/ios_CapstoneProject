import UIKit
import Nuke

class DetailViewController: UIViewController {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UIButton!
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            // 1.
            book.addToFavorites()
        } else {
            // 2.
            book.removeFromFavorites()
        }

    }
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        favoriteLabel.layer.cornerRadius = favoriteLabel.frame.width / 2


        if let unwrappedBook = book {
            print("unwrappedBook", unwrappedBook)
            
            if let isbn = unwrappedBook.availability?.isbn {
               let imageUrlString = "https://covers.openlibrary.org/b/isbn/" + isbn + "-S.jpg"
               
               if let imageUrl = URL(string: imageUrlString) {
                   // Use the Nuke library's load image function to (async) fetch and load the image from the image url.
                   Nuke.loadImage(with: imageUrl, into: coverImage)
               }
                isbnLabel.text = "ISBN: \(isbn)"
                }
                else {
                   isbnLabel.text = "ISBN not available"
               }


            
            // Assuming 'title' is a non-optional String
            titleLabel.text = unwrappedBook.title
            
            var authorsText = ""
            for author in unwrappedBook.authors {
                // Assuming 'author.name' is a non-optional String
                authorsText += author.name + " "
            }
            authorLabel.text = "Author: \(authorsText.isEmpty ? "N/A" : authorsText)"

            if let firstPublishYear = unwrappedBook.firstPublishYear {
                // Assuming 'firstPublishYear' is a non-optional String
                yearLabel.text = "Publish Year: \(firstPublishYear)"
            } else {
                yearLabel.text = "Publish Year not available"
            }
        } else {
            print("Error: 'book' is nil")
        }
        
        let favorites = Book.getBooks(forKey: Book.favoritesKey)
        // 2.
        if favorites.contains(book) {
            // 3.
            favoriteLabel.isSelected = true
        } else {
            // 4.
            favoriteLabel.isSelected = false
        }
    }
}
