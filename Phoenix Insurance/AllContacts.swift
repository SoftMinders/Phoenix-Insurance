//
//  AllContacts.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 26/01/25.
//

import SwiftUI

struct AllContactsView: View {
    @State private var isMenuOpen = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var allContacts: ContactResponse?
    @State private var navigationPath = NavigationPath()
    @State private var isPopupPresented = false
    @State private var selectedContact: APIContact? = nil
    
    var body: some View {
        NavigationView{
            if isLoading {
                ProgressView()
            }
            else if let data = allContacts {
                VStack {
                    List(data.contacts) { contact in
                        VStack(alignment: .leading) {
                            Text("\(contact.MMC_TITLE ?? "") \(contact.MMC_FIRSTNAME) \(contact.MMC_SURNAME)")
                                .font(.headline)
                            Text("Phone: \(contact.MMC_MOBILENO ?? "N/A")")
                                .font(.subheadline)
                            if let address = contact.MMC_ADDRESS3, let city = contact.MMC_CITY {
                                Text("\(address), \(city)")
                                    .font(.subheadline)
                            }
                            if let email = contact.MMC_EMAIL {
                                Text("Email: \(email)")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        .onTapGesture {
                            selectedContact = contact
                            isPopupPresented = true
                        }
                    }
                    .sheet(isPresented: $isPopupPresented) {
                        if let contact = selectedContact {
                            // Popup content here
                            ContactDetailView(contact: contact.MMC_ID)
                        }
                    }
                }
            }else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .accentColor(.white) // Set the back button color here
        .onAppear {
            fetchAllContacts()
        }
        .navigationTitle("All Contacts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .animation(.easeInOut, value: isMenuOpen)
        .tint(Color(hex:"#FFF"))
        
    }
    private func fetchAllContacts() {
        APIService.shared.fetchAllContactsData(ucode: UserDefaults.standard.string(forKey: "ucode") ?? "") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.allContacts = data
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
struct AllContacts_Previews: PreviewProvider {
    static var previews: some View {
        AllContactsView()
    }
}
