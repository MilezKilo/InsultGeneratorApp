//
//  EvilGenVM.swift
//  EvilGenerator
//
//  Created by Майлс on 17.03.2022.
//

import Foundation
import Combine
import CoreData

class EvilGenVM: ObservableObject {
    
    //MARK: - COMBINE PROPERTIES
    @Published var evilInsult: EvilGenModel = EvilGenModel(number: "", language: "", insult: "", created: "", shown: "", createdby: "", active: "", comment: "")
    var url = "https://evilinsult.com/generate_insult.php?lang=ru&type=json"
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - COREDATA PROPERTIES
    @Published var evilInsultsContainer: [EvilGenEntity] = []
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "EvilGenContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CONTAINER LOAD ERROR: \(error)")
            }
        }
        getEvilInsult()
        fetchData()
    }
    
    //MARK: - COMBINE METHODS
    func getEvilInsult() {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(complitionHandler)
            .decode(type: EvilGenModel.self, decoder: JSONDecoder())
            .sink { complition in
                print("COMPLITION: \(complition)")
            } receiveValue: { [weak self] returnedValue in
                self?.evilInsult = returnedValue
            }
            .store(in: &cancellables)
    }
    func changeLanguage() {
        if url == "https://evilinsult.com/generate_insult.php?lang=en&type=json" {
            url = "https://evilinsult.com/generate_insult.php?lang=ru&type=json"
        } else if url == "https://evilinsult.com/generate_insult.php?lang=ru&type=json" {
            url = "https://evilinsult.com/generate_insult.php?lang=en&type=json"
        }
    }
    private func complitionHandler(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let responce = output.response as? HTTPURLResponse,
            responce.statusCode >= 200 && responce.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }
    
    //MARK: - PRIVATE COREDATA METHODS
    private func fetchData() {
        let request = NSFetchRequest<EvilGenEntity>(entityName: "EvilGenEntity")
        do {
            evilInsultsContainer = try container.viewContext.fetch(request)
        } catch let error {
            print("FETCHING ERROR: \(error)")
        }
    }
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchData()
        } catch let error {
            print("SAVE DATA ERROR: \(error)")
        }
    }
    
    //MARK: - PUBLIC COREDATA METHODS
    func addNewInsult(number: String, language: String, insult: String, created: String, shown: String, createdby: String, active: String, comment: String) {
        let newInsult = EvilGenEntity(context: container.viewContext)
        newInsult.number = number; newInsult.language = language; newInsult.insult = insult
        newInsult.created = created; newInsult.shown = shown; newInsult.createdby = createdby
        newInsult.active = active; newInsult.comment = comment
        saveData()
    }
    func deleteInsult(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = evilInsultsContainer[index]
        container.viewContext.delete(entity)
        saveData()
    }
}
