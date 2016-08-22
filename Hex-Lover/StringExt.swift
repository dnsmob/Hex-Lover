
import Foundation

extension String {
	
	public func indexOf(target:String) -> Int {
		if let range = self.rangeOfString(target) {
			return startIndex.distanceTo(range.startIndex)
		} else {
			return -1
		}
	}
	
	public func lastIndexOf(target:String) -> Int {
		if let range = self.rangeOfString(target, options: NSStringCompareOptions.BackwardsSearch) {
			return startIndex.distanceTo(range.startIndex)
		} else {
			return -1
		}
	}
}





