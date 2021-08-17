//
//  UIColor.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 17/08/21.
//  https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

import SwiftUI

extension UIColor {
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        let hred, hgreen, hblue: CGFloat

        var hexColor = ""
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        } else {
            hexColor = hex
        }

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                hred = CGFloat((hexNumber & 0xff000000) >> 16) / 255
                hgreen = CGFloat((hexNumber & 0x00ff0000) >> 8) / 255
                hblue = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: hred, green: hgreen, blue: hblue, alpha: alpha)
                return
            }
            return nil
        }

        return nil
    }
}
