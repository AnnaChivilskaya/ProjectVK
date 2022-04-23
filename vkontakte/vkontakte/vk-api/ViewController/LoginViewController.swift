//
//  EntryVKViewController.swift
//  vkontakte
//
//  Created by Аня on 30.03.2022.
//

//import UIKit
//import Kingfisher
//
//class LoginViewController: UIViewController, UITextFieldDelegate {
//
//    let session = Session.instance
//
//        override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//
//        scrollViewLogin?.addGestureRecognizer(hideKeyboardGesture)
//
//        self.loginTextField.delegate = self
//        self.passwordTextField.delegate = self
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
//                                               name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHide(notification:)),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//
//    @IBOutlet weak var scrollViewLogin: UIScrollView!
//    @IBOutlet weak var loginTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//
//
//    @objc func keyboardWillShow (notification: Notification) {
//        let info = notification.userInfo! as NSDictionary
//        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
//        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
//
//        scrollViewLogin?.contentInset = contentInset
//        scrollViewLogin?.scrollIndicatorInsets = contentInset
//    }
//
//
//    @objc func keyboardWasHide (notification: Notification) {
//        let contentInset = UIEdgeInsets.zero
//        scrollViewLogin?.contentInset = contentInset
//    }
//
//    @objc func hideKeyboard(){
//        scrollViewLogin.endEditing(true)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == loginTextField {
//            passwordTextField.becomeFirstResponder()
//        } else {
//            loginPushButton(self)
//        }
//        return true
//    }
//
//    @IBAction func loginPushButton(_ sender: Any) {
//
//        guard loginTextField.text == "admin" && passwordTextField.text == "123456" else {
//
//            let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль!", preferredStyle: .alert)
//
//            let action = UIAlertAction(title: "Повторить", style: .cancel, handler: nil)
//            alert.addAction(action)
//
//            present(alert, animated: true, completion: nil)
//            return
//        }
//        performSegue(withIdentifier: "login", sender: nil)
//    }
//
//
//
//    @IBAction func segueToLoginController​(segue:UIStoryboardSegue) {
//
//    }
//
//    @IBAction func authVKSuccessful​(segue:UIStoryboardSegue) {
//        if segue.identifier == "AuthVK"{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.performSegue(withIdentifier: "login", sender: nil)
//            }
//        }
//    }
//
//}
