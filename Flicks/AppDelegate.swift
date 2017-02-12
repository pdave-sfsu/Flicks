//
//  AppDelegate.swift
//  Flicks
//
//  Created by Poojan Dave on 1/11/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //window
    var window: UIWindow?

    //didFinishLaunchingWithOptions: First method that is called when app awakens
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //storyboard property
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //FOR NOW PLAYING
        
        //reference the Navigation Controller by using the Storyboard ID
        //Cast it as UINavigationController
        let nowPlayingNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        //reference the top View Contoller through Navigation Controller
        //Cast it as MoviesViewController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        
        //Change the endpoint to "now_playing"
        nowPlayingViewController.endpoint = "now_playing"
        
        //Change the tab Bar title to "Now Playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        
        //Adds the image onto the tab bar; 242px
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "nowPlaying24")
        
        //FOR TOP RATED
        
        //reference the Navigation Controller by using the Storyboard ID
        //Cast it as UINavigationController
        let topRatedNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        //reference the View Contoller through Navigation Controller
        //Cast it as MoviesViewController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        
        //Change the endpoint to "top_rated"
        topRatedViewController.endpoint = "top_rated"
        
        //Change the tab Bar title to "Top Rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        
        //Adds the image on the tab bar; 24px
        topRatedNavigationController.tabBarItem.image = UIImage(named: "topRated24")
        
        
        //FOR NOW PLAYING
        
        //reference the Navigation Controller by using the Storyboard ID
        //Cast it as UINavigationController
        let popularNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        //reference the top View Contoller through Navigation Controller
        //Cast it as MoviesViewController
        let popularViewController = popularNavigationController.topViewController as! MoviesViewController
        
        //Change the endpoint to "now_playing"
        popularViewController.endpoint = "popular"
        
        //Change the tab Bar title to "Now Playing"
        popularNavigationController.tabBarItem.title = "Popular"
        
        //Adds the image onto the tab bar; 242px
        popularNavigationController.tabBarItem.image = UIImage(named: "popular24")
        
        //Creating the TAB BAR
        
        //Initialized the tabBarController
        let tabBarController = UITabBarController()
        
        //Added the two view controllers to the tab bar
        tabBarController.viewControllers = [popularNavigationController, nowPlayingNavigationController, topRatedNavigationController]
        
        
        //initialize window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //rootViewController sets the initial view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

