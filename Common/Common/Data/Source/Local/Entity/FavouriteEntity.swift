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

public class FavouriteEntity: NSManagedObject, Identifiable {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<FavouriteEntity> {
        return NSFetchRequest<FavouriteEntity>(entityName: "FavouriteEntity")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: Date?
    @NSManaged public var slug: String
    @NSManaged public var genres: String
}
