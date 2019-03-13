//
//  EmploeeTableView.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData

var myIndex = 0

var productCar: [ProductCore] = []

class EmploeeTableViewСontroller: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)

    var filteredProducts = [ProductCore]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchManaged = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
            productCar = try managedContext.fetch(fetchManaged) as? [ProductCore] ?? []
        } catch {
            print("failed fetch")
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredProducts.count
        }
        return productCar.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmploeee", for: indexPath)
        if isFiltering() {
            cell.textLabel?.text = filteredProducts[indexPath.row].name
        } else {
            cell.textLabel?.text = productCar[indexPath.row].name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let alertController = UIAlertController(title: "Вы действительно хотите удалить товар?",
                                                    message: "Товар будет удален без возможности восстановления",
                                                    preferredStyle: .alert)
            let alertActionDelete = UIAlertAction(title: "Удалить", style: .default) { (_) in
                myIndex = 0
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(productCar[indexPath.row])
                productCar.remove(at: indexPath.row)
                do {
                    try managedContext.save()
                    self.tableView.reloadData()
                } catch {
                    print("Невозможно удалить товар")
                }
            }
            let alertActionCancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            alertController.addAction(alertActionDelete)
            alertController.addAction(alertActionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            if let new = productCar.firstIndex(of: filteredProducts[indexPath.row]) {myIndex = new}
        } else {
            myIndex = indexPath.row
        }
        performSegue(withIdentifier: "emploeeeDetailSeque", sender: self)
    }

    @IBAction func exitClickBarButtonItem(_ sender: UIBarButtonItem) {
         navigationController?.popToRootViewController(animated: true)
    }

    func searchbarisEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredProducts = productCar.filter {(product: ProductCore) in
            return product.name.lowercased().contains(searchText.lowercased())
            }
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchbarisEmpty()
    }

}

extension EmploeeTableViewСontroller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let new = searchController.searchBar.text {filterContentForSearchText(new)}
    }
}
