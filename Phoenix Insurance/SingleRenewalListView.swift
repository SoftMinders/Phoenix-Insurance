//
//  SingleRenewalListView.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 30/01/25.
//

import SwiftUI

struct SingleRenewalListView: View {
    var vehicle_id: String
    
    @State private var isLoading = true
    @State private var singleRenewalData: SingleRenewalResultResponse?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    VStack {
                        ProgressView("Loading...")
                            .padding()
                        Spacer()
                    }
                } else if let data = singleRenewalData {
                    VStack(alignment: .leading, spacing: 15) {
                        Group {
                            Text("Policy No: \(data.veh_details.POL_POLICY_NO)")
                            Text("Vehicle No: \(data.veh_details.VEH_NO)")
                            Text("Client: \(data.veh_details.CUST_NAME)")
                            Text("Contact: \(data.veh_details.TEL)")
                            Text("Period From: \(data.veh_details.POL_PERIOD_FROM)")
                            Text("Period To: \(data.veh_details.POL_PERIOD_TO)")
                            Text("Sum Insured: \(data.veh_details.POL_SUM_INSURED)")
                            Text("Class: \(data.veh_details.CLASS)")
                            Text("Product: \(data.veh_details.PRODUCT)")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#3D8DBC"))

                        Button(action: {
                            print("Renew Policy tapped")
                        }) {
                            Text("Renew Policy")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#3D8DBC"))
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                }
            }
            .padding(20)
            .background(Color(hex: "#bfdfe7").edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchData()
            }
        }
    }

    func fetchData() {
        APIService.shared.fetchSingleRenewalPolicy(ucode: UserDefaults.standard.string(forKey: "ucode") ?? "401", vehicle_id: vehicle_id) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.singleRenewalData = data
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}



struct SingleRenewalListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleRenewalListView(vehicle_id: "5210DC04")
    }
}
