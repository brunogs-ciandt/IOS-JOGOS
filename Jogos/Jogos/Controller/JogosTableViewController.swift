//
//  JogosTableViewController.swift
//  Jogos
//
//  Created by administrator on 4/4/22.
//

import UIKit
import CoreData

class JogosTableViewController: UITableViewController {

    var fetchedJogosResult:  NSFetchedResultsController<Jogo>!
    let label = UILabel();
    let searchBarController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Nao existe jogos cadastrados"
        label.textAlignment = .center
        
        searchBarController.searchResultsUpdater = self
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.searchBar.tintColor = .white
        searchBarController.searchBar.barTintColor = .white
        navigationItem.searchController = searchBarController
        
        searchBarController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        loadJogos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gameSegue"){
            let jogo = fetchedJogosResult.fetchedObjects![tableView.indexPathForSelectedRow!.row]
            let jogoView = segue.destination as! JogosViewController
            jogoView.jogo = jogo
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedJogosResult.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
    
        return count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchedJogosResult.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
        }
    }
    
    func loadJogos(with filter: String = "") {
        let fetchJogos: NSFetchRequest<Jogo> = Jogo.fetchRequest()
        do {
            let sortJogos = NSSortDescriptor(key: "title", ascending: true)
            fetchJogos.sortDescriptors = [sortJogos]
            
            if !filter.isEmpty {
                let predicate = NSPredicate(format: "title contains [c] %@", filter)
                fetchJogos.predicate = predicate
            }
            
            fetchedJogosResult = NSFetchedResultsController(fetchRequest: fetchJogos, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedJogosResult.delegate = self
            
            try fetchedJogosResult.performFetch()
        } catch {
            print("Erro carregar lista de jogos")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jogosCell", for: indexPath) as! JogosTableViewCell
        
        guard let game = fetchedJogosResult.fetchedObjects?[indexPath.row] else {
            return cell
        }

        cell.prepareGameCell(with: game)
        return cell
    }


}

extension JogosTableViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            tableView.reloadData()
        }
    }
}

extension JogosTableViewController : UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadJogos()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadJogos(with: searchBar.text!)
        tableView.reloadData()
    }
    
}
