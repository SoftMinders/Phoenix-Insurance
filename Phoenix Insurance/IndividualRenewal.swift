//
//  IndividualRenewal.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 30/01/25.
//

import SwiftUI

struct IndividualRenewal: View {
    @State private var vehicleNo: String = ""
    @State private var showPopup = false

        var body: some View {
            NavigationView{
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Search by Vehicle No")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#3D8DBC"))
                        
                        TextField("Enter Vehicle No.", text: $vehicleNo)
                            .padding()
                            .frame(height: 50)
                            .background(Color(hex: "#E0E0E0"))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        
                        Button(action: {
                            showPopup = true
                        }) {
                            Text("Search")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#3D8DBC"))
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(20)
                .background(Color(hex: "#bfdfe7").edgesIgnoringSafeArea(.all))
                .sheet(isPresented: $showPopup) {
                    SingleRenewalListView(vehicle_id: vehicleNo)
                }
            }
            .navigationTitle("Individual Renewal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
}

struct IndividualRenewal_Previews: PreviewProvider {
    static var previews: some View {
        IndividualRenewal()
    }
}
