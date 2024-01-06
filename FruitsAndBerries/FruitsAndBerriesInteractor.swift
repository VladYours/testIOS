//
//  FruitsAndBerriesInteractor.swift
//  iOS-Test
//

import Alamofire

// Implemented by Interactor
protocol FruitsAndBerriesBusinessLogic {
    // Loads the list of the items and passes Load.Response to Presenter
    func load(request: FruitsAndBerriesModels.Load.Request)
    // Loads the details of the item and passes LoadDetail.Response to Presenter
    func loadDetail(request: FruitsAndBerriesModels.LoadDetail.Request)
}

class FruitsAndBerriesInteractor {
    
    var presenter: FruitsAndBerriesPresentationLogic?
}

extension FruitsAndBerriesInteractor: FruitsAndBerriesBusinessLogic {
    
    func loadDetail(request: FruitsAndBerriesModels.LoadDetail.Request) {
        //make endpoint url
        let endpoint = FruitsAndBerriesModels.baseUrl + "/texts/\(request.itemId)"
        //make request to endpoint
        AF.request(endpoint).responseDecodable(of: FruitsAndBerriesModels.LoadDetail.Response.self) { response in
            let res = response.result
            switch res {
            case .success:
                if let toPresenter = response.value {
                    self.presenter?.presentDetail(response: toPresenter)
                } else {
                    let toPresenter = FruitsAndBerriesModels.LoadDetail.Response(id: nil, text: nil, error: "No values in success")
                    self.presenter?.presentDetail(response: toPresenter)
                }
                //end if
            case .failure(let error):
                print(error)
                let toPresenter = FruitsAndBerriesModels.LoadDetail.Response(id: nil, text: nil, error:  error.localizedDescription)
                self.presenter?.presentDetail(response: toPresenter)
            }
        }
        //end AF
    }
    //end loadDetail
    
    
    func load(request: FruitsAndBerriesModels.Load.Request) {
        //make endpoint url
        let endpoint = FruitsAndBerriesModels.baseUrl + request.webUrl
        //make request to endpoint
        AF.request(endpoint).responseDecodable(of: FruitsAndBerriesModels.Load.Response.self) { response in
            let res = response.result
            switch res {
            case .success:
                if let toPresenter = response.value {
                    self.presenter?.present(response: toPresenter)
                } else {
                    let toPresenter = FruitsAndBerriesModels.Load.Response(title: nil, items: nil, error: "No values in success")
                    self.presenter?.present(response: toPresenter)
                }
                //end if
            case .failure(let error):
                print(error)
                let toPresenter = FruitsAndBerriesModels.Load.Response(title: nil, items: nil, error: error.localizedDescription)
                self.presenter?.present(response: toPresenter)
            }
        }
        //end AF
    }
    //end load
}
