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

import Foundation

protocol ProfileRepositoryInterface {
    init(userDef: UserDefaults)
    func storeProfileData(profile: Profile)
    func getProfile() -> Profile
}

class ProfileRepository: ProfileRepositoryInterface {
    static let fullnameKey = "fullname"
    static let profilePicKey = "profilePic"
    static let webUrlKey = "webUrl"
    static let defaultProfile = Profile(
        fullname: "Rudiyanto",
        profilePic: "https://rudiyanto.dev/img/self.jpg",
        webUrl: "https://rudiyanto.dev"
    )

    private let userDef: UserDefaults
    required init(userDef: UserDefaults) {
        self.userDef = userDef
    }

    func storeProfileData(profile: Profile) {
        userDef.setValue(profile.fullname, forKey: ProfileRepository.fullnameKey)
        userDef.setValue(profile.profilePic, forKey: ProfileRepository.profilePicKey)
        userDef.setValue(profile.webUrl, forKey: ProfileRepository.webUrlKey)
    }

    func getProfile() -> Profile {
        return Profile(
            fullname: userDef.string(forKey: ProfileRepository.fullnameKey),
            profilePic: userDef.string(forKey: ProfileRepository.profilePicKey),
            webUrl: userDef.string(forKey: ProfileRepository.webUrlKey)
        )
    }
}
