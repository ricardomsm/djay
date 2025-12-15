import UIKit

extension CAGradientLayer {
    static func gradientLayer(colors: [UIColor], in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors.map(\.cgColor)
        layer.frame = frame
        return layer
    }
}
