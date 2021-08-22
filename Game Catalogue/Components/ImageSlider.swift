//
//  ImageSlider.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 14/08/21.
//

import SwiftUI

struct ImageSlider: View {
    private static let SPACING: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 24 : 12
    private static let RATIO: CGFloat = 0.85
    private static let IMAGEWIDTH: CGFloat = UIScreen.main.bounds.width

    var height: CGFloat = 0.35 * UIScreen.main.bounds.height
    @Binding var urls: [String]
    var onPress: ((Int) -> Void)?

    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    @GestureState private var dragState = DragState.inactive
    @State private var activeIdx = 0

    var body: some View {
        ZStack {
            ForEach(0..<urls.count, id: \.self) { idx in
                LoadableImage(urls[idx]) { image in
                    image.resizable()
                        .clipped()
                        .cornerRadius(5, antialiased: true)
                        .padding(.horizontal, ImageSlider.SPACING)
                        .frame(width: ImageSlider.IMAGEWIDTH)
                        .frame(maxHeight: height)
                        .offset(x: getOffset(idx: idx))
                        .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                        .scaleEffect(activeIdx == idx ? 1 : ImageSlider.RATIO)
                        .onTapGesture {
                            self.onPress?(idx)
                        }
                }
            }
        }
        .gesture(dragGesture)
        .onReceive(self.timer) { _ in
            let dataSum = self.urls.isEmpty ? 1 : self.urls.count
            self.activeIdx = (self.activeIdx + 1) % dataSum
        }
    }

    private func getOffset(idx: Int) -> CGFloat {
        let relativePosition = idx - activeIdx
        let width = UIScreen.main.bounds.width
        let adjustment = width - (width * ImageSlider.RATIO) + ImageSlider.SPACING
        return (
            (CGFloat(relativePosition) * (width * ImageSlider.RATIO)) +
                (CGFloat(relativePosition.signum()) * adjustment)
        )
    }
}

extension ImageSlider {
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragState, body: updating)
            .onEnded(onEnded)
    }

    private func updating(_ value: DragGesture.Value, _ state: inout DragState, _ transaction: inout Transaction) {
        state = .dragging(translation: state.translation)
    }

    private func onEnded(_ drag: DragGesture.Value) {
        let threshold: CGFloat = 0.1 * ImageSlider.IMAGEWIDTH
        let predictedWidth = drag.predictedEndTranslation.width
        let translationWidth = drag.translation.width
        if predictedWidth > threshold || translationWidth > threshold {
            if activeIdx > 0 {
                activeIdx -= 1
            }
        } else if (predictedWidth) < (-1 * threshold) || (translationWidth) < (-1 * threshold) {
            if activeIdx < urls.count - 1 {
                activeIdx += 1
            }
        }
    }
}

private enum DragState {
    case inactive, dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive: return .zero
        case .dragging(let translation): return translation
        }
    }
    var isDragging: Bool {
        switch self {
        case .inactive: return false
        case .dragging: return true
        }
    }
}
