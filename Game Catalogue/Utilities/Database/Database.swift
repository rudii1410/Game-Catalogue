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
import Combine

class Database {
    let mainContext: NSManagedObjectContext
    let bgContext: NSManagedObjectContext

    init() {
        let persistentContainer = NSPersistentContainer(name: "Database")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        mainContext = persistentContainer.viewContext
        bgContext = persistentContainer.newBackgroundContext()
    }

    func save() -> Future<Void, Error> {
        Future { promise in
            do {
                try self.bgContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(DatabaseError.saveFail))
                self.bgContext.rollback()
            }
        }
    }

    func delete<T: NSManagedObject>(item: T) -> Future<Void, Error> {
        Future { promise in
            do {
                self.bgContext.delete(item)
                try self.bgContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(DatabaseError.deleteFail))
                self.bgContext.rollback()
            }
        }
    }

    func fetchAll<T: NSManagedObject>(
        offset: Int? = nil,
        size: Int? = nil,
        predicate: NSPredicate? = nil,
        sortDesc: [NSSortDescriptor] = []
    ) -> Future<[T], Error> {
        Future { promise in
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            if let offset = offset { request.fetchOffset = offset }
            if let size = size { request.fetchLimit = size }
            request.predicate = predicate
            request.sortDescriptors = sortDesc

            do {
                let result = try self.bgContext.fetch(request)
                promise(.success(result))
            } catch {
                promise(.failure(DatabaseError.fetchFail(error: error.localizedDescription)))
            }
        }
    }

    func fetchFirst<T: NSManagedObject>(predicate: NSPredicate? = nil) -> Future<T, Error> {
        Future { promise in
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate

            do {
                let result = try self.bgContext.fetch(request)
                if result.isEmpty {
                    promise(.failure(DatabaseError.noData))
                } else {
                    promise(.success(result[0]))
                }
            } catch {
                promise(.failure(DatabaseError.fetchFail(error: error.localizedDescription)))
            }
        }
    }
}
