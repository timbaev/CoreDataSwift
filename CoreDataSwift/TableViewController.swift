//
//  TableViewController.swift
//  CoreDataSwift
//
//  Created by Ildar Zalyalov on 11.12.2017.
//  Copyright © 2017 Ildar Zalyalov. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var models:[Company] = []
    
    lazy var persisnanceContainer: NSPersistentContainer? = {
       
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return delegate.persistentContainer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchAllModels()
        let predicate = NSPredicate(format: "age = %@", "0")
        fetchModels(with: predicate)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        saveNewModel()
        tableView.reloadData()
    }
    
    //MARK: - Custom methods
    
    func fetchAllModels() {
        
        
        persisnanceContainer?.performBackgroundTask({ (context) in
            
            
        })
        guard let context = persisnanceContainer?.viewContext else { return }
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        models = try! context.fetch(request)
        tableView.reloadData()
    }
    
    func fetchModels(with predicate: NSPredicate) {
        
        guard let context = persisnanceContainer?.viewContext else { return }
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.predicate = predicate
        
        models = try! context.fetch(request)
        tableView.reloadData()
    }

    func saveNewModel() {
        
        guard let context = persisnanceContainer?.viewContext else { return }
        
        let model = Company(context: context)
        model.name = "Some name"
        model.age = Int16(models.count)
        
        do {
          models.append(model)
          try context.save()
        }
        catch let error {
            print("Error when saving: \(error)")
        }
    }
    
    func removeModel(at indexPath: IndexPath) {
        
        guard let context = persisnanceContainer?.viewContext else { return }
        
        let model = models[indexPath.row]
        context.delete(model)
        
        do {
            models.remove(at: indexPath.row)
            try context.save()
        }
        catch let error {
            print("Error when saving: \(error)")
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func update(with indexPath: IndexPath) {
        
        guard let context = persisnanceContainer?.viewContext else { return }
        
        let model = models[indexPath.row]
        
        model.name = "Selected model"
        
        do {
            
            models[indexPath.row] = model
            
            try context.save()
        }
        catch let error {
            print("Error when saving: \(error)")
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let model = models[indexPath.row]
        
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = String(describing: model.age)
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            removeModel(at: indexPath)
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        update(with: indexPath)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
