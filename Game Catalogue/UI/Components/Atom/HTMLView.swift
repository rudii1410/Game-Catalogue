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
//  swiftlint:disable line_length
//  swiftlint:disable force_cast

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlString: String
    @Binding var dynamicHeight: CGFloat

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView

        init(_ parent: HTMLView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { height, _ in
                guard let height = height else { return }
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        let content = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style type='text/css'>body { font-family: 'SFUIText'; font-size: \(fontSize); text-align: justify; line-height: 1.4; margin: 0; padding: 0; } p:last-child { margin: 0; padding: 0; }</style></head><body>\(self.htmlString)</body>"
        uiView.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
    }
}
