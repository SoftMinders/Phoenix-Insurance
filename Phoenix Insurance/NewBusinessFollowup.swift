//
//  NewBusinessFollowup.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 29/01/25.
//

import SwiftUI

struct NewBusinessFollowup: View {
    @State private var isMenuOpen = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var allBusinessFollowups: NewBusinessFollowupsResponse?
    @State private var navigationPath = NavigationPath()
    @State private var isPopupPresented = false
    @State private var selectedBusiness: Businesses? = nil
    
    var body: some View {
        NavigationView{
            if isLoading {
                ProgressView()
            }
            else if let data = allBusinessFollowups {
                VStack {
                    List(data.business) { business in
                        let currentDate = Date()
                        let formattedDate = formatDate(business.MTB_FOLLOW_UP_DATE)
                        let backgroundColor = getBackgroundColor(for: formattedDate, currentDate: currentDate)
                        ZStack {
                            backgroundColor
                                .cornerRadius(10) // Optional: Rounded corners for the background
                                .padding(.vertical, 5) // Add vertical padding to separate items
                            VStack(alignment: .leading) {
                                Text("\(business.CONTACT ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Vehicle: \(business.MTB_VEHI_NO ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Text("Followup: \(business.MTB_FOLLOW_UP_DATE ?? "N/A")")
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
                            if let contact = selectedBusiness {
                            // Popup content here
                                NewBusinessFollowupDetailView(bus_id: contact.id)
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
        APIService.shared.fetchNewBusinessFollowups(ucode: UserDefaults.standard.string(forKey: "ucode") ?? "401") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.allBusinessFollowups = data
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

struct NewBusinessFollowup_Previews: PreviewProvider {
    static var previews: some View {
        NewBusinessFollowup()
    }
}
