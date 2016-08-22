
import UIKit

extension UIColor {
	
	public var channels:(red:Int, green:Int, blue:Int, alpha:Int)? {
		get {
			return self.getChannels()
		}
	}
	
	// http://stackoverflow.com/a/32846745/281474
	private func getChannels() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
		
		var fRed : CGFloat = 0
		var fGreen : CGFloat = 0
		var fBlue : CGFloat = 0
		var fAlpha: CGFloat = 0
		
		if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
			let iRed = Int(fRed * 255.0)
			let iGreen = Int(fGreen * 255.0)
			let iBlue = Int(fBlue * 255.0)
			let iAlpha = Int(fAlpha * 255.0)
			
			return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
		}
		else {
			// Could not extract RGBA components:
			return nil
		}
	}
	
	public var hex:String? {
		get {
			let channels = self.channels
			var str = "#"
			str += formatString((channels?.red)!) + formatString((channels?.green)!) + formatString((channels?.blue)!)
			
			if channels?.alpha < 1 {
				str += formatString((channels?.alpha)!)
			}
			
			return str
		}
	}
	
	private func formatString(value:Int) -> String {
		return String(format:"%02X", value)
	}
}