//
//  AllContacts.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 26/01/25.
//

import SwiftUI

// Define the structure of a contact based on the API response
struct Contact: Identifiable {
    var id: String {
        return MMC_ID
    }
    
    let MMC_ID: String
    let MMC_SURNAME: String
    let MMC_FIRSTNAME: String
    let MMC_TITLE: String
    let MMC_MOBILENO: String
    let MMC_EMAIL: String?
    let MMC_ADDRESS3: String?
    let MMC_CITY: String?
}

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []

    func fetchContacts() {
        // URL of your API endpoint
        let url = URL(string: "https://your-api-endpoint.com/contacts")! // Replace with actual URL
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    // Decode the JSON response
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.contacts = response.contacts.map {
                            Contact(MMC_ID: $0.MMC_ID,
                                    MMC_SURNAME: $0.MMC_SURNAME,
                                    MMC_FIRSTNAME: $0.MMC_FIRSTNAME,
                                    MMC_TITLE: $0.MMC_TITLE,
                                    MMC_MOBILENO: $0.MMC_MOBILENO,
                                    MMC_EMAIL: $0.MMC_EMAIL,
                                    MMC_ADDRESS3: $0.MMC_ADDRESS3,
                                    MMC_CITY: $0.MMC_CITY)
                        }
                    }
                } catch {
                    print("Error decoding contacts: \(error)")
                }
            }
        }.resume()
    }
}

struct APIResponse: Codable {
    let contacts: [APIContact]
    let success: String
}

struct APIContact: Codable {
    let MMC_ID: String
    let MMC_SURNAME: String
    let MMC_FIRSTNAME: String
    let MMC_TITLE: String
    let MMC_MOBILENO: String
    let MMC_EMAIL: String?
    let MMC_ADDRESS3: String?
    let MMC_CITY: String?
}

struct AllContacts: View {
    @StateObject private var viewModel = ContactsViewModel()
    @State private var isMenuOpen = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.contacts) { contact in
                    VStack(alignment: .leading) {
                        Text("\(contact.MMC_TITLE) \(contact.MMC_FIRSTNAME) \(contact.MMC_SURNAME)")
                            .font(.headline)
                        Text("Phone: \(contact.MMC_MOBILENO)")
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
                }
                .navigationTitle("All Contacts")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation { isMenuOpen.toggle() }
                        }) {
                            Image(systemName: isMenuOpen ? "xmark.circle" : "line.horizontal.3.circle")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            AuthManager.shared.logout() // ✅ Use Global Logout Function
                        }) {
                            Image(systemName: "power.circle")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
                .toolbarBackground(Color(hex: "#3D8DBC"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .animation(.easeInOut, value: isMenuOpen)
                .gesture(
                    DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width < -100 {
                            isMenuOpen = false
                        }
                    }
                )
                .onAppear {
                    viewModel.fetchContacts() // Fetch contacts when the page appears
                }
            }
        }
    }
}

struct AllContacts_Previews: PreviewProvider {
    static var previews: some View {
        AllContacts()
    }
}
