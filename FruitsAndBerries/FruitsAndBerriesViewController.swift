//
//  FruitsAndBerriesViewController.swift
//  iOS-Test
//

import UIKit
import Kingfisher


protocol FruitsAndBerriesDisplayLogic: AnyObject {
    func display(model: FruitsAndBerriesModels.Load.ViewModel)
}


class FruitsAndBerriesViewController: UIViewController {
    
    var interactor: FruitsAndBerriesBusinessLogic?
    var presenter: FruitsAndBerriesPresenter?
    var router: FruitsAndBerriesRoutingLogic?
    
    // MARK: - Outlets
    
    @IBOutlet weak var customLoader: UIImageView!
    @IBOutlet weak var ItemsList: UITableView!
    
    // MARK: - Properties
    
    //for info from items that receive from network
    var items: [FruitsAndBerriesModels.Load.ItemOfList] = []
    //animation trigger
    var anim: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init UI
        self.ItemsList.alpha = 0.0
        customLoader.rotate(onTime: 1.0)
        //make request to Interactor
        let request = FruitsAndBerriesModels.Load.Request(webUrl: "/items/random")
        interactor?.load(request: request)
        //init UI
        setupUI()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Common
    
    func setupUI() {
        
        ItemsList.delegate = self
        ItemsList.dataSource = self
        
        //add title
        self.navigationItem.title = ""
        //configure right button of nav bar
        let refresh_image = UIImage(named: "refresh_button")
        let refresh_button = UIBarButtonItem(image: refresh_image, style: .plain, target: self, action: #selector(refreshList))
        //add right button to nav bar
        self.navigationItem.rightBarButtonItem = refresh_button
        //set color of nav bar
        navigationController?.navigationBar.backgroundColor = UIColor(named: "Header")
        //set color of title nav bar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        //set color of back button
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //set title of back button
        self.navigationItem.backButtonTitle = ""
    }
    
    
    //when tap on refresh button
    @objc func refreshList() {
        //hide title
        self.navigationItem.titleView?.alpha = 0
        //hide table
        self.ItemsList.alpha = 0.0
        //show loader
        customLoader.isHidden = false
        customLoader.rotate(onTime: 1.0)
        //set animation trigger
        self.anim = false
        //clear table
        items = []
        //reload table
        self.ItemsList.reloadData()
        //make request
        let request = FruitsAndBerriesModels.Load.Request(webUrl: "/items/random")
        interactor?.load(request: request)
    }
}


extension FruitsAndBerriesViewController: FruitsAndBerriesDisplayLogic {
    
    func display(model: FruitsAndBerriesModels.Load.ViewModel) {
        customLoader.stopRotate()
        customLoader.isHidden = true
        UIView.animate(withDuration: 1, animations: {
            self.ItemsList.alpha = 1.0
        })
        //check error when make network request
        if model.hasError {
            //we have error in network request - show it
            //hide title
            self.navigationItem.titleView = UIView()
            //clear table
            items = []
            //reload table
            self.ItemsList.reloadData()
            //show alert
            let alert = UIAlertController(title: "Error", message: model.error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //all right - show items
            //set items
            items = model.items
            //reload table
            self.ItemsList.reloadData()
            //create title label
            let label = UILabel()
            label.text = model.title
            label.textColor = UIColor.white
            //make animation
            self.navigationItem.titleView = label
            UIView.animate(withDuration: 3, animations: {
                self.navigationItem.titleView?.alpha = 1.0
            })
            //animate table
            anim = true
            self.ItemsList.beginUpdates()
            self.ItemsList.endUpdates()
        }
        //end if
    }
}




extension FruitsAndBerriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellTableViewCell
        //get item info
        let item = items[indexPath.row]
        //set item title
        cell.ItemName.text = item.name
        //set item background
        cell.ItemVievBackground.backgroundColor = UIColor(hexString: item.color)
        //set item image with Kingsfisher
        let imageUrl = URL(string: FruitsAndBerriesModels.baseUrl + item.image)
        cell.ItemImage.kf.setImage(with: imageUrl)
        //clear selection color
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "FruitsAndBerries", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else {
            return
        }
        //get cell
        let tappedCell = tableView.cellForRow(at: indexPath) as? ItemCellTableViewCell
        //set parameters of controller
        vc.titleLabel = items[indexPath.row].name
        vc.id = items[indexPath.row].id
        vc.image = tappedCell?.ItemImage.image
        vc.color = tappedCell?.ItemVievBackground.backgroundColor
        vc.interactor = interactor
        vc.presenter = presenter
        vc.router = router
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // check if animate row resizing
        if self.anim {
            return 100
        } else {
            return 84
        }
        
    }
    
    
}
