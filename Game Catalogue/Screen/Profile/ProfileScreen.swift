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
import SDWebImageSwiftUI

struct ProfileScreen: View {
    @ObservedObject private var model = ProfileScreenViewModel()

    var body: some View {
        VStack {
            renderProfileImage
            renderFullname
                .padding(.horizontal, 32)
                .padding(.top, 8)
            renderWebUrl
                .padding(.horizontal, 32)
                .padding(.top, 4)
            renderSaveButton
                .padding(.top, 24)
                .padding(.horizontal, 32)
        }
        .toolbar {
            ToolbarItem {
                Image(systemName: !self.model.isEditMode ? "gearshape" : "gearshape.fill")
                    .onTapGesture {
                        self.model.toggleEditMode()
                    }
            }
        }
    }

    private var renderProfileImage: some View {
        ZStack {
            WebImage(url: URL(string: self.model.isEditMode ? self.model.tempImageUrl : self.model.profile.profilePic))
                .defaultPlaceholder()
                .resizable()
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .aspectRatio(contentMode: .fill)

            if self.model.isEditMode {
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.4)
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30, alignment: .center)

                TextfieldAlert(
                    showAlert: self.$model.showImgUrlAlert,
                    title: "Edit Image URL",
                    message: "Please insert image URL here",
                    textString: self.model.tempImageUrl
                ) { value in
                    self.model.tempImageUrl = value
                }
            }
        }
        .frame(width: 200, height: 200, alignment: .center)
        .cornerRadius(10)
        .onTapGesture {
            self.model.onTapProfile()
        }
    }

    private var renderFullname: some View {
        Group {
            if self.model.isEditMode {
                HStack {
                    Text("Fullname: ")
                        .font(.callout)
                        .bold()
                    TextField("Enter fullname", text: self.$model.tempFullname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            } else {
                Text(self.model.profile.fullname)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 1)
            }
        }
    }

    private var renderWebUrl: some View {
        Group {
            if self.model.isEditMode {
                HStack {
                    Text("Web URL: ")
                        .font(.callout)
                        .bold()
                    TextField("Enter web url", text: self.$model.tempWebUrlStr)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            } else {
                Button(self.model.profile.webUrl) {
                    guard let url = URL(string: self.model.profile.webUrl) else { return }
                    UIApplication.shared.open(url)
                }
            }
        }
    }

    private var renderSaveButton: some View {
        Group {
            if self.model.isEditMode {
                HStack {
                    Button("Cancel") { self.model.isEditMode = false }
                        .buttonStyle(MyButtonStyle(primaryColor: .red, secondaryColor: .white))
                    Button("Save", action: self.model.saveData)
                        .buttonStyle(MyButtonStyle(primaryColor: .blue, secondaryColor: .white))
                }
            } else {
                EmptyView()
            }
        }
    }
}

private struct MyButtonStyle: ButtonStyle {
    var primaryColor = Color.white
    var secondaryColor = Color.black

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
            .background(configuration.isPressed ? secondaryColor : primaryColor)
            .foregroundColor(configuration.isPressed ? primaryColor : secondaryColor)
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
