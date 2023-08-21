//
//  HistoryView.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import SwiftUI
import Charts

struct HistoryView: View {
    @ObservedObject var viewModel: ContentView.ViewModel

    @State var selectedButton = 0

    var body: some View {
        VStack(spacing: 40) {
            historyForDaysView
            chartView
        }
        .onAppear {
            viewModel.getHistoryStepCount(for: 7)
        }
    }

    private var historyForDaysView: some View {
        HStack(spacing: 40) {
            if selectedButton == 0 {
                Button("7 Days") {
                    selectedButton = 0
                    viewModel.getHistoryStepCount(for: 7)
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button("30 Days") {
                    selectedButton = 1
                    viewModel.getHistoryStepCount(for: 30)
                }
                .buttonStyle(.bordered)
            } else {
                Button("7 Days") {
                    selectedButton = 0
                    viewModel.getHistoryStepCount(for: 7)
                }
                .buttonStyle(.bordered)

                Spacer()
                Button("30 Days") {
                    selectedButton = 1
                    viewModel.getHistoryStepCount(for: 30)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(height: 50)
        .padding([.leading, .trailing], 40)
    }

    private var chartView: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HealthChartView(items: $viewModel.historyChartData)
                    .frame(width: CGFloat(25 * viewModel.historyChartData.count))
                    .padding()
            }
        }
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(viewModel: .init())
//    }
//}

struct ButtonStyleNormal: PrimitiveButtonStyle {
    typealias Body = Button
    func makeBody(configuration: Configuration) -> some View {
        configuration.trigger()
        return Button(configuration)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .foregroundColor(Color.white)
            .buttonBorderShape(ButtonBorderShape.roundedRectangle(radius: 4))
    }
}

struct ButtonStyleSelected: PrimitiveButtonStyle {
    typealias Body = Button
    func makeBody(configuration: Configuration) -> some View {
        configuration.trigger()
        return Button(configuration)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .foregroundColor(Color.white)
            .buttonBorderShape(ButtonBorderShape.roundedRectangle(radius: 4))
    }
}
