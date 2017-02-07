//
//  DetailViewController.swift
//  Flicks
//
//  Created by Poojan Dave on 1/26/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //Outlet of the posterImageView, titleLabel, and overviewLabel
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    //Move that is to be displayed
    var movie: NSDictionary!
    
    //viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        //Retrieves and sets the title and overview
        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        
        //Use the baseURL and the posterPath URL to retrieve the image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        //Use if let to safely unwrap the postPath
        if let posterPath = movie["poster_path"] as? String {
            
            let posterURL = NSURL(string: baseURL + posterPath)
            posterImageView.setImageWith(posterURL! as URL)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
