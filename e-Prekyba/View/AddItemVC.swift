//
//  AddItemVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-04.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    //MARK: - Variables
    var category: Category!
    var itemImages: [UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30,
                                                                  y: self.view.frame.height / 2 - 30,
                                                                  width: 60,
                                                                  height: 60),
                                                    type: .circleStrokeSpin,
                                                    color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                                                    padding: nil)
    }
    
    //MARK: - Actions
    @IBAction func doneBtnTapped(_ sender: Any) {
        dismissKeyboard()
        
        if checkFieldsAreFilled() {
            saveItemToFirebase()
        } else {
            self.hud.textLabel.text = "All fields are required!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func cameraBtnTapped(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: -  Helper Functions
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func checkFieldsAreFilled() -> Bool {
        return (titleTxtField.text != "" && priceTxtField.text != "" && descriptionTxtView.text != "")
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Save item to Firebase
    private func saveItemToFirebase() {
        
        showActivityIndicator()
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTxtField.text!
        item.categoryId = category.id
        item.description = descriptionTxtView.text!
        item.price = Double(priceTxtField.text!)

        if itemImages.count > 0 {
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                saveItemToFirestore(item)
                self.hideActivityIndicator()
                self.popTheView()
            }
        } else {
            saveItemToFirestore(item)
            popTheView()
        }

    }
    
    //MARK: - Activity Indicator
    
    private func showActivityIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    
    //MARK: - Show Images Gallery
    
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
}

extension AddItemVC: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
