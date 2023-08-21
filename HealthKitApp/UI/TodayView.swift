//
//  TodayView.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import SwiftUI
import Charts

struct TodayView: View {
    @ObservedObject var viewModel: ContentView.ViewModel

    var body: some View {
        VStack(spacing: 50) {
            stepsCountView
                .padding(.top, 30)
            stepsProgressView
            chartView
                .padding(.top, 80)
        }
        .padding()
    }

    private var stepsCountView: some View {
        VStack {
            Text(viewModel.userStepCount)
                .font(.largeTitle)
            Text("Steps")
        }
    }

    private var stepsProgressView: some View {
        VStack {
            ProgressBar(value: $viewModel.stepsProgress)
            HStack {
                Spacer()
                Text("\(viewModel.stepsGoal) Steps")
                    .font(.footnote)
            }
        }
        .frame(height: 54)
    }

    private var chartView: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HealthChartView(items: $viewModel.todayCharData)
                    .frame(width: CGFloat(25 * viewModel.todayCharData.count))
                    .padding()
            }
        }
    }
}

//struct TodayView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayView(viewModel: .init())
//    }
//}

