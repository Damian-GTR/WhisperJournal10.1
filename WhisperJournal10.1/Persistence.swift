//
//  Persistence.swift
//  WhisperJournal10.1
//
//  Created by andree on 14/12/24.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    // Contenedor de Core Data
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WhisperJournal10_1")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Configurar combinación automática de cambios
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Guardar los cambios en Core Data
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("No se pudo guardar el contexto: \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Método para guardar una transcripción
    func saveTranscript(text: String, date: Date? = nil, tags: String? = nil) {
        let context = container.viewContext
        let newTranscript = Transcript(context: context)
        newTranscript.text = text
        newTranscript.date = date ?? Date()
        newTranscript.tags = tags ?? ""
        newTranscript.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            print("Error guardando transcripción: \(error)")
        }
    }

    // Obtener todas las transcripciones guardadas
    func fetchAllTranscripts() -> [Transcript] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Transcript> = Transcript.fetchRequest()
        
        do {
            let transcripts = try context.fetch(fetchRequest)
            return transcripts
        } catch {
            print("Error al obtener las transcripciones: \(error)")
            return []
        }
    }
}
