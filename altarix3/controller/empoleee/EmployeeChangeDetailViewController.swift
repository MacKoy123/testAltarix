//
//  EmployeeChangeDetailViewController.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData

class EmployeeChangeDetailViewController: UIViewController {

    public var productName = productCar[myIndex].name
    
    public var productCategory  = productCar[myIndex].type
    
    public var productCoastBuy = productCar[myIndex].coastBuy
    
    public var productCoastRetail = productCar[myIndex].coastSell
    
    public var productCoastWholesalers = productCar[myIndex].coastSellOpt
    
    public var productAvailibility = productCar[myIndex].availability

    @IBOutlet weak var nameProductLabel: UILabel!
    
    @IBOutlet weak var availabilityLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var coastBuyLabel: UILabel!
    
    @IBOutlet weak var coastRetailLabel: UILabel!
    
    @IBOutlet weak var coastWholesalersLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameProductLabel.text = productName
        coastBuyLabel.text = String(productCoastBuy)
        coastRetailLabel.text = String(productCoastRetail)
        coastWholesalersLabel.text = String(productCoastWholesalers)
        availabilityLabel.text = String(productAvailibility)
        if productCategory == nil {
            categoryLabel.text = "Нет категории"
        } else {
            categoryLabel.text = productCategory
        }
    }

    @IBAction func changeCoastBuyButton(_ sender: UIButton) {
        changeCoast(title: "новую цену покупки", forkey: "coastBuy", labelChanger: self.coastBuyLabel)
    }

    @IBAction func changeCoastRetailButton(_ sender: UIButton) {
           changeCoast(title: "новую розничную цену", forkey: "coastSell", labelChanger: self.coastRetailLabel)
    }

    @IBAction func changeCoastWholesalersButton(_ sender: UIButton) {
        changeCoast(title: "новую оптовую цену", forkey: "coastSellOpt", labelChanger: self.coastWholesalersLabel)
    }

    @IBAction func changeAvailabilityButton(_ sender: UIButton) {
        let availabilityAlertController = UIAlertController(title: "Укажите новое количество товара",
                                                            message: nil,
                                                            preferredStyle: .alert)
        availabilityAlertController.addTextField { (textfield) in
            textfield.keyboardType = UIKeyboardType.numberPad
            textfield.placeholder = "Введите количество товара"
        }
        let alertActionChange = UIAlertAction(title: "Изменить", style: .default) { (_) in
            guard let newValue = Int((availabilityAlertController.textFields?.first?.text!)!) else {return}
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            productCar[myIndex].setValue(newValue, forKey: "availability")
            do {
                self.availabilityLabel.text = String(newValue)
                try managedContext.save()
            } catch {
                print("Невозможно изменить цену")
            }
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .default)
        availabilityAlertController.addAction(alertActionChange)
        availabilityAlertController.addAction(alertActionCancel)
        present(availabilityAlertController, animated: true, completion: nil)
    }

    @IBAction func changeCategoryButton(_ sender: UIButton) {
        let newTypeAlertController = UIAlertController(title: "Выберите новый тип",
                                                       message: "\n\n\n\n\n\n\n\n",
                                                       preferredStyle: .alert)
        let pickerViewAllert = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerViewAllert.dataSource = self
        pickerViewAllert.delegate = self
        newTypeAlertController.view.addSubview(pickerViewAllert)
        let action = UIAlertAction(title: "Изменить", style: .default) { (_) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            productCar[myIndex].setValue(self.productCategory, forKey: "type")
            do {
                self.categoryLabel.text = productCar[myIndex].type
                try managedContext.save()
            } catch {
                print("Невозможно изменить категорию")
            }
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .default)
        newTypeAlertController.addAction(action)
        newTypeAlertController.addAction(alertActionCancel)
        present(newTypeAlertController, animated: true, completion: {
            pickerViewAllert.frame.size.width = newTypeAlertController.view.frame.size.width
        })
    }

    func changeCoast(title: String, forkey: String, labelChanger: UILabel) {
        let changeCoastAlertController = UIAlertController(title: "Укажите новую цену",
                                                           message: nil,
                                                           preferredStyle: .alert)
        changeCoastAlertController.addTextField { (textfield) in
            textfield.keyboardType = UIKeyboardType.decimalPad
            textfield.placeholder = "Введите" + title
        }
        let alertActionChange = UIAlertAction(title: "Изменить", style: .default) { (_) in
            guard let newValue = Double((changeCoastAlertController.textFields?.first?.text!)!) else {return}
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            productCar[myIndex].setValue(newValue, forKey: forkey)
            do {
                labelChanger.text = String(newValue)
                try managedContext.save()
            } catch {
                print("Невозможно изменить цену")
            }
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .default)
        changeCoastAlertController.addAction(alertActionChange)
        changeCoastAlertController.addAction(alertActionCancel)
        present(changeCoastAlertController, animated: true, completion: nil)
    }

    @IBAction func exitCliackBarButtonItem(_ sender: UIBarButtonItem) {
        guard let arrayOfView: [UIViewController] = self.navigationController?.viewControllers else {return}
        for controller in arrayOfView where controller is EmploeeTableViewСontroller {
            self.navigationController?.popToViewController(controller, animated: true)
            break
        }
    }
}

extension EmployeeChangeDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TypeProduct.allCases.count
    }
}

extension EmployeeChangeDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = TypeProduct.allCases[row].rawValue
        productCategory = TypeProduct.allCases[row].rawValue
        return result
    }
}
