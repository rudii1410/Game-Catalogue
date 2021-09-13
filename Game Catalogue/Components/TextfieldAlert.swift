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
//  from: https://medium.com/flawless-app-stories/swiftui-uialertcontroller-with-textfield-inside-it-ae3c979e8e5b

import SwiftUI

struct TextfieldAlert: UIViewControllerRepresentable {
    @Binding var showAlert: Bool

    var title: String
    var message: String
    var placeholder = ""
    var textString = ""
    var onSubmit: (String) -> Void

    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard context.coordinator.alert == nil else { return }

        if showAlert {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert

            alert.addTextField { tField in
                tField.placeholder = placeholder
                tField.text = textString
                tField.delegate = context.coordinator
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                alert.dismiss(animated: true) {
                    showAlert = false
                }
            })
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.onSubmit(text)
                }
                alert.dismiss(animated: true) {
                    showAlert = false
                }
            })

            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true) {
                    self.showAlert = false
                    context.coordinator.alert = nil
                }
            }
        }
    }

    func makeCoordinator() -> TextfieldAlert.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var tfAlert: TextfieldAlert

        init(_ tfAlert: TextfieldAlert) {
            self.tfAlert = tfAlert
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.tfAlert.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.tfAlert.textString = ""
            }
            return true
        }
    }
}
