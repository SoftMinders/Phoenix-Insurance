//
//  FinalizedBusinessList.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 31/01/25.
//

import SwiftUI

struct FinalizedBusinessList: View {
    @State private var isMenuOpen = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var finalizedbusiness: FinalizedBusinessResponse?
    @State private var navigationPath = NavigationPath()
    @State private var isPopupPresented = false
    @State private var selectedBusiness: BusinessFinalized? = nil
    
    var body: some View {
        NavigationView{
            if isLoading {
                ProgressView()
            }
            else if let data = finalizedbusiness {
                VStack {
                    List(data.bus_finalised) { business in
                        let currentDate = Date()
                        let formattedDate = formatDate(business.MTQ_PERIOD_TO)
                        let backgroundColor = getBackgroundColor(for: formattedDate, currentDate: currentDate)
                        ZStack {
                            backgroundColor
                                .cornerRadius(10) // Optional: Rounded corners for the background
                                .padding(.vertical, 5) // Add vertical padding to separate items
                            VStack(alignment: .leading) {
                                Text("\(business.MMC_TITLE ?? "") \(business.MMC_FIRSTNAME ?? "")  \(business.MMC_SURNAME ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Vehicle: \(business.MTB_VEHI_NO ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Text("Phone: \(business.MMC_MOBILENO ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .onTapGesture {
                                selectedBusiness = business
                                isPopupPresented = true
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .sheet(isPresented: $isPopupPresented) {
                            if let fbusiness = selectedBusiness {
                            // Popup content here
                                FinalizedBusinessSingle(quote_id: fbusiness.MTQ_QUO_SEQ)
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
        .navigationTitle("Fnalized Business")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .animation(.easeInOut, value: isMenuOpen)
        .toolbarColorScheme(.light, for: .navigationBar)
        
    }
    private func fetchAllBusiness() {
        APIService.shared.fetchFinalizedPolicyList(ucode: UserDefaults.standard.string(forKey: "ucode") ?? "401") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.finalizedbusiness = data
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

struct FinalizedBusinessList_Previews: PreviewProvider {
    static var previews: some View {
        FinalizedBusinessList()
    }
}
