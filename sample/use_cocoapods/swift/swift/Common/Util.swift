import UIKit

class Util {
    static func admobDeviceID() -> String {
        let adid = ASIdentifierManager.shared().advertisingIdentifier
        let cStr = adid.uuidString
        var digest = [CUnsignedChar](repeating: 0, count: 16)
        CC_MD5(cStr, CC_LONG(strlen(cStr)), &digest)

        let output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH) * 2)

        for i in 0..<CC_MD5_DIGEST_LENGTH {
            output.appendFormat("%02x", digest[Int(i)])
        }

        return String(output)
    }
}
