//
//  SSTimedFillingButton.swift
//  Pods
//
//  Created by Sambhav Shah on 01/02/17.
//
//

import UIKit

@objc open class SSTimedFillingButton: SSFillingButton {

	open var fillDuration: TimeInterval = 30
	public var fireInterval: TimeInterval = 0.5

	var fillTimer: Timer?

	private (set) open var  isFillingInProgress: Bool = false

	private var fillCounter: Int = 0

	open override class func button(_ frame: CGRect = CGRect.zero, completion: SSProgressCompletionBlock? = nil) -> SSTimedFillingButton? {
		return SSTimedFillingButton(frame: frame, completion: completion)
	}

	open func startFilling() {
		guard !isFillingInProgress else { return }
		self.isFillingInProgress = true
		if self.progress > 0 {
			self.updateProgress(0, animated: false)
			self.layoutIfNeeded()
		}

		self.disable()
		self.createAndStartFill()
	}

	open func stopFilling() {
		guard isFillingInProgress else { return }

		self.updateProgress(0, animated: false)
		self.layoutIfNeeded()
		self.cleanup()

	}

	func createAndStartFill() {

		fillCounter = 0

		self.updateProgress(1, animated: false)

		let options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, .curveLinear]
		UIView.animate(withDuration: fillDuration, delay: 0.0, options:options, animations: {
			self.layoutIfNeeded()
		}) { (finished) in
			self.layoutIfNeeded()
		}

		fillTimer = Timer.scheduledTimer(timeInterval: fireInterval, target: self, selector: #selector(SSTimedFillingButton.checkFillTimer(_:)), userInfo: nil, repeats: true)
	}

	func checkFillTimer(_ timer: Timer) {

		guard isFillingInProgress else {
			timer.invalidate()
			cleanup()
			return
		}

		if Double(steps) >= fillDuration {
			timer.invalidate()
			cleanup()
		} else {
			iterate()
		}

		fillCounter += 1
	}

	func iterate() {
		updateTitle()
	}

	func cleanup() {
		isFillingInProgress = false

		self.fillTimer?.invalidate()
		self.fillTimer = nil
		updateTitle()
		enable()
	}

	var steps: Int {
		return Int(CGFloat(fillCounter) * CGFloat(fireInterval))
	}

	var countdown: Int {
		let duration = CGFloat(fillDuration)
		let elapsed = CGFloat(fillCounter) * CGFloat(fireInterval)

		var value = duration - elapsed

		if value < 0 {
			value = value * -1
		}


		return Int(value)
	}

	func updateTitle() {
		if isFillingInProgress {
			let titleString = "\(countdown) Sec"
			setTitle(titleString)
		} else {
			setTitle(self.text)
		}
	}

	func setTitle(_ string: String?) {
		self.completionButton.setTitle(string, for: UIControlState.normal)
		self.completionButton.setTitle(string, for: UIControlState.highlighted)
		self.completionButton.setTitle(string, for: UIControlState.disabled)
		self.completionButton.setTitle(string, for: UIControlState.selected)

	}

}
