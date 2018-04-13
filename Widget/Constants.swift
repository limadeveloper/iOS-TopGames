//
//  Constants.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

struct Completion {
    typealias Empty = (() -> Void)?
    typealias DataFromURL = (Data?, URLResponse?, Error?) -> Void
    typealias Results = (([Any]?, Error?) -> Void)?
}
