//
//  CollectionViewController.swift
//  Flicks
//
//  Created by Poojan Dave on 1/14/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var networkErrorLabel: UIView!
    
    var movies: [NSDictionary]?

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        networkErrorLabel.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_ :)), for: UIControlEvents.valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequestForMovie()

        // Do any additional setup after loading the view.
    }
    
    func networkRequestForMovie () {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 2)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
//                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    
                    self.collectionView.reloadData()
                    
                    self.networkErrorLabel.isHidden = true
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    self.refreshControl.endRefreshing()
                    
                }
            } else {
                
                self.networkErrorLabel.isHidden = false
                
                self.collectionView.reloadData()
                
                self.networkRequestForMovie()
            }
        }
        task.resume()
        
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        self.collectionView.reloadData()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequestForMovie()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionTypeCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = movies![indexPath.row]
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        
//        cell.posterView.setImageWith(imageURL as! URL)
        
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
