//
//  ContactDetailView.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 29/01/25.
//

import SwiftUI

struct ContactDetailView: View {
    var contact: String
    @State private var isLoading = true
    @State private var singleContactData: SingleContactResponse?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView{
            if isLoading {
                ProgressView()
            }
            else if let data = singleContactData {
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack {
                            Text("\(data.contactval.MMC_TITLE ?? "") \(data.contactval.MMC_FIRSTNAME) \(data.contactval.MMC_SURNAME)")
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .textCase(.uppercase)
                            
                            Text("Address: \(data.contactval.MMC_ADDRESS3 ?? "N/A"), \(data.contactval.MMC_CITY ?? "N/A")")
                                .font(.system(size: 16, weight: .bold))
                                .padding()
                                .foregroundColor(.black)
                                .textCase(.uppercase)
                            
                            HStack {
                                Text("Phone: \(data.contactval.MMC_MOBILENO ?? "N/A")")
                                    .padding()
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                
                                Spacer()
                                
                                Text("Email: \(data.contactval.MMC_EMAIL ?? "N/A")")
                                    .padding()
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                            }
                            
                            Divider().background(Color.blue)
                            
                            VStack {
                                Text("Referral Name:")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Text("Policy Number: \(data.contactinfo.MTB_POL_NO ?? "N/A")")
                                        .font(.system(size: 10, weight: .bold))
                                        .padding()
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("Date From: \(data.contactinfo.MTQ_PERIOD_FORM ?? "N/A")")
                                        .font(.system(size: 10, weight: .bold))
                                        .padding()
                                        .foregroundColor(.black)
                                }
                                
                                HStack {
                                    Text("Vehicle Number: \(data.contactinfo.MTB_VEHI_NO ?? "N/A")")
                                        .font(.system(size: 10, weight: .bold))
                                        .padding()
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("Date To: \(data.contactinfo.MTQ_PERIOD_TO ?? "N/A")")
                                        .font(.system(size: 10, weight: .bold))
                                        .padding()
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Divider().background(Color.blue)
                            
                            Text("Premium: \(data.contactinfo.MTB_PREMIUM ?? "N/A")")
                                .font(.system(size: 10, weight: .bold))
                                .padding()
                                .foregroundColor(.black)
                            
                            Text("Status: \(data.contactval.MMC_STATUS ?? "N/A")")
                                .font(.system(size: 10, weight: .bold))
                                .padding()
                                .foregroundColor(.black)
                            
                            Text("Business Status: \(data.contactinfo.MTB_BUS_STATUS ?? "N/A")")
                                .font(.system(size: 10, weight: .bold))
                                .padding()
                                .foregroundColor(.black)
                        }
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                        .padding()
                    }
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
            }else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .accentColor(.white) // Set the back button color here
        .onAppear {
            fetchSingleContact()
        }
    }
    private func fetchSingleContact() {
        APIService.shared.fetchSingleContactsData(cust_id: contact ) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.singleContactData = data
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

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: "CUST3227")
    }
}

