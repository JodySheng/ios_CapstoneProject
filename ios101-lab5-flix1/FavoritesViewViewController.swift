//
//  FavoritesViewController.swift
//  ios101-lab7-flix
//

import UIKit
import Nuke

class FavoritesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyFavoritesLabel: UILabel!

    var favoriteBooks: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Anything in the defer call is guaranteed to happen last
        defer {
            // Show the "Empty Favorites" label if there are no favorite movies
            emptyFavoritesLabel.isHidden = !favoriteBooks.isEmpty
        }

        // TODO: Get favorite movies and display in table view
        // 1.
        let books = Book.getBooks(forKey: Book.favoritesKey)
        // 2.
        self.favoriteBooks = books
        // 3.
        tableView.reloadData()


    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteBooks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell

        // Get the movie associated table view row
        let book = favoriteBooks[indexPath.row]

        // Configure the cell (i.e. update UI elements like labels, image views, etc.)
        
        // Unwrap the optional poster path
        if let isbn = book.availability?.isbn,

            // Create a url by appending the poster path to the base url. https://developers.themoviedb.org/3/getting-started/images
           let imageUrl = URL(string: "https://covers.openlibrary.org/b/isbn/" + isbn + "-S.jpg") {

            // Use the Nuke library's load image function to (async) fetch and load the image from the image url.
            Nuke.loadImage(with: imageUrl, into: cell.coverImage)
        }

        // Set the text on the labels
        cell.titleLabel.text = book.title
        var authorsText = ""
        for author in book.authors {
            authorsText += author.name + " "
            
        }
        cell.authors.text = "\(authorsText)"

        // Return the cell for use in the respective table view row
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // MARK: - Pass the selected movie to the Detail View Controller

        // Get the index path for the selected row.
        // `indexPathForSelectedRow` returns an optional `indexPath`, so we'll unwrap it with a guard.
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }

        // Get the selected movie from the movies array using the selected index path's row
        let selectedBook = favoriteBooks[selectedIndexPath.row]

        // Get access to the detail view controller via the segue's destination. (guard to unwrap the optional)
        guard let detailViewController = segue.destination as? DetailViewController else { return }

        detailViewController.book = selectedBook
    }
}
