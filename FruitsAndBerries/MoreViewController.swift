//
//  MoreViewController.swift
//  iOS-Test
//
//  Created by Vlad on 1/4/24.
//

import UIKit


protocol MoreDisplayLogic: AnyObject {
    func display(model: FruitsAndBerriesModels.LoadDetail.ViewModel)
}


class MoreViewController: UIViewController {
    
    var interactor: FruitsAndBerriesBusinessLogic?
    var presenter: FruitsAndBerriesPresenter?
    var router: FruitsAndBerriesRoutingLogic?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var detailBack: UIView!
    @IBOutlet weak var customLoader: UIImageView!
    
    
    // MARK: - Properties
    
    //title of nav bar
    var titleLabel = ""
    //for get ID from main screen
    var id: String = ""
    //for get image from main screen
    var image: UIImage? = nil
    //for get color from main screen
    var color: UIColor? = nil
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //connect MoreDisplayLogic to Presenter
        presenter?.viewDetail = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //init UI
        setupUI()
        //make request to Interactor
        let request = FruitsAndBerriesModels.LoadDetail.Request(itemId: id)
        interactor?.loadDetail(request: request)
    }
    
    
    // MARK: - Common
    
    func setupUI() {
        //set navigation title
        self.navigationItem.title = titleLabel
        //hide view with detail
        detailBack.isHidden = true
        //show loader
        customLoader.isHidden = false
        customLoader.rotate(onTime: 1)
        //set picture and color of detail view
        guard let img = image, let cl = color else {
            return
        }
        itemImage.image = img
        detailBack.backgroundColor = cl
    }
}


extension MoreViewController: MoreDisplayLogic {
    
    func display(model: FruitsAndBerriesModels.LoadDetail.ViewModel) {
        //hide loader
        customLoader.stopRotate()
        customLoader.isHidden = true
        //check error
        if model.hasError {
            //we have error in network request - show it
            //show alert
            let alert = UIAlertController(title: "Error", message: model.error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //all right - show items
            itemDescription.text = model.text
            //show detail view
            detailBack.isHidden = false
        }
        //end if
    }
}


