//
//  BasketTabelVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class BasketTabelVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBuy: UIButton!
    
    let db = Firestore.firestore()
    var basket = [Basket]()
    var selectedOrder : Order?
    
    override func viewWillAppear(_ animated: Bool) {
        buttonBuy.isHidden = basket.count == 0
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Basket"
        readBasket()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buttonBuy.isHidden = basket.count == 0
        return basket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell") as! BasketCell
        cell.nameBook.text = basket[indexPath.row].bookName
        cell.priceBook.text = basket[indexPath.row].prices
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let bookDoc = db.collection("Basket").document(basket[indexPath.row].id!)
            bookDoc.delete() { err in
                if let err = err {
                    print("Error removing document: \(err.localizedDescription)")
                } else {
                    print("Document successfully removed!")
                    tableView.reloadData()
                    
                }
            }
        } else  {
            print("error")
        }
    }
    
    func readBasket(){
        
        guard let user = Auth.auth().currentUser else { return }
        let userReference = db.collection("Users").document(user.uid)
        db.collection("Basket").whereField("userRef", isEqualTo: userReference).addSnapshotListener { (querySnapshot, error) in
            self.basket.removeAll()
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            print("Fetch user books", documents.count)
            for (index, doc) in documents.enumerated(){
                print("Start decode book index:", index)
                
                do{
                    let bookData = try doc.data(as: Basket.self)
                    if let bookData = bookData {
                        self.basket.append(bookData)
                    }
                    self.tableView.reloadData()
                }catch let error{
                    print("Error\(error.localizedDescription)")
                }
                
            }
        }
    }
    
    let buySegueIdentifier = "BuySegue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == buySegueIdentifier {
            let destination =  segue.destination as! BuyConfirmationVC
            destination.order = selectedOrder
        }
    }
}
