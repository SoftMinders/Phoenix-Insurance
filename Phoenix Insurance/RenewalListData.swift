//
//  RenewalListData.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 30/01/25.
//

import SwiftUI

struct RenewalListData: View {
    var dateFrom: String
    var dateTo: String
    
    @State private var isMenuOpen = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var renewalList: RenewalListDataResponse?
    @State private var navigationPath = NavigationPath()
    @State private var isPopupPresented = false
    @State private var selectedBusiness: RenewList? = nil
    
    var body: some View {
        NavigationView{
            if isLoading {
                ProgressView()
            }
            else if let data = renewalList {
                VStack {
                    List(data.renew_list) { renewlist in
                        let currentDate = Date()
                        let formattedDate = formatDate(renewlist.P_TO)
                        let backgroundColor = getBackgroundColor(for: formattedDate, currentDate: currentDate)
                        ZStack {
                            backgroundColor
                                .cornerRadius(10) // Optional: Rounded corners for the background
                                .padding(.vertical, 5) // Add vertical padding to separate items
                            VStack(alignment: .leading) {
                                Text("\(renewlist.CUST_NAME ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Divider().foregroundColor(.white)
                                
                                Text("Renewal Date: \(renewlist.P_TO ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text("Policy No.: \(renewlist.POL_POLICY_NO)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Text("Premium: Rs.\(renewlist.POL_PREMIUM ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .onTapGesture {
                                selectedBusiness = renewlist
                                isPopupPresented = true
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .sheet(isPresented: $isPopupPresented) {
                            if let renbus = selectedBusiness {
                            // Popup content here
                                SingleRenewalListView(vehicle_id: renbus.RISK ?? "")
                            }
                        }
                    }
                }
            }else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .accentColor(.white) // Set the back button color here
        .onAppear {
            fetchAllBusiness()
        }
        .navigationTitle("New Business Followup")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .animation(.easeInOut, value: isMenuOpen)
        .toolbarColorScheme(.light, for: .navigationBar)
        
    }
    private func fetchAllBusiness() {
        APIService.shared.fetchRenewalPolicyList(ucode: UserDefaults.standard.string(forKey: "ucode") ?? "401", date_from: dateFrom, date_to: dateTo) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.renewalList = data
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
    private func formatDate(_ dateString: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yy"
        if let dateStr = dateString {
            return dateFormatter.date(from: dateStr) ?? Date()
        }
        return Date()
    }
    func getBackgroundColor(for date: Date, currentDate: Date) -> Color {
        if date < currentDate {
            return Color.red // Past date
        } else if Calendar.current.isDate(date, inSameDayAs: currentDate) {
            return Color.yellow // Today
        } else {
            return Color(hex:"#3C763D") // Future date
        }
    }
}

struct RenewalListData_Previews: PreviewProvider {
    static var previews: some View {
        RenewalListData(dateFrom:"01/01/2024",dateTo:"30/01/2025")
    }
}
