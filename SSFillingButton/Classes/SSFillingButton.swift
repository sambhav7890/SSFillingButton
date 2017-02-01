//
//  SSFillingButton.swift
//  Pods
//
//  Created by Sambhav Shah on 30/01/17.
//
//

import UIKit

public typealias SSProgressCompletionBlock = (Void) -> (Void)

@objc public protocol SSFillingButtonDelegate: class {
	@objc optional func completionButtonAction()
	@objc optional func completionButtonDidNonActive()
	@objc optional func completionButtonDidActive()
}



@objc open class SSFillingButton: UIButton {

	public weak var delegate: SSFillingButtonDelegate?

	@IBInspectable open var bgColor: UIColor = UIColor.clear {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var bgViewColor:  UIColor = UIColor.red.withAlphaComponent(0.7) {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var progressViewColor: UIColor = UIColor.red {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var textColor: UIColor? = UIColor.white {
		didSet {
			self.updateSubviews()
		}
	}
	@IBInspectable open var textFontSize: CGFloat = 0 {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var textFontName: String? {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var textFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var text: String? {
		didSet {
			self.updateSubviews()
		}
	}

	@IBInspectable open var progress: CGFloat = 0
	@IBInspectable open var animateUpdateProgress: Bool = true
	@IBInspectable open var animationUpdateProgressDuration: TimeInterval = 0.3

	open var completionBlock: SSProgressCompletionBlock?
	open var completionButtonDidNonActiveBlock: SSProgressCompletionBlock?
	open var completionButtonDidActiveBlock: SSProgressCompletionBlock?

	open class func button(_ frame: CGRect = CGRect.zero, completion: SSProgressCompletionBlock? = nil) -> SSFillingButton? {
		return SSFillingButton.init(frame: frame, completion: completion)
	}

	public init(frame: CGRect = CGRect.zero, completion: SSProgressCompletionBlock? = nil) {
		self.completionBlock = completion;
		super.init(frame: frame)
		setup()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	open func updateProgress(_ progress: CGFloat) {
		self.updateProgress(progress, animated: self.animateUpdateProgress)
	}

	open func updateProgress(_ progress: CGFloat, animated: Bool) {
		self.progress = progress > 1 ? 1 : progress < 0 ? 0 : progress
		progressVarUpdated(animated: animated)
	}

	func progressVarUpdated(animated: Bool) {
		let lastUserInteractionEnabled = self.completionButton.isUserInteractionEnabled
		let currentUserInteractionEnabled = (self.progress == 1)

		self.completionButton.isUserInteractionEnabled = currentUserInteractionEnabled

		if !lastUserInteractionEnabled && currentUserInteractionEnabled {
			self.completionButtonDidActive()
		} else if lastUserInteractionEnabled && !currentUserInteractionEnabled {
			self.completionButtonDidNonActive()
		}

		self.progressViewWidthConstraint.constant = self.bounds.size.width * self.progress;

		if animated {
			let duration = self.animationUpdateProgressDuration
			UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
				self.layoutIfNeeded()
			}, completion: { (finished) in
				self.layoutIfNeeded()
			})
		}
	}

	open func enable() {
		self.isUserInteractionEnabled = true
		self.alpha = 1.0
	}

	open func disable() {
		self.isUserInteractionEnabled = false
		self.alpha = 0.9
	}

	//Mark - Private Methods/Variables

	weak var bgView: UIView!
	weak var progressView: UIView!
	weak var completionButton: UIButton!

	var bgViewWidthConstraint: NSLayoutConstraint!
	var progressViewWidthConstraint: NSLayoutConstraint!

	func setup() {
		self.setupSelf()
		self.setupBGView()
		self.setupProgressView()
		self.setupCompletionButton()
		self.setupCommonConstraints()
	}

	func setupSelf() {
		self.backgroundColor = self.bgColor;
	}

	func setupBGView() {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = self.bgViewColor
		self.addSubview(view)
		self.bgView = view

		self.addVerticalConstraints(for: view)
	}

	func setupProgressView() {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = self.progressViewColor
		self.addSubview(view)
		self.progressView = view

		self.addVerticalConstraints(for: view)
	}

	func setupCompletionButton() {
		let button = UIButton(type: UIButtonType.system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor.clear
		button.titleLabel?.font = self.textFont

		button.setTitleColor(self.textColor, for: .normal)
		button.setTitle(self.text, for: .normal)

		button.isUserInteractionEnabled = false

		button.addTarget(self, action: #selector(completionButtonAction), for: UIControlEvents.touchUpInside)

		self.addSubview(button)

		self.completionButton = button

		self.addContainmentConstraints(for: button)
	}


	func setupCommonConstraints() {

		let views = ["bgView": self.bgView, "progressView" : self.progressView]

		let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[progressView]-(0)-[bgView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
		self.addConstraints(horizontalConstraints)

		self.progressViewWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 0, constant: 0)

		self.addConstraint(progressViewWidthConstraint)

	}


	func updateSubviews() {
		self.backgroundColor = self.bgColor
		self.bgView.backgroundColor = self.bgViewColor
		self.progressView.backgroundColor = self.progressViewColor

		self.completionButton.setTitleColor(self.textColor, for: UIControlState.normal)

		// font
		var titleFont: UIFont = self.textFont

		if let fontName = self.textFontName,
			let setTitleFont = UIFont(name: fontName, size: self.textFontSize) {
				titleFont = setTitleFont
		} else if self.textFontSize > 0 {
			titleFont = titleFont.withSize(self.textFontSize)
		}

		self.completionButton.titleLabel?.font = titleFont


		//Text
		self.completionButton.setTitle(self.text, for: .normal)
	}

	func completionButtonAction() {
		self.delegate?.completionButtonAction?()
		self.completionBlock?()
	}

	func completionButtonDidNonActive() {
		self.delegate?.completionButtonDidNonActive?()
		self.completionButtonDidNonActiveBlock?()
	}

	func completionButtonDidActive() {
		self.delegate?.completionButtonDidActive?()
		self.completionButtonDidActiveBlock?()
	}

}

fileprivate extension UIView {

	func addContainmentConstraints(for subView: UIView) {
		self.addVerticalConstraints(for: subView)
		self.addHorizontalConstraints(for: subView)
	}

	func addVerticalConstraints(for subView:UIView) {
		let constraints = subView.verticalConstraintsWithSuperview()
		self.addConstraints(constraints)
	}

	func verticalConstraintsWithSuperview() -> [NSLayoutConstraint] {
		return NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self])
	}

	func addHorizontalConstraints(for subView:UIView) {
		let constraints = subView.horizontalConstraintsWithSuperview()
		self.addConstraints(constraints)
	}

	func horizontalConstraintsWithSuperview() -> [NSLayoutConstraint] {
		return NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self])
	}

}
