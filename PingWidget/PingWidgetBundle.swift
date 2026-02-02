//
//  PingWidgetBundle.swift
//  PingWidget
//
//  Created by Yeonseo Han on 2/2/26.
//

import WidgetKit
import SwiftUI

@main
struct PingWidgetBundle: WidgetBundle {
    var body: some Widget {
        PingWidget()
        PingWidgetControl()
        PingWidgetLiveActivity()
    }
}
