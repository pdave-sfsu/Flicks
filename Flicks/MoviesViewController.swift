//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Poojan Dave on 1/11/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
//AfNetworking to retrieve the images
import AFNetworking
//progress HUD
import MBProgressHUD

//UITableViewDataSource & UITableViewDelegate for tableView
//UISearchBarDelegate for searchBar
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //tableView
    @IBOutlet weak var tableView: UITableView!
    
    //networkErrorView
    @IBOutlet weak var networkErrorView: UIView!
    
    //searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //refreshControl
    let refreshControl = UIRefreshControl()
    
    //complete movies list
    var movies: [NSDictionary]?
    
    //filteredData list, which includes the searched movies
    var filteredData: [NSDictionary]!
    
    //endpoint that can be changed
    var endpoint: String! = "now_playing"
    
    //variable to determine if progressBar is Showing
    var isProgressBarShowing = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the tableview to the MoviesViewController
        tableView.dataSource = self
        tableView.delegate = self
        
        //setting the searchBar to the MoviesViewController
        searchBar.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isHidden = true
        
        //turning the networkErrorView off
        networkErrorView.isHidden = true
        
        //setting the refreshControl to MoviesViewController and inserting it into the tableview
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_ :)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        
        //Turning on the ProgressBar and making a request for the movies
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequestForMovie()
        
        
    }
    
    //Makes the request for the movie
    func networkRequestForMovie () {
        
        //apikey and the url for retrieiving the movie
        //endpoint can be changed to top_rated or now_playing
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 2)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Trying to hide the progress bar and then turn it back on if it is not displaying
        //        var progressDisplaying = MBProgressHUD.hide(for: self.view, animated: true)
        
        //        if !progressDisplaying {
        //            MBProgressHUD.showAdded(to: self.view, animated: true)
        //        }
        
        if !isProgressBarShowing {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            isProgressBarShowing = true
        }
        
        print(endpoint)
        
        //Retrieving the movies from the API
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    print(dataDictionary)
                    
                    //stores the Dictionary of movies from API in movies property
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    
                    //filteredData is same as movies property
                    self.filteredData = self.movies!
                    
                    //reloads the tableView with new content
                    self.tableView.reloadData()
                    
                    self.collectionView.reloadData()
                    
                    //resets searchBar text
                    self.searchBar.text = ""
                    
                    //networkErrorView is hidden
                    self.networkErrorView.isHidden = true
                    
                    //Progressbar is hidden
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.isProgressBarShowing = false
                    
                    //refreshControl is over
                    self.refreshControl.endRefreshing()
                }
            } else {
                
                //networkErrorView is shown
                self.networkErrorView.isHidden = false
                
                //                MBProgressHUD.hide(for: self.view, animated: true)
                
                //Call the networkRequestForMovie again
                self.networkRequestForMovie()
            }
        }
        task.resume()
    }
    
    //tableView numberOfRowsInSection: Determines the number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Uses filteredData to determine the number of cells
        if let movies = filteredData {
            return movies.count
        } else {
            return 0
        }
    }
    
    //tableView cellForRowAt: Determines the actual content of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Make a cell of type MovieCell (within the Views); make sure to cast it
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        //Retrieve the movie from filteredData and retrieve the title and overview
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        //Change the title and overview labels
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        //Use the baseURL and the posterPath URL to retrieve the image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        //Use if let to safely unwrap the postPath
        if let posterPath = movie["poster_path"] as? String {
            
            //Retireve the image using the complete URL
            let imageRequest = NSURLRequest(url: NSURL(string: baseURL + posterPath) as! URL)
            
            //Change the image within the cell
            //Images will fade in if they are not cached
            cell.posterView.setImageWith(
                imageRequest as URLRequest,
                
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    
            })
        }
        
        print("row \(indexPath.row)")
        
        //Return the cell to be displayed
        return cell
    }
    
    //RefreshControlAction: is called when refreshBar is pulled
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        //Turn on the ProgressHUD and make the networkRequestForMove()
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequestForMovie()
    }

    //textDidChange: is called when the text is changed in the search bar
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String){
        
        //If the text is empty, then every movie is displayed.
        filteredData = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        
        //TableView is reloaded
        tableView.reloadData()
    }
    
    //TextDidBeginEditing: Whenever the user selects the search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //CancelButton is shown
        self.searchBar.showsCancelButton = true
    }
    
    //searchBarCancelButtonClicked: Whenever the user clicks the search bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        //CancelButton is removed
        searchBar.showsCancelButton = false
        
        //Removes the keyboard
        searchBar.resignFirstResponder()
        
        //TableViewis reloaded
        self.tableView.reloadData()
    }
    
    @IBAction func collectionViewChangeButton(_ sender: Any) {
        
        filteredData = movies
        
        if tableView.isHidden {
            tableView.isHidden = false
            collectionView.isHidden = true
            
//            refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_ :)), for: UIControlEvents.valueChanged)
//            collectionView.insertSubview(refreshControl, at: 0)
//            print("This did get run")
            
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
            
//            refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_ :)), for: UIControlEvents.valueChanged)
//            tableView.insertSubview(refreshControl, at: 0)
//            print("This did get run")
        }
        
        print("this worked")
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = filteredData {
            return movies.count
        } else {
            return 0
        }
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Make a cell of type MovieCell (within the Views); make sure to cast it
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        //Retrieve the movie from filteredData and retrieve the title and overview
        let movie = filteredData![indexPath.row]
        
        //Use the baseURL and the posterPath URL to retrieve the image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        //Use if let to safely unwrap the postPath
        if let posterPath = movie["poster_path"] as? String {
            
            //Retireve the image using the complete URL
            let imageRequest = NSURLRequest(url: NSURL(string: baseURL + posterPath) as! URL)
            
            //Change the image within the cell
            //Images will fade in if they are not cached
            cell.movieImageView.setImageWith(
                imageRequest as URLRequest,
                
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.movieImageView.alpha = 0.0
                        cell.movieImageView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.movieImageView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.movieImageView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    
            })
        }
        
        print("row \(indexPath.row)")
        
        //Return the cell to be displayed
        return cell

    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //If the sender can be seen as a tableViewCell
        //Going from cell to detailView
        if let cell = sender as? UITableViewCell {
            
            //IndexPath of cell
            let indexPath = tableView.indexPath(for: cell)
            
            //Specific movie retrieved
            let movie = filteredData![indexPath!.row]
            
            //segue.destination is cast as DetailViewController to access movie property
            let detailViewController = segue.destination as! DetailViewController
            
            //Set movie property with details of movie
            detailViewController.movie = movie
            
        } else if let cell = sender as? UICollectionViewCell {
            print ("This is a hit!")
            
            //IndexPath of cell
            let indexPath = collectionView.indexPath(for: cell)
            
            //Specific movie retrieved
            let movie = filteredData![indexPath!.row]
            
            //segue.destination is cast as DetailViewController to access movie property
            let detailViewController = segue.destination as! DetailViewController
            
            //Set movie property with details of movie
            detailViewController.movie = movie

        }
        
        print("prepare for segue")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
