//
//  ConsoleManager.swift
//  Jogos
//
//  Created by administrator on 4/4/22.
//

import CoreData

class ConsoleManager {
    static let shared: ConsoleManager = ConsoleManager()
    var consoles: [Console] = []
    
    var fetchedConsolesResult:  NSFetchedResultsController<Console>!
    
    func loadConsoles(with context: NSManagedObjectContext){
        let fetchConsole: NSFetchRequest<Console> = Console.fetchRequest()
        do {
            let sortConsoles = NSSortDescriptor(key: "name", ascending: true)
            fetchConsole.sortDescriptors = [sortConsoles]
            
            consoles =  try context.fetch(fetchConsole)
        } catch {
            print("Erro carregar lista de consoles" + error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext){
        let console = consoles[index]
        context.delete(console)
        do {
            try context.save()
            consoles.remove(at: index)
        } catch {
            print("Erro ao excluir o console \(index)" + error.localizedDescription)
        }
    }
    
    private init(){
       // loadConsoles()
    }
    
}
