//
//  ViewController.swift
//  SSFillingButton
//
//  Created by sambhav7890 on 01/30/2017.
//  Copyright (c) 2017 sambhav7890. All rights reserved.
//

import UIKit
import SSFillingButton

class ViewController: UIViewController {

	@IBOutlet weak var progressButtonView: SSFillingButton!
	@IBOutlet weak var firstTextField: UITextField!
	@IBOutlet weak var lastTextField: UITextField!
	@IBOutlet weak var fillingButton: SSTimedFillingButton!

	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

		self.progressButtonView.completionBlock = {
			self.firstTextField.text = nil
			self.lastTextField.text = nil
			self.textFieldValueChanged(nil)
			self.startFilling()
		}

		self.progressButtonView.completionButtonDidActiveBlock = {
			self.progressButtonView.text = "Proceed";
		}

		self.progressButtonView.completionButtonDidNonActiveBlock = {
			self.progressButtonView.text = "Disabled"
		}

		self.progressButtonView.completionButtonDidNonActiveBlock?()



		self.fillingButton.text = "Proceed"

		self.fillingButton.completionBlock = {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
				self.startFilling()
			})
		}
    }

	func startFilling() {
		self.fillingButton.startFilling()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func textFieldValueChanged(_ sender: AnyObject?) {

		var progress: CGFloat = 0

		if let firstText = self.firstTextField.text {
			let count: Int = firstText.characters.count < 20 ? firstText.characters.count : 20
			progress += (0.5 * CGFloat(count)/20.0)
		}

		if let lastText = self.lastTextField.text {
			let count: Int = lastText.characters.count < 18 ? lastText.characters.count : 18
			progress += (0.5 * CGFloat(count)/18.0)
		}

		self.progressButtonView.updateProgress(progress)
	}
}
