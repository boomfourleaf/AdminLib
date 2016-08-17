//
//  flPagingFlexibleTextScrollView.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/9/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

public protocol flPagingFlexibleTextScrollViewDelegate: UIScrollViewDelegate {
    func pagingFlexibleTextDidSelect(index: Int)
}

public class flPagingFlexibleTextScrollView: UIScrollView, UIScrollViewDelegate {
    public struct TextInfo {
        var x: CGFloat
        var width: CGFloat
        var name: String
    }
    
    public var selectedIndex = 0
    public var currentHilight = -1
    public var isDeacceleranting = false
    lazy var infos: [TextInfo] = {
        [TextInfo]()
    }()

    public weak var delegate2: flPagingFlexibleTextScrollViewDelegate?
    
    public func myInit() {
        delegate = self
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        myInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myInit()
    }
}

// MARK: Setup
extension flPagingFlexibleTextScrollView {
    public func setupPaging(texts: [String]?) {
        if let textsValue = texts {
            if 0 == textsValue.count {
                return
            }
            
            var begin: CGFloat = 0
            
            for (i, text) in textsValue.enumerate() {
                let button = UIButton(type: .Custom)
                let buttonFont = (i == selectedIndex) ? config.fontForSelected : config.font
                
                button.titleLabel?.font = buttonFont
                button.setTitleColor(config.fontColor, forState: .Normal)
                button.setTitle(text, forState: .Normal)
                button.showsTouchWhenHighlighted = true
                
                let textSize = (text as NSString).sizeForFontCeil(buttonFont, frameSize: CGSizeMake(9999, config.textHeight))
                
                button.frame = buttonFrameForTextWidth(textSize.width, x: begin)
                if i == selectedIndex {
                    button.frame.origin.y = config.textMarginForSelected.top
                }
                
                button.tag = config.buttonStarTag + i
                button.addTarget(self, action: #selector(flPagingFlexibleTextScrollView.didHitText(_:)), forControlEvents: .TouchUpInside)
                
                self.addSubview(button)

                let width = button.frame.size.width + config.textMargin.left + config.textMargin.right
                infos.append(TextInfo(x: begin, width: width, name: text))
                begin += width
            }
            
            contentSize = CGSizeMake(begin, 58)
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            
            // Set Content Inset
            switch (infos.first, infos.last) {
            case (.Some(let first), .Some(let last)):
                contentInset = UIEdgeInsetsMake(
                    0, config.leftHalfWidth - (first.width / 2),
                    0, config.rightHalfWidth - (last.width / 2))
            default:
                break
            }
            
            scrollToIndex(0, animated: false)
            hilightLine(0, notify: false)
            
            // Scrollview faster bounce
            decelerationRate = UIScrollViewDecelerationRateFast
        }
    }
    
    public func removeAllTexts() {
        for subview in subviews {
            if let button = subview as? UIButton {
                button.removeFromSuperview()
            }
        }
    }
}

// MARK: Helper
extension flPagingFlexibleTextScrollView {
    public func buttonFrameForTextWidth(width: CGFloat, x: CGFloat) -> CGRect {
        let newX = x + config.textMargin.left
        let newY = config.textMargin.top
        let newWidth = width + config.textPadding.left + config.textPadding.right
        let newHeight = config.textHeight + config.textPadding.top + config.textPadding.bottom
        return CGRectMake(newX, newY, newWidth, newHeight)
    }
    
    public func buttonFrameForIndex(index: Int) -> CGRect {
        let info = infos[index]
        let textWidth = info.width - config.textMargin.left - config.textMargin.right - config.textPadding.left - config.textPadding.right
        return buttonFrameForTextWidth(textWidth, x: info.x)
    }
    
    public func textIdForScrollPosition(scrollPotision: CGFloat) -> Int? {
        for (i, info) in infos.enumerate() {
            let scrollCenter = scrollPotision + config.leftHalfWidth
            if scrollCenter >= info.x && scrollCenter < info.x + info.width {
                return i
            }
        }
        if infos.count > 0 {
            return 0
        }

        return nil
    }
    
//    func textAnimationName(textId: Int) -> String {
//        return "\(config.FL_PAGING_TEXT_ANIMATION_NAME_PREFIX)\(textId)"
//    }
    
//    func textAnimationId(name: String) -> Int? {
//        let outputs = name.componentsSeparatedByString(config.FL_PAGING_TEXT_ANIMATION_NAME_PREFIX)
//        
//        if  2 == outputs.count {
//            if let textId = outputs[1].toInt() {
//                return textId
//            }
//        }
//        return nil
//    }
}

// MARK: Manage Scroll
extension flPagingFlexibleTextScrollView {
    public func scrollToIndex(index: Int, animated: Bool) {
        let textInfo = infos[index]
        let targetX = textInfo.x - config.leftHalfWidth + textInfo.width / 2
        
        let animationTask: ()->() = { self.contentOffset = CGPointMake(targetX, 0) }
        if animated {
            Animate.duration(0.25, animate: animationTask).run()
        } else {
            animationTask()
        }
    }
    
