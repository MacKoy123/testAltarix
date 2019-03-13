//
//  CustumerTableViewController.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData

var idCoast: Int = 0

var productForSell: [ProductCore] = []

var productForSellOpt: [ProductCore] = []

var productNotFilteredSell: [ProductCore] = []

var productNotFilteredSellOpt: [ProductCore] = []

class CustumerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var changerRetailWhosealersSegmentedControl: UISegmentedControl!

    var newType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if newType != nil {
            productForSell = productCar.filter {$0.coastSell != 0.0 && $0.type == self.newType}
            productForSellOpt = productCar.filter {$0.coastSellOpt != 0.0  && $0.type == self.newType}
        } else {
            productForSell = productCar.filter {$0.coastSell != 0.0}
            productForSellOpt = productCar.filter {$0.coastSellOpt != 0.0}
            productNotFilteredSell = productForSell
            productNotFilteredSellOpt = productForSellOpt
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch changerRetailWhosealersSegmentedControl.selectedSegmentIndex {
        case 0:
            return productForSell.count
        case 1 :
            return productForSellOpt.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCustumer", for: indexPath)
        switch changerRetailWhosealersSegmentedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = productForSell[indexPath.row].name
        case 1:
            cell.textLabel?.text = productForSellOpt[indexPath.row].name
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch changerRetailWhosealersSegmentedControl.selectedSegmentIndex {
        case 0:
            idCoast = 1
            if let newIndex = productCar.firstIndex(of: productForSell[indexPath.row]) {myIndex = newIndex}
        case 1:
            idCoast = 2
            if let newIndex = productCar.firstIndex(of: productForSellOpt[indexPath.row]) {myIndex = newIndex}
        default:
            break
        }
        performSegue(withIdentifier: "SellDetailSeque", sender: self)
    }

    @IBAction func changerRetailWhosealersSegmentedControl(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }

    @IBAction func changeCategoryBarButtonItem(_ sender: UIBarButtonItem) {
        let title = "Выберите тип товара"
        let typeProductAlertController = UIAlertController(title: title,
                                                           message: "\n\n\n\n\n\n\n\n",
                                                           preferredStyle: .alert)
        let pickerViewAlert = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerViewAlert.dataSource = self
        pickerViewAlert.delegate = self
        typeProductAlertController.view.addSubview(pickerViewAlert)
        let alertActionSelect = UIAlertAction(title: "Выбрать", style: .default) { (_) in
            productForSell = productNotFilteredSell.filter {$0.type == self.newType}
            productForSellOpt = productNotFilteredSellOpt.filter {$0.type == self.newType}
            self.tableView.reloadData()
        }
        let alertActionClear = UIAlertAction(title: "Сбросить", style: .default) { (_) in
            productForSell = productNotFilteredSell
            productForSellOpt = productNotFilteredSellOpt
            self.newType = nil
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .default)
        typeProductAlertController.addAction(alertActionSelect)
        typeProductAlertController.addAction(alertActionClear)
        typeProductAlertController.addAction(actionCancel)
        present(typeProductAlertController, animated: true, completion: {
            pickerViewAlert.frame.size.width = typeProductAlertController.view.frame.size.width
        })
    }
}

extension CustumerTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TypeProduct.allCases.count
    }
}

extension CustumerTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = TypeProduct.allCases[row].rawValue
        newType = TypeProduct.allCases[row].rawValue
        return result
    }
}
