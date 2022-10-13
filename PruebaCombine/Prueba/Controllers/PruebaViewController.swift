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
        // Suscribes to the publisher $bootcamps. So that whenever bootcamps is modified, the viewController gets notified
        viewModel?.$bootCamps.sink(receiveValue: { value in
            self.label.text = value
        }).store(in: &cancellables) // Very important to store the suscriptor!
        //        viewModel?.$bootCamps.assign(to: \.text, on: label) // This is the same as above
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
