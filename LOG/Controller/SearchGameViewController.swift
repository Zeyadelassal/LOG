//
//  SearchGameViewController.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/8/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import UIKit

class SearchGameViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //The date for the table
    var games = [GBGame]()
    //We keep reference for the datatask session,so that we can cancel it when text in search bar changes
    var searchTask : URLSessionDataTask?
    
    var dataController : DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the data controller data from the tab bar controller
        let tabBarViewController = tabBarController as! TabBarViewController
        self.dataController = tabBarViewController.dataController
        
        //Configure the tap recongizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Name the title of this view controller
        parent?.navigationItem.title = "Search"
        parent?.navigationItem.rightBarButtonItem = nil

    }
    
    @objc func handleSingleTap(_ recoginzer:UITapGestureRecognizer){
        //Search bar is resigned when a table's cell is pressed(a game is selected)
        view.endEditing(true)
    }
    
    func showInfoAlert(_ message:String){
        let controller = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){action in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        present(controller,animated: true,completion: nil)
    }

}

//MARK : UIGestureReconginzerDelegate
extension SearchGameViewController : UIGestureRecognizerDelegate{
    //Gesture recongnizer detects wether the single touch was in the search bar or in the table view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBar.isFirstResponder
    }
}

//MARK : UISearchBarDelegate
extension SearchGameViewController : UISearchBarDelegate{
    
    //Each time the search bar text change , we cancel the current data task and starts a new one
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        //Cancel the current task
        if let searchTask = searchTask {
            searchTask.cancel()
        }
        //Search bar is empty
        if searchText == ""{
            self.games = [GBGame]()
            self.tableView.reloadData()
            return
        }
        //Check for internet connection before starting a new search
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            self.searchTask = GiantBombClient.sharedInstance().searchGame(searchText){(games,error) in
                self.searchTask = nil
                if let games = games{
                    self.games = games
                    performUIUpdatesOnMain{
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }else{
                    self.games = []
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }else{
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.showInfoAlert("Please check your internet connection")
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.games.count == 0 {
            self.showInfoAlert("No results!")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

//MARK : UITableViewDelegate + UITableViewDataSource
extension SearchGameViewController:UITableViewDelegate,UITableViewDataSource{
    
    //Number of cells of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "gameCell"
        print("index:\(indexPath.row)")
        print(games.count)
        let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let releaseDate = game.releaseDate.prefix(4)
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = String(releaseDate)
        if let imageURL = URL(string: game.imageIconString){
            if let imageData = try? Data(contentsOf: imageURL){
                cell.imageView?.image = UIImage(data:imageData)
            }else{
                cell.imageView?.image = UIImage(named: "placeholder")
            }
        }else{
            cell.imageView?.image = UIImage(named: "placeholder")
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let game = games[(indexPath as NSIndexPath).row]
        let controller = storyboard?.instantiateViewController(withIdentifier: "GameDetailsViewController") as! GameDetailsViewController
        controller.dataController = self.dataController
        controller.selectedGame = game
        
        navigationController?.pushViewController(controller, animated: true)
    }
  
}
