//
//  Typography.swift
//  LittleLemon
//
//  Created by 化石星星的橡木盾 on 8/11/25.
//
import SwiftUI

// 统一样式载体（支持小范围覆盖）
struct AppTextStyle {
    enum Casing { case normal, upper, lower }

    var fontName: String
    var size: CGFloat
    var relativeTo: Font.TextStyle? = nil
    var casing: Casing = .normal
    var tracking: CGFloat = 0
    var lineSpacing: CGFloat = 0

    func with(size: CGFloat? = nil,
              casing: Casing? = nil,
              tracking: CGFloat? = nil,
              lineSpacing: CGFloat? = nil,
              relativeTo: Font.TextStyle? = nil,
              fontName: String? = nil) -> AppTextStyle {
        var c = self
        if let size { c.size = size }
        if let casing { c.casing = casing }
        if let tracking { c.tracking = tracking }
        if let lineSpacing { c.lineSpacing = lineSpacing }
        if let relativeTo { c.relativeTo = relativeTo }
        if let fontName { c.fontName = fontName }
        return c
    }
}

// 应用样式的修饰符
struct AppFontModifier: ViewModifier {
    let s: AppTextStyle

    func body(content: Content) -> some View {
        // 先把要用的 textCase 算好（可为 nil）
        let textCase: Text.Case? = {
            switch s.casing {
            case .upper: return .uppercase
            case .lower: return .lowercase
            case .normal: return nil
            }
        }()

        // 如果有 relativeTo 用支持动态字体的初始化
        let font: Font = s.relativeTo.map {
            .custom(s.fontName, size: s.size, relativeTo: $0)
        } ?? .custom(s.fontName, size: s.size)

        return content
            .font(font)
            .tracking(s.tracking)        // 0 就等于不加
            .lineSpacing(s.lineSpacing)  // 0 就等于不加
            .textCase(textCase)          // nil 就等于不变
    }
}

extension View {
    func appFont(_ style: AppTextStyle) -> some View {
        modifier(AppFontModifier(s: style))
    }

    func appParagraphMaxWidth() -> some View {
        self.frame(maxWidth: 680, alignment: .leading)
    }
}

extension AppTextStyle {
    // MARK: Markazi Text
    /// Display Title - Medium 64pt
    static let display = AppTextStyle(
        fontName: "MarkaziText-Medium",
        size: 64,
        relativeTo: .largeTitle,
        tracking: 0.5
    )

    /// Sub title - “靠近 Display”（给 28pt，想更大可调到 32）
    static let subtitle = AppTextStyle(
        fontName: "MarkaziText-Medium",
        size: 28,
        relativeTo: .title
    )

    /// Regular 40pt
    static let markazi40 = AppTextStyle(
        fontName: "MarkaziText-Regular",
        size: 40,
        relativeTo: .title
    )

    // MARK: Karla
    /// Lead text
    static let lead = AppTextStyle(
        fontName: "Karla-Bold",   // 更“轻”可改成 "Karla-Regular"
        size: 20,
        relativeTo: .title3,
        tracking: 0.1
    )

    /// SECTION TITLE! UPPERCASE — Medium 18pt
    static let sectionTitleUpper = AppTextStyle(
        fontName: "Karla-Medium",
        size: 18,
        relativeTo: .headline,
        casing: .upper,
        tracking: 0.8
    )

    /// This Week’s Specials! — ExtraBold 20pt
    static let specialsSection = AppTextStyle(
        fontName: "Karla-ExtraBold",
        size: 20,
        relativeTo: .headline
    )

    /// Categories — ExtraBold 16pt
    static let categories = AppTextStyle(
        fontName: "Karla-ExtraBold",
        size: 16,
        relativeTo: .subheadline
    )

    /// Card Title — Bold 18pt
    static let cardTitle = AppTextStyle(
        fontName: "Karla-Bold",
        size: 18,
        relativeTo: .headline
    )

    /// Paragraph text — Regular 16pt, 1.5 行高（近似：+8pt 行距）
    static let paragraph = AppTextStyle(
        fontName: "Karla-Regular",
        size: 16,
        relativeTo: .body,
        lineSpacing: 8
    )

    /// Highlight（价格等）— Medium 16pt
    static let priceHighlight = AppTextStyle(
        fontName: "Karla-Medium",
        size: 16,
        relativeTo: .body
    )
}
