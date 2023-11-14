//
//  ViewController.swift
//  ios101-lab5-flix1
//

import UIKit
import Nuke

// TODO: Add table view data source conformance
class ViewController: UIViewController, UITableViewDataSource {

    


    // TODO: Add table view outlet

    @IBOutlet weak var tableView: UITableView!
    
    // TODO: Add property to store fetched movies array
    private var books: [Book] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true


        // TODO: Assign table view data source
        tableView.dataSource = self

        fetchBooks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customary to call the overridden method on `super` any time you override a method.
        super.viewWillAppear(animated)

        // get the index path for the selected row
        if let selectedIndexPath = tableView.indexPathForSelectedRow {

            // Deselect the currently selected row
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: - Pass the selected movie data

        // Get the index path for the selected row.
        // `indexPathForSelectedRow` returns an optional `indexPath`, so we'll unwrap it with a guard.
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }

        // Get the selected movie from the movies array using the selected index path's row
        let selectedBook = books[selectedIndexPath.row]

        // Get access to the detail view controller via the segue's destination. (guard to unwrap the optional)
        guard let detailViewController = segue.destination as? DetailViewController else { return }

        detailViewController.book = selectedBook
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell

        // Get the movie associated table view row
        let book = books[indexPath.row]

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

    // Fetches a list of popular movies from the TMDB API
    private func fetchBooks() {

        // URL for the TMDB Get Popular movies endpoint: https://developers.themoviedb.org/3/movies/get-popular-movies
        let url = URL(string: "https://openlibrary.org/subjects/child.json?details=false")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)

        // ---
        // Create the URL Session to execute a network request given the above url in order to fetch our movie data.
        // https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
        // ---
        let session = URLSession.shared.dataTask(with: request) { data, response, error in

            // Check for errors
            if let error = error {
                print("🚨 Request failed: \(error.localizedDescription)")
                return
            }

            // Check for server errors
            // Make sure the response is within the `200-299` range (the standard range for a successful response).
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("🚨 Server Error: response: \(String(describing: response))")
                return
            }

            // Check for data
            guard let data = data else {
                print("🚨 No data returned from request")
                return
            }

            // The JSONDecoder's decode function can throw an error. To handle any errors we can wrap it in a `do catch` block.
            do {

                // Decode the JSON data into our custom `MovieResponse` model.
                let bookResponse = try JSONDecoder().decode(BookFeed.self, from: data)

                // Access the array of movies
                let books = bookResponse.works.filter { $0.availability?.isbn != nil }

                // Run any code that will update UI on the main thread.
                DispatchQueue.main.async { [weak self] in

                    // We have movies! Do something with them!
                    print("✅ SUCCESS!!! Fetched \(books.count) books")

                    // Iterate over all movies and print out their details.
                    for book in books {
                        print("📖 Book ------------------")
                        print("Title: \(book.title)")
                        print("Overview: \(book.authors)")
                    }

                    // TODO: Store movies in the `movies` property on the view controller
                    self?.books = books
                    self?.tableView.reloadData()


                }
            } catch {
                print("🚨 Error decoding JSON data into Book Response: \(error.localizedDescription)")
                return
            }
        }

        // Don't forget to run the session!
        session.resume()
    }


}
