//
//  File: PruebaViewModel.swift
//
//  Created by Ismael Sabri on 9/10/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation
import Combine

protocol PruebaViewModelProtocol: AnyObject {
    
}

class PruebaViewModel {
    
    // MARK: - Private properties
    // MVC properties
    private weak var viewDelegate: PruebaViewController?
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Published property: bootCamps
    // This property is marked as published: it's possible to create a publisher from it. If we create a suscriptor to this publisher
    // in the viewController, when the bootcamps are downloaded, the viewController suscriptor gets notified.
    @Published var bootCamps: String?
    
    var textFieldValue: String? {
        didSet {
            print("Current value of textfield is \(textFieldValue ?? "")")
        }
    }
    
    // MARK: - Lifecycle
    init(viewDelegate: PruebaViewController) {
        self.viewDelegate = viewDelegate
//        viewDelegate.$textFieldText.sink { text in
//            guard let text else { return }
//            self.textFieldValue = text
//        }.store(in: &cancellables)
        viewDelegate.textField.textPublisher
            .assign(to: \.textFieldValue, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Download bootcamps
    func downloadBootcamps() {
        let url = URL(string: "https://dragonball.keepcoding.education/api/data/bootcamps")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [BootCamp].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // Main thread. This is mandatory if the result of the assignment will perform changes in the UI (see below)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print("Error: \(error)")
                case.finished:
                    print("Download finished")
                }
            } receiveValue: { data in
                let bootCamps = data.map { bootcamp in
                    bootcamp.name
                }.joined(separator: "\n")
                self.bootCamps = bootCamps // When assigned, notifies the suscriptor of the viewController and refreshes the UI. That's why the data has to be received on the main thread
                // Print to log that bootcamps have been downloaded
                data.forEach { BootCamp in
                    print("\(BootCamp.name)")
                }
            }.store(in: &cancellables) // If not stored, the result of the load is discarded
    }
}

// MARK: - PruebaViewModelProtocol extension
extension PruebaViewModel: PruebaViewModelProtocol {
    
}

struct BootCamp: Codable{
    let id:UUID
    let name:String
}

// extension
extension URLResponse{
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse{
            return httpResponse.statusCode
        }
        return nil
    }
}
