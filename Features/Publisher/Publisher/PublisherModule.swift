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

import Core
import Common
import SwiftUI

public class PublisherModule: Module, PublisherProviderInterface {
    private let container: ServiceContainer

    public required init(container: ServiceContainer) {
        self.container = container
    }

    public func load() {
        self.container.register(PublisherDetailUseCase.self) { resolver in
            return PublisherDetailInteractor(gameRepo: resolver.get(), publisherRepo: resolver.get())
        }
        self.container.register(PublisherListUseCase.self) { resolver in
            return PublisherListInteractor(publisher: resolver.get())
        }
    }

    public func getPublisherDetailScreenView(_ slug: String) -> AnyView {
        return AnyView(
            PublisherDetailScreen(
                model: .init(interactor: self.container.get()),
                slug: slug
            )
        )
    }

    public func getPublisherListScreenView(_ publisher: [BaseDetail]) -> AnyView {
        return AnyView(
            PublisherListScreen(
                model: .init(interactor: self.container.get()),
                publisher
            )
        )
    }
}
