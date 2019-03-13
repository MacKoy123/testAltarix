//
//  NewProductViewController.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData

class NewProductViewController: UIViewController {

    var newProductCar: ProductCore!

    @IBOutlet weak var newProductTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createNewProductButton(_ sender: UIButton) {
        guard let newproduct1 = newProductTextField.text else { return }
        if let newIndex = productCar.firstIndex(where: {$0.name == newproduct1}) {
            let message = "Товар с таким именем уже существует. Хотите его отредактировать?"
            let alertController = UIAlertController(title: "Ошибка",
                                                    message: message,
                                                    preferredStyle: .alert)
            let alertActionEdit = UIAlertAction(title: "Редактировать", style: .default) { (_) in
                myIndex = newIndex
                self.performSegue(withIdentifier: "newProductDetail", sender: self)
            }
            let alertActionCancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            alertController.addAction(alertActionEdit)
            alertController.addAction(alertActionCancel)
            present(alertController, animated: true, completion: nil)
        } else {
            if productCar.isEmpty {
                self.writeToCoreDataModelProduct(nameProductText: newproduct1)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.writeToCoreDataModelProduct(nameProductText: newproduct1)
                })
            }
            let alertController = UIAlertController(title: "Товар успешно создан",
                                                    message: "Товар появится в списке товаров через пару секунд",
                                                    preferredStyle: .alert)
            let alertActionCancel = UIAlertAction(title: "OK", style: .default) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertActionCancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func writeToCoreDataModelProduct(nameProductText: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        self.newProductCar = NSEntityDescription.insertNewObject(forEntityName: "Product",
                                                                 into: managedContext) as? ProductCore
        self.newProductCar.name = nameProductText
        self.newProductCar.type = "Прочие товары"
        self.newProductCar.availability = 0
        self.newProductCar.coastBuy = 0.0
        self.newProductCar.coastSell = 0.0
        self.newProductCar.coastSellOpt = 0.0
        productCar.append(self.newProductCar)
        do {
            try managedContext.save()
        } catch {
            print("falled save item")
        }
    }
}
