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
    
    @Published var bootCamps: String?
    var textFieldValue: String? {
        didSet {
            print("Current value of textfield is \(textFieldValue ?? "")")
        }
    }
    
    // MARK: - Lifecycle
    init(viewDelegate: PruebaViewController) {
        self.viewDelegate = viewDelegate
        viewDelegate.$textFieldText.sink { text in
            guard let text else { return }
            self.textFieldValue = text
        }.store(in: &cancellables) 
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
            .receive(on: DispatchQueue.main) //hilo principal
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
                self.bootCamps = bootCamps
                
                data.forEach { BootCamp in
                    print("\(BootCamp.name)")
                }
            }.store(in: &cancellables)
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
