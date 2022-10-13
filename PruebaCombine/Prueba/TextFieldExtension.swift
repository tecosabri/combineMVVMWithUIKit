//
//  TextFieldExtension.swift
//  PruebaCombine
//
//  Created by Ismael Sabri Pérez on 11/10/22.
//

import UIKit
import Combine

extension UITextField {
    
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
    }
}
