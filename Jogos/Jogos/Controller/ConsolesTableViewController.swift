//
//  ConsolesTableViewController.swift
//  Jogos
//
//  Created by administrator on 4/4/22.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    
    @IBOutlet weak var btnAddConsole: UIBarButtonItem!
    
    let consoleManager = ConsoleManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadConsoles()
    }

    func loadConsoles(){
        consoleManager.loadConsoles(with: context)
        tableView.reloadData()
    }
    
    
    @IBAction func addEditConsole(_ sender: UIBarButtonItem) {
        showAlertConsole(with: nil)
    }
    
    func showAlertConsole(with console: Console?){
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField { txtAlert in
            txtAlert.placeholder = "Nome Plataforma"
            if let name = console?.name {
                txtAlert.text = name
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            
            do {
                try self.context.save()
                self.loadConsoles()
            } catch {
                print("Erro ao salvar console" + error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(named: "second")
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return consoleManager.consoles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consoleCell", for: indexPath)

        cell.textLabel?.text = consoleManager.consoles[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consoleManager.consoles[indexPath.row]
        showAlertConsole(with: console)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            consoleManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
