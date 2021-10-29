import UIKit
public protocol TaggingDataSource: class {
    func tagging(_ tagging: Tagging, didChangedTagableList tagableList: [String])
    func tagging(_ tagging: Tagging, didChangedTaggedList taggedList: [TaggingModel])
    func tagging(_ tagging: Tagging, didChangedText text: String?)
    func tagging(_ tagging: Tagging, didChangedHeight height: CGFloat)
    func tagging(_ tagging: Tagging, didChangedMentionText text: String?)
}

public extension TaggingDataSource {
    func tagging(_ tagging: Tagging, didChangedTagableList tagableList: [String]) {return}
    func tagging(_ tagging: Tagging, didChangedTaggedList taggedList: [TaggingModel]) {return}
    func tagging(_ tagging: Tagging, didChangedText text: String?){return}
    func tagging(_ tagging: Tagging, didChangedHeight height: CGFloat){return}
    func tagging(_ tagging: Tagging, didChangedMentionText text: String?){return}
}
