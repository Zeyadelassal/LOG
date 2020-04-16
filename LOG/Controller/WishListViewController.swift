//
//  WishListViewController.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/11/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import UIKit
import CoreData

class WishListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataController : DataController!
    var fetchedResultsController : NSFetchedResultsController<Game>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarViewController = tabBarController as! TabBarViewController
        self.dataController = tabBarViewController.dataController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        parent?.navigationItem.title = "Wishlist"
        parent?.navigationItem.rightBarButtonItem = editButtonItem
        setupFetchedResultsController()
        updateEditButton()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    //To use the edit button in the view
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func setupFetchedResultsController(){
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        let predicate = NSPredicate(format: "isWished == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print("Can't fetch data")
        }
    }
    
    func deleteGame(at indexPath:IndexPath){
        let gameToDelete = fetchedResultsController.object(at: indexPath)
        let controller = UIAlertController(title: "Info", message: "Do you want to remove \(gameToDelete.name!) from the wishlist", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){action in
            gameToDelete.isWished = false
            self.checkDeletedGame(gameToDelete)
            try? self.dataController.viewContext.save()
            self.updateEditButton()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){action in controller.dismiss(animated: true, completion: nil)}
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller,animated: true,completion: nil)
    }
    
    
    func checkDeletedGame(_ game:Game){
        if game.isFavorite == false && game.isWished == false && game.isRated == false{
            dataController.viewContext.delete(game)
        }
    }
    
    func updateEditButton(){
        parent?.navigationItem.rightBarButtonItem?.isEnabled = fetchedResultsController.sections![0].numberOfObjects > 0
    }

}

//MARK : UITableViewDelegate + UITableViewDataSource
extension WishListViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "wishListCell"
        let game = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = game.name
        if let imageString = game.iconImageString{
            if let imageURL = URL(string: imageString){
                if let imageData = try? Data(contentsOf: imageURL){
                    cell.imageView?.image = UIImage(data: imageData)
                }else{
                    cell.imageView?.image = UIImage(named: "placeholder")
                }
            }else{
                cell.imageView?.image = UIImage(named: "placeholder")
            }
        }else{
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = fetchedResultsController.object(at: indexPath)
        let controller = storyboard?.instantiateViewController(withIdentifier: "GameDetailsViewController") as! GameDetailsViewController
        controller.dataController = self.dataController
        controller.selectedGame = GBGame(game: selectedGame)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                deleteGame(at: indexPath)
            default:
                print("Delete only available")
        }
    }
}

//MARK: NSFetchedResultsControllerDelegate
extension WishListViewController : NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            default:
                print("Other processes (insert,update,move) aren't used")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
