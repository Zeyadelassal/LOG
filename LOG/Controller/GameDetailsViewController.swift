//
//  GameDetailsViewController.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/9/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import UIKit
import CoreData

class GameDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var releaseDataLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var ratingButton: UIBarButtonItem!
    @IBOutlet weak var wishButton: UIBarButtonItem!
    
    //Game injected from search
    var selectedGame :   GBGame!
    var dataController : DataController!
    var fetchedResultsController : NSFetchedResultsController<Game>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        setupFetchedResultsController()
        if checkGame(){
            let game = fetchedResultsController.fetchedObjects?.first
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.configToggleIcons(game!)
                self.configLabels(fGame:game)
                self.configGameImage(fGame:game)
            }
        }else{
            getGameInfo()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedGame.name
    }
    
    //Fetch saved data from persistent store
    func setupFetchedResultsController(){
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.sortDescriptors = []
        let predicate = NSPredicate(format: "guid == %@", selectedGame.guid)
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print("Can't fetch data")
        }
    }
    
    //Check if the game already saved in the persistent store
    func checkGame()->Bool{
        if self.selectedGame.guid == fetchedResultsController.fetchedObjects?.first?.guid{
            print("Exist")
            return true
        }else{
            print("Not Exist")
            return false
        }
    }
    
    //Get selected game details
    func getGameInfo(){
        GiantBombClient.sharedInstance().getGameInfo(selectedGame.guid){(result,error) in
            if let error = error{
                print(error)
            }else{
                if let game = result{
                    self.selectedGame = game
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.configLabels(game:self.selectedGame)
                        self.configGameImage(game:self.selectedGame)
                    }
                }
            }
        }
    }
    
    //Configure the labels for game details
    func configLabels(game:GBGame?=nil,fGame:Game?=nil){
        if fGame == nil{
        self.nameLabel.text = game!.name
        self.developerLabel.text = game!.developer
        self.publisherLabel.text = game!.publisher
        self.releaseDataLabel.text = String(game!.releaseDate.prefix(10))
        self.themeLabel.text = game!.theme
        }
        if game == nil{
            self.nameLabel.text = fGame!.name
            self.developerLabel.text = fGame!.developer
            self.publisherLabel.text = fGame!.publisher
            self.releaseDataLabel.text = String(fGame!.releaseDate!.prefix(10))
            self.themeLabel.text = fGame!.theme
        }
    }
    
    //Present the game image
    func configGameImage(game:GBGame?=nil,fGame:Game?=nil){
        if fGame == nil{
            if let imageURL = URL(string: game!.imageString){
                if let imageData = try? Data(contentsOf: imageURL){
                    imageView.image = UIImage(data: imageData)
                }else{
                    imageView.image = UIImage(named: "placeholder")
                }
            }else{
                imageView.image = UIImage(named: "placeholder")
            }
            
        }
        
        if game == nil{
            if let imageString = fGame!.imageString{
                if let imageURL = URL(string: imageString){
                    if let imageData = try? Data(contentsOf: imageURL){
                        imageView.image = UIImage(data: imageData)
                    }else{
                        imageView.image = UIImage(named: "placeholder")
                    }
                }else{
                    imageView.image = UIImage(named: "placeholder")
                }
            }else{
                imageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    func configToggleIcons(_ game:Game){
        self.favButton.tintColor = (game.isFavorite) ? .red : .black
        self.wishButton.tintColor = (game.isWished) ? .red : .black
        self.ratingButton.tintColor = (game.isRated) ? .red : .black
    }
    
    @IBAction func viewGameDetails(_ sender: Any) {
        let gameURL = URL(string: selectedGame.detailURL)
        if UIApplication.shared.canOpenURL(gameURL!){
            UIApplication.shared.open(gameURL!, options: [:])
        }else{
            print("Invalid")
        }
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        setupFetchedResultsController()
        if checkGame(){
            let game = fetchedResultsController.fetchedObjects?.first
            if (game?.isFavorite)!{
                game?.isFavorite = false
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game!)
                }
                deleteGame(game!)
            }else{
                game?.isFavorite = true
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game!)
                }
            }
        }else{
            //Although it isn't saved in the store ,but the user may be favorite a game and put it in wishlist in the same time without reloading the view which will cause to save the same managed object two time in the store
                let game = Game(context: dataController.viewContext)
                configSelectedGame(game)
                game.isFavorite = true
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game)
                }
            }
        }
    
    
    @IBAction func toggleRating(_ sender: Any) {
        setupFetchedResultsController()
        if checkGame(){
            let game = fetchedResultsController.fetchedObjects?.first
            if((game?.isRated)!){
                game?.isRated = false
                game?.rating = 0.0
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                  self.configToggleIcons(game!)
                }
                deleteGame(game!)
            }else{
                game?.isRated = true
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game!)
                }
            }
        }else{
                let game = Game(context: dataController.viewContext)
                configSelectedGame(game)
                game.isRated = true
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game)
                }
            }
        }
    
    @IBAction func toggleWish(_ sender: Any) {
        setupFetchedResultsController()
        if checkGame(){
            let game = fetchedResultsController.fetchedObjects?.first
            if((game?.isWished)!){
                game?.isWished = false
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game!)
                }
                deleteGame(game!)
            }else{
                game?.isWished = true
                try? dataController.viewContext.save()
                performUIUpdatesOnMain {
                    self.configToggleIcons(game!)
                }
            }
        }else{
                let game = Game(context: dataController.viewContext)
                configSelectedGame(game)
                game.isWished = true
                performUIUpdatesOnMain {
                    self.configToggleIcons(game)
                }
                try? dataController.viewContext.save()
            }
        }
    
    //Config selected game managed object
    func configSelectedGame(_ game:Game){
        game.guid = self.selectedGame.guid
        game.name = self.selectedGame.name
        game.developer = self.selectedGame.developer
        game.publisher = self.selectedGame.publisher
        game.releaseDate = self.selectedGame.releaseDate
        game.theme = self.selectedGame.theme
        game.imageString = self.selectedGame.imageString
        game.iconImageString = self.selectedGame.imageIconString
        game.detailsURL = self.selectedGame.detailURL
        return
    }

    
    //Check for the game in the three lists ,so if itn't found in any of the lists ,then remove it frome the store
    func deleteGame(_ game:Game){
        if game.isFavorite == false && game.isWished == false && game.isRated == false{
            dataController.viewContext.delete(game)
            try? dataController.viewContext.save()
            print("Deleted")
        }
    }
    
}
