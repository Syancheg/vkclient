//
//  LoginViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 12.10.2020.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    private var animationView: LoaderCloud!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Life circle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.text = "admin"
        passwordTextField.text = "admin"
        
        startAnimation()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
//            self.endAnimation()
//        }
        
    }
    // MARK: - Actions
    
    @IBAction func scrollTabbed(_ sendler: UIGestureRecognizer){
        scrollView.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
    }
    @objc func keyboardWillHide(){
        scrollView.contentInset = .zero
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkUserData()
        if !checkResult {
            showLoginError()
        }
        return checkResult
    }
    
    func checkUserData() -> Bool {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return false }
        
        if login == "admin" && password == "admin" {
            return true
        } else {
            return false
        }
    }
    
    func showLoginError() {
        let alter = UIAlertController(title: "Ошибка", message: "Пароль или логин пользователя не совпадает", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    func startAnimation() {
//        animationView = LoaderView(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
        animationView = LoaderCloud(frame: CGRect(x: 0, y: 0, width:  view.frame.width, height: view.frame.height))
        animationView.backgroundColor = .black
        view.addSubview(animationView)
        
    }
    
    func endAnimation() {
        
        for view in view.subviews{
           if view === animationView{
            view.removeFromSuperview()
           }
        }
    }
}
