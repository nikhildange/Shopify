//
//  Created by nikhil on 22/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import Foundation
import CoreData


extension ProductTaxEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductTaxEntity> {
        return NSFetchRequest<ProductTaxEntity>(entityName: "ProductTaxEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var tax: Double

}