    public func clearScrollView() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

// MARK: Selected Index Display
extension flPagingFlexibleTextScrollView {
    public func hilightLine(textId: Int, notify: Bool, withFont font: UIFont) {
        currentHilight = textId
        
        let info = infos[textId]
        
        let lineWidth = (info.name as NSString).sizeForFontCeil(font, frameSize: CGSizeMake(9999, config.textHeight)).width
        let targetFrame = CGRectMake(
            frame.origin.x + config.leftHalfWidth - lineWidth / 2,
            frame.origin.y + config.hilightLineFrame.origin.y,
            lineWidth,
            config.hilightLineFrame.size.height)
        
        if let view = superview?.viewWithTag(config.hilightIndicatorTag) {
            
            Animate.duration(0.25) {
                view.frame = targetFrame
            }.task{
                if notify {
                    self.delegate2?.pagingFlexibleTextDidSelect(self.selectedIndex)
                }
            }.run()

        } else {
            let view = UIView(frame: targetFrame)
            view.tag = config.hilightIndicatorTag
            view.backgroundColor = config.fontColor
            superview?.addSubview(view)
            
            // Round coerner
            view.layer.cornerRadius = 2.0
        }
    }
    
    public func hilightLine(textId: Int, notify: Bool) {
        hilightLine(textId, notify: notify, withFont: config.fontForSelected)
    }
    
//    func hilightLineDidStop(animationID: String?, finished: NSNumber?, context: Any) {
//        
//    }
}

// MARK: Event
extension flPagingFlexibleTextScrollView {
    public func updateTextSelected(index: Int) {
        if index != selectedIndex {
            // Set font back for old index
            if selectedIndex >= 0 {
                let finalButtonFrame = buttonFrameForIndex(selectedIndex)
                if let oldButton = viewWithTag(config.buttonStarTag + selectedIndex) as? UIButton {
                    let scale = CGFloat(2.0) - config.textForSelectedScale
                    
                    Animate.duration(0.25) {
                        oldButton.frame.origin.y = config.textMargin.top
                        oldButton.transform = CGAffineTransformMakeScale(scale, scale)
                    }.task{
                        oldButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        oldButton.titleLabel?.font = config.font
                        oldButton.frame = finalButtonFrame
                    }.run()
                }
            }
            
            selectedIndex = index
            
            // Set font for new index
            if let button = viewWithTag(config.buttonStarTag + index) as? UIButton {
                
                Animate.duration(0.25) {
                    button.frame.origin.y = config.textMarginForSelected.top
                    button.transform = CGAffineTransformMakeScale(config.textForSelectedScale, config.textForSelectedScale)
                }.task{
                    let info = self.infos[index]
                    button.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    let textSize = (info.name as NSString).sizeForFontCeil(config.fontForSelected, frameSize: CGSizeMake(9999, 36))
                    button.titleLabel?.font = config.fontForSelected
                    
                    button.frame = CGRectMake(info.x + (info.width - textSize.width) / 2,
                        config.textMarginForSelected.top,
                        textSize.width,
                        button.frame.size.height)
                }.run()
            }
        }
    }
    
    public func didHitText(sender: UIButton) {
        let textId = sender.tag - config.buttonStarTag
        if selectedIndex != textId {
            updateTextSelected(textId)
            scrollToIndex(textId, animated: true)
            hilightLine(textId, notify: true)
        }
    }
}

// MARK: UIScrollView Delegate
extension flPagingFlexibleTextScrollView {
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isDeacceleranting = false
    }
    
    func forwardIndex<T>(index: Int, arr: [T]) -> Int {
        if index + 1 <= arr.count - 1 {
            return index + 1
        }
        return index
    }
    
    func backwardIndex<T>(index: Int, arr: [T]) -> Int {
        if index - 1 >= 0 {
            return index - 1
        }
        return index
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if var textId = textIdForScrollPosition(targetContentOffset[0].x) {
            // For swipe left or right gesture recognize
            if textId == selectedIndex && 0 != velocity.x {
                if velocity.x > 0 {
                    textId = forwardIndex(textId, arr: infos)
                } else {
                    textId = backwardIndex(textId, arr: infos)
                    if textId - 1 >= 0 {
                        textId -= 1
                    }
                }
            }
            
            let info = infos[textId]
            var targetX = info.x - config.leftHalfWidth + info.width / 2
            // Workaround for first and last text scroll posision out of bound
            if 0 == textId {
                targetX += 1;
            } else if infos.count - 1 == textId {
                targetX -= 1
            }
            
            targetContentOffset[0] = CGPointMake(targetX, 0)
            if selectedIndex != textId {
                updateTextSelected(textId)
                hilightLine(textId, notify: true)
            }
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isDeacceleranting {
            if let textId = textIdForScrollPosition(scrollView.contentOffset.x) {
                if textId != currentHilight {
                    hilightLine(textId, notify: false, withFont: (textId == selectedIndex) ? config.fontForSelected : config.font)
                }
            }
        }
    }
    
    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        isDeacceleranting = true
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isDeacceleranting = false
        hilightLine(selectedIndex, notify: false)
    }
}

// MARK: Config
extension flPagingFlexibleTextScrollView {
    private struct config {
        static let leftHalfWidth: CGFloat = 219
        static let rightHalfWidth: CGFloat = 219
        static let font = UIFont.flNormalFont(23)
        static let fontForSelected = UIFont.flBoldFont(29)
        static let fontColor = UIColor.blackColor()
        static let hilightIndicatorTag = 99801
        static let buttonStarTag = 99700
        static let textMargin = UIEdgeInsetsMake(3, 10, 0, 10)
        static let textMarginForSelected = UIEdgeInsetsMake(7, 0, 0, 0) // Use only top
        static let textPadding = UIEdgeInsetsMake(3, 20, 7, 20)
        static let textForSelectedScale: CGFloat = 1.26
        static let textHeight: CGFloat = 36
        static let hilightLineFrame = CGRectMake(0, 53, 0, 5)
        static let FL_PAGING_TEXT_ANIMATION_NAME_PREFIX = "Text Animation with id "
    }
}
