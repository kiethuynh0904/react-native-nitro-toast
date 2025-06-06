//
//  Assets.swift
//  boost-boost_privacy
//
//  Created by kiet.huynh on 6/6/25.
//

import Foundation

class ToastAssets {
    class func bundle() -> Bundle {
        let podBundle = Bundle(for: ToastAssets.self)
        if let url = podBundle.url(forResource: "NitroToast", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle ?? podBundle
        }
        return podBundle
    }
}
