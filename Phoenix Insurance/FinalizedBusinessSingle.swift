//
//  FinalizedBusinessSingle.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 31/01/25.
//

import SwiftUI

struct FinalizedBusinessSingle: View {
    var quote_id: String
    @State private var isLoading = true
    @State private var singleFinalBusiness: SingleFinalizedBusinessResponse?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView{
            ScrollView {
                if isLoading {
                    VStack {
                        ProgressView("Loading...")
                            .padding()
                        Spacer()
                    }
                } else if let data = singleFinalBusiness {
                    VStack(spacing: 15) {
                        VStack{
                            HStack {
                                Text("\(data.bus_finalised.MMC_TITLE) \(data.bus_finalised.MMC_FIRSTNAME) \(data.bus_finalised.MMC_SURNAME)")
                                    .font(.custom("Poppins-Bold", size: 20))
                                    .foregroundColor(.black)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            HStack {
                                Text("Date From: \(data.bus_finalised.MTQ_PERIOD_FORM)")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            HStack {
                                Text("Date To: \(data.bus_finalised.MTQ_PERIOD_TO)")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Image(systemName: "phone.fill") // Replace with actual icon
                                .foregroundColor(.blue)
                                .padding(.trailing, 5)
                            Text(data.bus_finalised.MMC_MOBILENO)
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "car.fill") // Replace with actual icon
                                .foregroundColor(.blue)
                                .padding(.trailing, 5)
                            Text(data.bus_finalised.MTB_VEHI_NO)
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        
                        Divider().frame(height: 2).background(Color.blue)
                        
                        HStack {
                            VStack {
                                Text("Class: \(data.bus_finalised.MTB_CLASS)")
                                    .font(.custom("Poppins-Bold", size: 14))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            VStack {
                                Text("Product: \(data.bus_finalised.MTB_PRODUCT)")
                                    .font(.custom("Poppins-Bold", size: 14))
                                    .foregroundColor(.black)
                            }
                        }
                        Divider().frame(height: 2).background(Color.blue)
                        
                        HStack {
                            VStack {
                                Text("Type: \(data.bus_finalised.PRD_DESCRIPTION)")
                                    .font(.custom("Poppins-Bold", size: 14))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            VStack {
                                Text("Amount: Rs.\(data.bus_finalised.MTQ_TOT_PRM)")
                                    .font(.custom("Poppins-Bold", size: 14))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(30)
                    .background(Color(hex: "#FFFFFF"))
                    .cornerRadius(20)
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                        FloatingButtonRow(label: "Edit", icon: "pencil", color: Color.green)
                        FloatingButtonRow(label: "View Quotation", icon: "doc.text", color: Color.blue)
                    }
                    .padding()
                }else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                }
            }
            .padding(20)
            .background(Color(hex: "#bfdfe7").edgesIgnoringSafeArea(.all))
        }
        .onAppear{
            fetchData()
        }
        .navigationTitle("Single Finalized Business")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
    }
    func fetchData() {
        APIService.shared.fetchSingleFinalizedPolicyList(ucode: UserDefaults.standard.string(forKey: "ucode") ?? "401", quote_id: quote_id) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.singleFinalBusiness = data
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


struct FinalizedBusinessSingle_Previews: PreviewProvider {
    static var previews: some View {
        FinalizedBusinessSingle(quote_id: "QUO144")
    }
}
