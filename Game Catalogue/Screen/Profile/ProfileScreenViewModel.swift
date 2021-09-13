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
    private var profileRepo = ProfileRepository()

    var profile: Profile
    @Published var isEditMode = false
    @Published var tempImageUrl = ""
    @Published var tempFullname = ""
    @Published var tempWebUrlStr = ""
    @Published var showImgUrlAlert = false

    init() {
        self.profile = ProfileRepository.defaultProfile
        loadProfileData()
    }

    func onTapProfile() {
        if !isEditMode { return }
        showImgUrlAlert = true
    }

    func saveData() {
        let profile = Profile(
            fullname: tempFullname,
            profilePic: tempImageUrl,
            webUrl: tempWebUrlStr
        )
        updateProfileData(profile: profile)
        isEditMode = false
    }

    func toggleEditMode() {
        if !isEditMode {
            tempImageUrl = profile.profilePic
            tempFullname = profile.fullname
            tempWebUrlStr = profile.webUrl
        }
        isEditMode.toggle()
    }

    func loadProfileData() {
        let profile = profileRepo.getProfile()
        if profile.isEmpty() {
            updateProfileData(profile: ProfileRepository.defaultProfile)
        } else {
            self.profile = profile
        }
    }

    private func updateProfileData(profile: Profile) {
        profileRepo.storeProfileData(profile: profile)
        self.profile = profile
    }
}
