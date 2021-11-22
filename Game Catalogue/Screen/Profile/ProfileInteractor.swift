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

protocol ProfileUseCase {
    func storeProfileData(profile: Profile)
    func getProfile() -> Profile
}

class ProfileInteractor: ProfileUseCase {
    private let profileRepo: ProfileRepository
    init(profileRepo: ProfileRepository) {
        self.profileRepo = profileRepo
    }
}

extension ProfileInteractor {
    func storeProfileData(profile: Profile) {
        return self.profileRepo.storeProfileData(profile: profile)
    }

    func getProfile() -> Profile {
        return self.profileRepo.getProfile()
    }
}
