//
//  UniqueIdentifier.swift
//  TenThousend
//
//  Created by Yaser on 2018-01-26.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

protocol UniqueIdentifier {
    var uuidString: String { get }
}
extension UUID: UniqueIdentifier {}
