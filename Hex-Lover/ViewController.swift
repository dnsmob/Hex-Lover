
import UIKit
import UIColor_Hex_Swift

class ViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet private weak var colorView: UIView!
	@IBOutlet private weak var colorField: UITextField!
	
	@IBOutlet private weak var red: ColorSliderUIView!
	@IBOutlet private weak var green: ColorSliderUIView!
	@IBOutlet private weak var blue: ColorSliderUIView!
	
	@IBOutlet private weak var stackView: UIStackView!

	private var offset:CGFloat!
	private var textfieldFrame:CGRect!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		red.delegate = self
		green.delegate = self
		blue.delegate = self
		
		colorField.delegate = self
		colorView.layer.cornerRadius = 5
	}
	
	override func viewWillAppear (animated:Bool) {
		super.viewWillAppear (animated)
		
		NSNotificationCenter.defaultCenter ().addObserver (self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter ().addObserver (self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
	}

	override func viewDidAppear(animated: Bool) { // create a constraint to avoid colorView resizing on keyboard show/view slide up
		super.viewDidAppear(animated)
		
		let constraint = NSLayoutConstraint(item: colorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: colorView.frame.size.height)
		view.addConstraint(constraint)
	}
	
	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
			
			if keyboardRect.intersects(textfieldFrame) {
				offset = -keyboardRect.size.height + UIScreen.mainScreen().bounds.height - textfieldFrame.origin.y - textfieldFrame.size.height
				moveMainViewFrame()
			}
		}
	}
	
	@objc private func keyboardWillHide (notification:NSNotification) {
		offset = 0
		moveMainViewFrame()
	}
	
	private func moveMainViewFrame () {
		UIView.animateWithDuration (0.25, animations: {
			self.view.frame.origin.y = self.offset
		})
	}

	func textFieldShouldReturn (textField: UITextField) -> Bool { // on done, hide keyboard
		textField.resignFirstResponder ()
		return true
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) { // force all resign first responder
		view.endEditing(true)
	}

	func textFieldDidBeginEditing(textField: UITextField) {
		let rect = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)
		textfieldFrame = textField.convertRect(rect, toView: view)
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		let tag = textField.tag
		if tag == 0 {
			let rgb = UIColor(rgba: textField.text!).channels
			
			red.value = CGFloat(rgb!.red)
			green.value = CGFloat(rgb!.green)
			blue.value = CGFloat(rgb!.blue)
		}
		else {
			if tag == 1 {
				red.value = CGFloat(Int(textField.text!)!)
			}
			else if tag == 2 {
 				green.value = CGFloat(Int(textField.text!)!)
			}
			else if tag == 3 {
				blue.value = CGFloat(Int(textField.text!)!)
			}
		}
		
		setColor()
	}
	
	func textFieldShouldEndEditing(textField: UITextField) -> Bool {
		var predicate:NSPredicate
		let str = textField.text!
		if str.characters.count <= 0 {
			return false
		}
		
		if textField.tag == 0 { // hex color
			predicate = NSPredicate(format: "SELF MATCHES %@", "\\#{1}?[[a-f][A-F][0-9]]{6}")
		}
		else {
			if Int(str) < 0 || Int(str) > 255 {
				return false
			}
			
			predicate = NSPredicate(format: "SELF MATCHES %@", "[0-9]{1,3}")
		}
		
		let resultString = (str as NSString).stringByReplacingCharactersInRange((str as NSString).rangeOfString(str), withString: str)
		return predicate.evaluateWithObject(resultString)
	}

	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		var predicate:NSPredicate
		if textField.tag == 0 {
			predicate = NSPredicate(format: "SELF MATCHES %@", "\\#{1}[[a-f][A-F][0-9]]{0,6}")
		}
		else {
			if Int(textField.text! + string) > 255 {
				return false
			}
			
			predicate = NSPredicate(format: "SELF MATCHES %@", "[0-9]{0,3}")
		}
		
		let resultString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
		return predicate.evaluateWithObject(resultString)
	}
	
	
	// MARK: background color modifiers
	@IBAction func randomizeColor(sender: UIButton) {
		red.randomizeValue()
		red.onValueChanged()
		
		green.randomizeValue()
		green.onValueChanged()
		
		blue.randomizeValue()
		blue.onValueChanged()
	}

	@IBAction func shareColor(sender: UIButton) {
		let objectsToShare = [colorField.text as! AnyObject]
		let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		
		activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePrint]
		activityVC.popoverPresentationController?.sourceView = sender // source view for ipads
		
		presentViewController(activityVC, animated: true, completion: nil)
	}
	
	func setColor(){
		let color = UIColor(red: red.value / 255, green: green.value / 255, blue: blue.value / 255, alpha: 1)
		colorView.backgroundColor = color
		
		colorField.text = color.hex
	}
	
}

