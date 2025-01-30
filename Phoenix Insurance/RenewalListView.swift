//
//  RenewalListView.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 30/01/25.
//

import SwiftUI

struct RenewalListView: View {
    @State private var dateFrom = Date()
    @State private var dateTo = Date()
    @State private var selectedDateFrom: String?
    @State private var selectedDateTo: String?
    @State private var showDatePickerForFrom = false
    @State private var showDatePickerForTo = false

    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Date From")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#3D8DBC"))
                            
                            Button(action: {
                                showDatePickerForFrom.toggle()
                            }) {
                                Text(dateFormatter.string(from: dateFrom))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#E0E0E0"))
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            }
                            .sheet(isPresented: $showDatePickerForFrom) {
                                DatePicker("Select Date", selection: $dateFrom, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Date To")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#3D8DBC"))
                            
                            Button(action: {
                                showDatePickerForTo.toggle()
                            }) {
                                Text(dateFormatter.string(from: dateTo))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#E0E0E0"))
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            }
                            .sheet(isPresented: $showDatePickerForTo) {
                                DatePicker("Select Date", selection: $dateTo, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                            }
                        }
                    }
                    
                    Button(action: {
                        selectedDateFrom = dateFormatter.string(from: dateFrom)
                        selectedDateTo = dateFormatter.string(from: dateTo)
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
            .background(Color(hex: "#bfdfe7"))
            .navigationDestination(for: String.self) { vehicle in
                RenewalListData(dateFrom: selectedDateFrom ?? "", dateTo: selectedDateTo ?? "")
            }
        }
        .navigationTitle("Renewal List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
}

struct RenewalListView_Previews: PreviewProvider {
    static var previews: some View {
        RenewalListView()
    }
}
