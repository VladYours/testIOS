//
//  FruitsAndBerriesPresenter.swift
//  iOS-Test
//

import Kingfisher

// Implemented by View layer (ViewControllers)
protocol FruitsAndBerriesPresentationLogic {
    
    func present(response: FruitsAndBerriesModels.Load.Response)
    
    func presentDetail(response: FruitsAndBerriesModels.LoadDetail.Response)
}

class FruitsAndBerriesPresenter {
    weak var view: FruitsAndBerriesDisplayLogic?
    weak var viewDetail: MoreDisplayLogic?
}

extension FruitsAndBerriesPresenter: FruitsAndBerriesPresentationLogic {
    
    // Transforms LoadDetail.Response into ViewModel to be displayed by the ViewController
    func presentDetail(response: FruitsAndBerriesModels.LoadDetail.Response) {
        let model: FruitsAndBerriesModels.LoadDetail.ViewModel
        if response.error == nil {
            model = FruitsAndBerriesModels.LoadDetail.ViewModel(hasError: false, text: response.text!, error: "")
        } else {
            model = FruitsAndBerriesModels.LoadDetail.ViewModel(hasError: true, text: "", error: response.error!)
        }
        viewDetail?.display(model: model)
    }
    
    
    // Transforms Load.Response into ViewModel to be displayed by the ViewController
    func present(response: FruitsAndBerriesModels.Load.Response) {
        let model: FruitsAndBerriesModels.Load.ViewModel
        if response.error == nil {
            model = FruitsAndBerriesModels.Load.ViewModel(hasError: false, title: response.title!, items: response.items!, error: "")
        } else {
            model = FruitsAndBerriesModels.Load.ViewModel(hasError: true, title: "", items: [], error: response.error!)
        }
        view?.display(model: model)
    }
}
