//
//  NewBusinessFollowupDetailView.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 30/01/25.
//

import SwiftUI

struct NewBusinessFollowupDetailView: View {
    var bus_id: String
    @State private var isLoading = true
    @State private var singleNewBusinessData: NewBusinessFollowupsSingleResponse?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView{
            if isLoading {
                ProgressView()
            }
            else if let data = singleNewBusinessData {
                ZStack{
                    ScrollView {
                        Spacer()
                        VStack(alignment: .leading) {
                            VStack {
                                Text("\(data.business.CONTACT)")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding()
                                    .padding(.horizontal)
                                    .foregroundColor(.black)
                                    .textCase(.uppercase)
                                
                                Text("Followup Date: \(data.business.MTB_FOLLOW_UP_DATE)")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .foregroundColor(.black)
                                    .textCase(.uppercase)
                                
                                HStack {
                                    Text("Phone: \(data.business.MMC_MOBILENO)")
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                    
                                    Text("Vehicle Number: \(data.business.MTB_VEHI_NO)")
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                }
                                
                                Divider().background(Color.blue)
                                
                                VStack {
                                    HStack {
                                        Text("Class: \(data.business.CLASS)")
                                            .font(.system(size: 10, weight: .bold))
                                            .padding()
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Text("Product: \(data.business.PRODUCT)")
                                            .font(.system(size: 10, weight: .bold))
                                            .padding()
                                            .foregroundColor(.black)
                                    }
                                    
                                    HStack {
                                        Text("Type: \(data.business.MTB_TYPE_OF_PROSPECTIVE)")
                                            .font(.system(size: 10, weight: .bold))
                                            .padding()
                                            .foregroundColor(.black)
                                    }
                                }
                                
                            }
                            .cornerRadius(15)
                            .padding()
                        }
                        .background(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    .background(Color(hex: "#bfdfe7"))
                    .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                        FloatingButtonRow(label: "Follow Up / Edit", icon: "pencil", color: Color.orange)
                        FloatingButtonRow(label: "Quotation", icon: "doc.text", color: Color.red)
                        FloatingButtonRow(label: "Download", icon: "arrow.down.circle", color: Color.blue)
                        FloatingButtonRow(label: "Upload", icon: "arrow.up.circle", color: Color.green)
                        FloatingButtonRow(label: "Delete", icon: "trash", color: Color.red)
                    }
                    .padding()
                }
            }else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .accentColor(.white) // Set the back button color here
        .onAppear {
            fetchSingleBusiness()
        }
    }
    private func fetchSingleBusiness() {
        APIService.shared.fetchSingleNewBusinessFollowups(bus_id: bus_id ) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.singleNewBusinessData = data
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
struct NewBusinessFollowupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewBusinessFollowupDetailView(bus_id: "MTB315")
    }
}
