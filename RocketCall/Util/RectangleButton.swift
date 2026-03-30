//
//  rectangleButton.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/23/26.
//
import UIKit


// TitleEdgesInsets 경고 -> Config로 변경
class RectangleButton: UIButton {
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        setAttributes(title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Text
extension RectangleButton {
    private func setAttributes(title: String, color: UIColor) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = .white
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var attribute = $0
            attribute.font = .boldSystemFont(ofSize: 16)
            return attribute
        }
        config.baseBackgroundColor = color
        config.cornerStyle = .fixed
        config.background.cornerRadius = 10
        self.configuration = config
    }
}


// Icon + text
extension RectangleButton {
    convenience init(
        title: String? = nil,
        image: UIImage? = nil,
        backgroundColor: UIColor,
        tintColor: UIColor? = nil
    ) {
        self.init(title: title ?? "", color: backgroundColor)
        
        var config = self.configuration ?? UIButton.Configuration.filled()
        config.image = image
        config.baseForegroundColor = tintColor ?? .white
        
        if title != nil && image != nil {
            config.imagePadding = 10
        }
        self.configuration = config
    }
}
