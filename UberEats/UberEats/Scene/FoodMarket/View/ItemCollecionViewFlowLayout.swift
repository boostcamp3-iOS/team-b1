import UIKit

class ItemCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 8
    let lineSpacing: CGFloat = 8
    var location: Int = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for (index, attribute) in attributes.enumerated() {
                attribute.frame.origin.y = 0
            }
            return attributes
        }
        return nil
    }
}
