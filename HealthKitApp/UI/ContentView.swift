//
//  ContentView.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel

    let segments = ["Today", "History"]

    @State private var selectedSegment = "Today"

    var body: some View {
        VStack {
            if viewModel.isAuthorized {
                segmentedControl
                content
            } else {
               healthKitAuthorization
                    .padding(.top, 50)
            }
            Spacer()
        }
        .onAppear {
            viewModel.getAuthToken()
            viewModel.healthAuthorizationRequest()
        }
    }

    private var segmentedControl: some View {
        VStack {
            ZStack(alignment: .leading) {
                Picker("", selection: $selectedSegment) {
                    ForEach(segments, id: \.self) { segment in
                        Text(segment)
                            .tag(segment)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private  var content: some View {
        VStack {
            if selectedSegment == segments[0] {
                TodayView(viewModel: viewModel)
            } else {
                HistoryView(viewModel: viewModel)
            }
        }
    }

    private var healthKitAuthorization: some View {
        VStack {
            Text("Please Authorize Health!")
                .font(.title3)

            Button {
                viewModel.healthAuthorizationRequest()
            } label: {
                Text("Authorize HealthKit")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: 320, height: 55)
            .background(Color(.orange))
            .cornerRadius(10)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(viewModel: .init())
//    }
//}
