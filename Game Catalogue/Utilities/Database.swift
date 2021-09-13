//
//  This file is part of Game Catalogue.
//
//  Game Catalogue is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Game Catalogue is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Game Catalogue.  If not, see <https://www.gnu.org/licenses/>.
//

import CoreData

class Database {
    static let shared = Database()

    var context: NSManagedObjectContext

    private init() {
        let persistentContainer = NSPersistentContainer(name: "Database")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        context = persistentContainer.viewContext
    }

    func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
        }
        return false
    }

    func delete<T: NSManagedObject>(item: T) {
        context.delete(item)
        _ = save()
    }

    func fetchAll<T: NSManagedObject>(
        offset: Int = 0,
        size: Int = 10,
        predicate: NSPredicate? = nil,
        callback: ([T]) -> Void
    ) {
        let request = T.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = size
        request.predicate = predicate

        do {
            let result = try context.fetch(request) as? [T] ?? []
            callback(result)
        } catch {
            callback([])
        }
    }

    func fetchFirst<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        callback: (T) -> Void
    ) {
        let request = T.fetchRequest()
        request.predicate = predicate

        do {
            let result = try context.fetch(request) as? [T] ?? []
            if !result.isEmpty { callback(result[0]) }
        } catch {}
    }
}
