//
//  BasketCustumerViewController.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData

class BasketCustumerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var summ = 0.0
    @IBOutlet weak var summBasketLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainerforBasket.viewContext
        let fetchManaged = NSFetchRequest<NSManagedObject>(entityName: "BasketForCustumer")
        do {
            productForBasketCustumer = try managedContext.fetch(fetchManaged) as? [BasketForCustumer] ?? []
        } catch {
            print("failed fetch")
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        summBasketLabel.text = String(summ)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productForBasketCustumer.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBasket", for: indexPath)
        let availabilityProduct = Double(productForBasketCustumer[indexPath.row].availabilityCustumer)
        let payProduct = availabilityProduct*productForBasketCustumer[indexPath.row].coastBasketProduct
        summ += payProduct
        if let nameProduct = productForBasketCustumer[indexPath.row].nameInBasket {
            let availability = String(productForBasketCustumer[indexPath.row].availabilityCustumer) + "шт - "
            cell.textLabel?.text = nameProduct + " - " + availability + String(payProduct)
            summBasketLabel.text = String(summ)
        }
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainerforBasket.viewContext
            managedContext.delete(productForBasketCustumer[indexPath.row])
            productForBasketCustumer.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch {
                print("Невозможно удалить товар")
            }
            summ = 0.0
            self.summBasketLabel.text = String(summ)
            self.tableView.reloadData()
        }
    }

    @IBAction func buyProductInBasketButton(_ sender: UIButton) {
        if productForBasketCustumer.isEmpty {
            let alertControllerOK = UIAlertController(title: "В корзине нет товаров",
                                                      message: nil,
                                                      preferredStyle: .alert)
            let alertActionOK = UIAlertAction(title: "OK", style: .default)
            alertControllerOK.addAction(alertActionOK)
            self.present(alertControllerOK, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Укажите номер телефона для связи",
                                                    message: nil,
                                                    preferredStyle: .alert)
            alertController.addTextField { (textfield) in
                textfield.keyboardType = UIKeyboardType.numberPad
                textfield.placeholder = "Введите номер телефона"
            }
            let buyAlertAction = UIAlertAction(title: "Сделать заказ", style: .default) { (_) in
                if alertController.textFields?.first?.text?.count != 11 {
                    self.allertOk(title: "Неверно указан номер телефона", message: nil)
                } else {
                    guard let newValue = Int((alertController.textFields?.first?.text!)!) else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        self.sendToStoreJson(number: newValue)
                        productForBasketCustumer = []
                        self.tableView.reloadData()
                    })
                    self.summBasketLabel.text = String(0.0)
                    self.allertOk(title: "Спасибо за заказ", message: "Наш менеджер свяжется с Вами в кратчайшие сроки")
                }
            }
            let actionCancel = UIAlertAction(title: "Отмена", style: .default)
            alertController.addAction(buyAlertAction)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }

    func allertOk(title: String, message: String?) {
        let allertControllerOK = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionOK = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        allertControllerOK.addAction(alertActionOK)
        self.present(allertControllerOK, animated: true, completion: nil)
    }

    func sendToStoreJson(number: Int) {
        var array: [[String: Any]] = []
        var new: [String: Any] = [:]
        new["NumberPhone"] = number
        array.append(new)
        for product in productForBasketCustumer {
            var basketCoreData: [String: Any] = [:]
            basketCoreData["name"] = product.nameInBasket
            basketCoreData["availability"] = product.availabilityCustumer
            basketCoreData["coast"] = product.coastBasketProduct
            array.append(basketCoreData)
        }
        guard let json = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) else {return}
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                               appropriateFor: nil, create: false)
        guard let jsonUrl = url?.appendingPathComponent("\(String(number))basket.json") else {return}
        print(jsonUrl)
        try? json.write(to: jsonUrl)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainerforBasket.viewContext
        for product in productForBasketCustumer {
            managedContext.delete(product)
            do {
                try managedContext.save()
            } catch {
                print("Невозможно удалить товар")
            }
        }
        self.tableView.reloadData()
    }
}
