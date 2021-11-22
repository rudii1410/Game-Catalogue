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

import SwiftUI

class ServiceContainer {
    private var container: [String: AnyObject] = [:]

    static func getInstance() -> ServiceContainer {
        return ServiceContainer()
    }

    func register(_ service: AnyObject) {
        let key = String(describing: type(of: service))
        self.container[key] = service
        print("Registering \(key)")
    }

    func get<T>() -> T {
        let key = String(describing: T.self)

        guard let service = self.container[key] as? T else {
            preconditionFailure("\(key) is not registered in service container")
        }
        return service
    }
}
