//
//  File: PruebaViewController.swift
//
//  Created by Ismael Sabri on 9/10/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit
import Combine


protocol PruebaViewControllerProtocol: AnyObject {
    
}

class PruebaViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
//    @Published var textFieldText: String?
    var textFieldText: String?
    
    // MARK: - Public properties
    // MVC properties
    var viewModel: PruebaViewModel?
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        viewModel?.downloadBootcamps()
        viewModel?.$bootCamps.sink(receiveValue: { value in
            self.label.text = value
        }).store(in: &cancellables)
        //        viewModel?.$bootCamps.assign(to: \.text, on: label)
        //            .store(in: &cancellables)
    }
    
    private func setViewModel() {
        self.viewModel = PruebaViewModel(viewDelegate: self)
    }
    
    
    @IBAction func onEditTextField(_ sender: Any) {
        textFieldText = (sender as? UITextField)?.text
    }
}

// MARK: - PruebaViewControllerProtocol extension
extension PruebaViewController: PruebaViewControllerProtocol {
    
}
