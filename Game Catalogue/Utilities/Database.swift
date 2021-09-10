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
    public static let shared = Database()

    lazy var context: NSManagedObjectContext = {
       let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.viewContext
    }()

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
        size: Int = 10
    ) -> [T] {
        let request = T.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = size
        
        do {
            return try context.fetch(request) as? [T] ?? []
        } catch {
            return []
        }
    }
}
