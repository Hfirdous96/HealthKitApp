//
//  HealthChartView.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import SwiftUI
import Charts

struct HealthChartView: View {
    @Binding var items: [BarChartData]

    var body: some View {
        Chart {
            ForEach(items, id: \.self) { item in
                BarMark(x: .value(item.xKey, item.xValue), y: .value(item.yKey, item.yValue))
            }
        }
    }
}
