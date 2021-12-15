//
//  AddBookViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 09/05/1443 AH.
//

import UIKit

import UIKit
import Firebase
import FirebaseFirestore
class AddBookViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var bookStausLabel: UILabel!
    @IBOutlet weak var bookStatusTextField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addImageBook: UIImageView!
    var image: UIImage? = nil
    let db = Firestore.firestore()
    var user:User!
    var imagePicker: ImagePicker!
    var book:Book!
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        shadow()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
        func cornerRadius(){
            nameLabel.layer.cornerRadius = 10
            nameLabel.layer.borderWidth = 1
            nameLabel.layer.borderColor = UIColor.red.cgColor
            nameLabelTextField.layer.cornerRadius = 10
            nameLabelTextField.layer.borderWidth = 1
            nameLabelTextField.layer.borderColor = UIColor.red.cgColor
            descriptionLabel.layer.cornerRadius = 10
            descriptionLabel.layer.borderWidth = 1
            descriptionLabel.layer.borderColor = UIColor.red.cgColor
            descriptionTextView.layer.cornerRadius = 10
            descriptionTextView.layer.borderWidth = 1
            descriptionTextView.layer.borderColor = UIColor.red.cgColor
            sectionLabel.layer.cornerRadius = 10
            sectionLabel.layer.borderWidth = 1
            sectionLabel.layer.borderColor = UIColor.red.cgColor
            sectionTextField.layer.cornerRadius = 10
            sectionTextField.layer.borderWidth = 1
            sectionTextField.layer.borderColor = UIColor.red.cgColor
            bookStausLabel.layer.cornerRadius = 10
            bookStausLabel.layer.borderWidth = 1
            bookStausLabel.layer.borderColor = UIColor.red.cgColor
            bookStatusTextField.layer.cornerRadius = 10
            bookStatusTextField.layer.borderWidth = 1
            bookStatusTextField.layer.borderColor = UIColor.red.cgColor
            addBtn.layer.cornerRadius = 10
            addBtn.layer.borderWidth = 1
            addBtn.layer.borderColor = UIColor.red.cgColor
      }
    func shadow(){
        addBtn.layer.shadowColor = UIColor.black.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        addBtn.layer.shadowRadius = 8
        addBtn.layer.shadowOpacity = 0.5
        addBtn.layer.masksToBounds = false
    }
    @IBAction func addImage(_ sender: UIButton) {
        self.imagePicker.present(from: self.view)
    }
    @IBAction func addPressed(_ sender: UIButton) {
        self.book = Book.init(name: self.nameLabelTextField.text!, description: self.descriptionTextView.text!, section: self.sectionTextField.text!, bookStatus: self.bookStatusTextField.text!, price: "14")
        self.saveBook(self.book)
    }
    func saveBook(_ book: Book) {
           let docData: [String: Any] = [
            "name": book.name,
            "description": book.description,
            "section":book.section,
            "bookStatus":book.bookStatus,
            "price":book.price
           ]
        db.collection("Book").document(Auth.auth().currentUser!.uid).setData(docData) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
       }
}
extension AddBookViewController:ImagePickerDelegate{
    func didSelect(image: UIImage?) {
            if let image = image{
                addImageBook.image = image
            }
    }
}
    



