//
//  TodoWidgetBundle.swift
//  TodoWidget
//
//  Created by Samuel Šulka on 04/04/2025.
//

import WidgetKit
import SwiftUI

@main
struct TodoWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodoWidget()
        TodoWidgetControl()
        TodoWidgetLiveActivity()
    }
}
