
import Foundation
import UIKit

@IBDesignable class ColorSliderUIView: UIView, UITextFieldDelegate {
	
	private let nibName:String = "ColorSliderUIView"
	var view:UIView!
	
	var delegate:ViewController! {
		didSet {
			valueField.delegate = delegate
		}
	}
	@IBOutlet private weak var slider: UISlider!
	@IBOutlet private weak var valueHolder: UIView!
	@IBOutlet private weak var valueField: UITextField!

	
	@IBInspectable var trackColor: UIColor = UIColor.clearColor() {
		didSet {
			slider.minimumTrackTintColor = trackColor
		}
	}
	
	@IBInspectable override var tag:Int {
		didSet {
			valueField.tag = tag
		}
	}
	
	var value:CGFloat {
		set {
			slider.setValue(Float(newValue), animated: false)
			onValueChanged()
		}
		get {
			return CGFloat(slider.value)
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		setupView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	private func setupView() {
		view = loadNib()
		view.frame = bounds
		view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		addSubview(view)
		
		randomizeValue()
		dispatch_async (dispatch_get_main_queue ()) {
			self.onValueChanged()
		}
	}
	
	private func loadNib() -> UIView {
		let bundle = NSBundle(forClass: self.dynamicType)
		let nib = UINib(nibName: nibName, bundle: bundle)
		let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
		return view
	}
	
	func randomizeValue (){
		slider.setValue(Float(Int.random(0, upper: 255)), animated: false)
	}
	
	@IBAction func onValueChanged(sender: UISlider? = nil) {
		// update holder position
		valueHolder.frame.origin.x = xPositionFromSliderValue() - valueHolder.frame.width / 2
		valueField.text = String(Int(slider.value))
		
		if let del = delegate { // prevent IB crashing
			del.setColor()
			del.view.endEditing(true)
		}
		
	}
	
	private func xPositionFromSliderValue() -> CGFloat {
		let box = slider.thumbRectForBounds(slider.bounds, trackRect: slider.trackRectForBounds(slider.bounds), value: slider.value)
		return box.origin.x + box.width / 2 + slider.frame.origin.x
	}
}






