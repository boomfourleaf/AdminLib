//
//  AsyncImageViewExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/13/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension AsyncImageView: flAsyncImageView {
    public func setAsyncImage(name: String) {
        self.crossfadeDuration = 0.4;
        self.imageURL = NSURL(fileURLWithPath: name)
    }
}
