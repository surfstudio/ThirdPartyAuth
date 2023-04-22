//
//  LabelStyle.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 22.04.2023.
//

import UIKit
import Utils

/// Общий стиль для всех лейблов
final class LabelStyle: UIStyle<UILabel> {

    // MARK: - Private Properties

    let font: UIFont
    let fontColor: UIColor
    let lineHeight: CGFloat
    let kern: CGFloat
    let alignment: NSTextAlignment
    let lineBreakMode: NSLineBreakMode
    let crossStyle: StringAttribute.CrossOutStyle?

    // MARK: - Initialization

    init(font: UIFont,
         fontColor: UIColor,
         lineHeight: CGFloat,
         kern: CGFloat,
         alignment: NSTextAlignment = .natural,
         lineBreakMode: NSLineBreakMode = .byTruncatingTail,
         crossStyle: StringAttribute.CrossOutStyle? = nil) {
        self.font = font
        self.fontColor = fontColor
        self.lineHeight = lineHeight
        self.kern = kern
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
        self.crossStyle = crossStyle
    }

    // MARK: - UIStyle

    override func apply(for view: UILabel) {
        var attrs: [StringAttribute] = [
            .font(font),
            .lineHeight(lineHeight),
            .kern(kern),
            .foregroundColor(fontColor),
            .aligment(alignment),
            .lineBreakMode(lineBreakMode)
        ]
        if let crossStyle = crossStyle {
            attrs.append(.crossOut(style: crossStyle))
        }
        view.attributedText = view.text?.with(attributes: attrs)
    }

}

// MARK: - AttributableStyle

extension LabelStyle: AttributableStyle {

    func attributes() -> [NSAttributedString.Key: Any] {
        /// Данный метод используется лишь для получения атрибутов при подсчете высоты текста,
        /// потому намеренно убираем из него параметр .lineBreakMode.
        /// Если этого не сделать - результат будет неверным
        let attrs: [StringAttribute] = [
            .font(font),
            .lineHeight(lineHeight),
            .kern(kern),
            .foregroundColor(fontColor),
            .aligment(alignment),
            .lineBreakMode(lineBreakMode)
        ]
        return attrs.toDictionary()
    }

}
