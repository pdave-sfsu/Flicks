//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Poojan Dave on 1/11/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    
    var filteredData: [NSDictionary]!
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        networkErrorView.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_ :)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequestForMovie()
        
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String){
        
        filteredData = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        self.tableView.reloadData()

    }
    
    func networkRequestForMovie () {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 2)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
//        var progressDisplaying = MBProgressHUD.hide(for: self.view, animated: true)
        
//        if !progressDisplaying {
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//        }
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
//                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    
                    self.filteredData = self.movies!
                
                    self.tableView.reloadData()
                    
                    self.networkErrorView.isHidden = true
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    self.refreshControl.endRefreshing()
                    
                }
            } else {
                self.networkErrorView.isHidden = false
                
//                MBProgressHUD.hide(for: self.view, animated: true)
                
                self.tableView.reloadData()
                
                self.networkRequestForMovie()
            }
        }
        task.resume()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        self.tableView.reloadData()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequestForMovie()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = filteredData {
            return movies.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageRequest = NSURLRequest(url: NSURL(string: baseURL + posterPath) as! URL)
        
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
                // do something for the failure condition
        })
        
        print("row \(indexPath.row)")
        
        return cell
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
