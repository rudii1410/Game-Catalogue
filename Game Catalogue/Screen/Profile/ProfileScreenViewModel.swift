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

import Combine
import Foundation

class ProfileScreenViewModel: ObservableObject {
    @Published var imageUrl = "https://rudiyanto.dev/img/self.jpg"
    @Published var fullname = "Rudiyanto"
    @Published var webUrlStr = "https://rudiyanto.dev"
    @Published var isEditMode = false
    @Published var tempImageUrl = ""
    @Published var tempFullname = ""
    @Published var tempWebUrlStr = ""
    @Published var showImgUrlAlert = false

    func onTapProfile() {
        if !isEditMode { return }
        showImgUrlAlert = true
    }

    func saveData() {
        
    }

    func toggleEditMode() {
        if !isEditMode {
            tempImageUrl = imageUrl
            tempFullname = fullname
            tempWebUrlStr = webUrlStr
        }
        isEditMode.toggle()
    }
}
