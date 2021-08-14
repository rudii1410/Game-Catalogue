//
//  ImageSlider.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 14/08/21.
//

import SwiftUI

struct ImageSlider: View {
    private let spaceBetweenImage: CGFloat = 12
    private let ratio: CGFloat = 0.85

    private var urls: [String] = []
    private var onPress: ((Int) -> Void)?
    @GestureState private var dragState = DragState.inactive
    @State private var imageWidth: CGFloat = 0
    @State private var activeIdx = 0

    init(imageUrls: [String], onPress: ((Int) -> Void)? = nil) {
        urls = imageUrls
        self.onPress = onPress
        recalculateWidth()
    }

    var body: some View {
        ZStack {
            ForEach(0..<urls.count, id: \.self) { idx in
                AsyncImage(urlStr: urls[idx])
                    .padding(EdgeInsets(
                        top: 0,
                        leading: CGFloat(2 * spaceBetweenImage),
                        bottom: 0,
                        trailing: CGFloat(2 * spaceBetweenImage)
                    ))
                    .frame(width: imageWidth)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: getOffset(idx: idx))
                    .animation(.interpolatingSpring(stiffness: 100.0, damping: 30.0, initialVelocity: 10.0))
                    .scaleEffect(activeIdx == idx ? 1 : ratio)
                    .onTapGesture(count: 1) {
                        guard let onPress = self.onPress else { return }
                        onPress(idx)
                    }
            }
        }
        .gesture(dragGesture)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            recalculateWidth()
        }
    }

    private func getOffset(idx: Int) -> CGFloat {
        let relativePosition = idx - activeIdx
        let adjustment = (imageWidth - (imageWidth * ratio) + spaceBetweenImage) / 2
        print(adjustment)
        return (
            (CGFloat(relativePosition) * (imageWidth * ratio + spaceBetweenImage)) +
                (CGFloat(relativePosition.signum()) * adjustment)
        )
    }

    private func recalculateWidth() {
        imageWidth = UIScreen.main.bounds.width - (2 * spaceBetweenImage)
    }

    public func hehehe() -> ImageSlider {
        return self
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
        let dragThreshold: CGFloat = 200
        let dragPredictedWidth = drag.predictedEndTranslation.width
        let dragTranslationWidth = drag.translation.width
        if dragPredictedWidth > dragThreshold || dragTranslationWidth > dragThreshold {
            if activeIdx > 0 {
                activeIdx -= 1
            }
        } else if (dragPredictedWidth) < (-1 * dragThreshold) || (dragTranslationWidth) < (-1 * dragThreshold) {
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
