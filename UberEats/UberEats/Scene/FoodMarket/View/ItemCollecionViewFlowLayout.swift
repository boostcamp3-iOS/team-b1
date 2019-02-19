import UIKit

//각 콜렉션뷰 셀의 위치를 고정시킬 수 있습니다.
class ItemCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for (index, attribute) in attributes.enumerated() {
                attribute.frame.origin.y = 2
            }
            return attributes
        }
        return nil
    }

}
