//
//  DetailCustumerViewController.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData

var productForBasketCustumer: [BasketForCustumer] = []

class DetailCustumerViewController: UIViewController {

    public var productName = productCar[myIndex].name

    public var productType  = productCar[myIndex].type

    public var productCoastRetail = productCar[myIndex].coastSell

    public var productCoastWhosealers = productCar[myIndex].coastSellOpt

    public var productAvailibility = productCar[myIndex].availability

    var newProductForBasket: BasketForCustumer!

    @IBOutlet weak var nameProductLabel: UILabel!

    @IBOutlet weak var categoryProductLabel: UILabel!

    @IBOutlet weak var coastProductLabel: UILabel!

    @IBOutlet weak var typeCoastLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameProductLabel.text = productName
        categoryProductLabel.text = productType
        if idCoast == 1 {
            typeCoastLabel.text = "Розничная цена:"
            coastProductLabel.text = String(productCoastRetail)
        } else {
            typeCoastLabel.text = "Оптовая цена:"
            coastProductLabel.text = String(productCoastWhosealers)
        }
    }

    @IBAction func addToBasketButton(_ sender: UIButton) {
        let message = "Количество товара на складе - \(productCar[myIndex].availability). " +
        "Указывая большее количество, Вы соглашаетесь на условия доставки товара"
        let alertControllerProduct = UIAlertController(title: "Укажите количество товара",
                                                       message: message, preferredStyle: .alert)
        alertControllerProduct.addTextField { (textfield) in
            textfield.keyboardType = UIKeyboardType.numberPad
            textfield.placeholder = "Введите количество товара"
        }
        let alertActionToBasket = UIAlertAction(title: "Добавить в корзину", style: .default) { (_) in
            guard let newValue = Int64((alertControllerProduct.textFields?.first?.text!)!) else { return }
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainerforBasket.viewContext
            self.newProductForBasket = NSEntityDescription.insertNewObject(forEntityName: "BasketForCustumer",
                                                                           into: managedContext) as? BasketForCustumer
            self.newProductForBasket.nameInBasket = productCar[myIndex].name
            self.newProductForBasket.availabilityCustumer = newValue
            if idCoast == 1 {
                self.newProductForBasket.coastBasketProduct = productCar[myIndex].coastSell
            } else {
                self.newProductForBasket.coastBasketProduct = productCar[myIndex].coastSellOpt
            }
            productForBasketCustumer.append(self.newProductForBasket)
            do {
                try managedContext.save()
            } catch {
                print("falled save item")
            }
            self.toBasket()
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .default)
        alertControllerProduct.addAction(alertActionToBasket)
        alertControllerProduct.addAction(alertActionCancel)
        present(alertControllerProduct, animated: true, completion: nil)
    }

    func toBasket() {
        let alertControllerToBasket = UIAlertController(title: "Товар успешно добавлен",
                                                        message: "Хотите перейти к корзине?",
                                                        preferredStyle: .alert)
        let toBasketAlertAction = UIAlertAction(title: "Перейти в корзину", style: .default) { (_) in
            self.performSegue(withIdentifier: "addBasketInProduct", sender: self)
        }
        let continueBuyAlertAction = UIAlertAction(title: "Продолжить покупки", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertControllerToBasket.addAction(continueBuyAlertAction)
        alertControllerToBasket.addAction(toBasketAlertAction)
        self.present(alertControllerToBasket, animated: true, completion: nil)
    }
}
