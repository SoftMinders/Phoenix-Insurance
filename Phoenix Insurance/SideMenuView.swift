//
//  SideMenuView.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 29/01/25.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case AllContacts
    case NewBusiness
    case IndividualRen
    case RenewalFollowups
    case RenewalList
    case Finalbusiness
}

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @State private var isBooksMenuOpen = false
    @State private var isReportsMenuOpen = false
    @Binding var navigationPath: NavigationPath // ✅ Receive navigationPath

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Profile Section
                HStack(spacing: 15) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text("Welcome, User")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                .padding(.leading, 20)
                
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal, 20)
                
                // Menu Options
                VStack(alignment: .leading, spacing: 20) {
                    MenuButton(icon: "house.fill", title: "Dashboard") {
                        isMenuOpen = false
                    }
                    
                    NavigationLink(destination: AllContactsView()) {
                        MenuButton(icon: "person.crop.circle.fill.badge.checkmark", title: "Contacts"){
                            isMenuOpen = false
                            navigationPath.append(NavigationDestination.AllContacts)
                        }
                    }
                    
                    NavigationLink(destination: NewBusinessFollowup()){
                        MenuButton(icon: "chart.line.uptrend.xyaxis", title: "New Business Follow Up") {
                            isMenuOpen = false
                            navigationPath.append(NavigationDestination.NewBusiness)
                        }
                    }
                    NavigationLink(destination: IndividualRenewal()){
                        MenuButton(icon: "arrow.3.trianglepath", title: "Individual Renewal") {
                            isMenuOpen = false
                            navigationPath.append(NavigationDestination.IndividualRen)
                        }
                    }
                    NavigationLink(destination: IndividualRenewal()){
                        MenuButton(icon: "list.bullet.clipboard", title: "Renewal List") {
                            isMenuOpen = false
                            navigationPath.append(NavigationDestination.RenewalList)
                        }
                    }
                    NavigationLink(destination: RenewalBusinessFollowup()){
                        MenuButton(icon: "arrow.up.and.person.rectangle.portrait", title: "Renewal Business Follow Up") {
                            isMenuOpen = false
                            navigationPath.append(NavigationDestination.RenewalFollowups)
                        }
                    }
                    NavigationLink(destination: FinalizedBusinessList()){
                        MenuButton(icon: "chart.pie.fill", title: "Finalized Business") {
                            isMenuOpen = false
                            navigationPath.append(NavigationDestination.Finalbusiness)
                        }
                    }
                    MenuButton(icon: "square.and.arrow.up.on.square", title: "View Underwriting Docs") {
                        isMenuOpen = false
                    }
                    
                    // Books Dropdown
                    DisclosureGroup(
                        isExpanded: $isBooksMenuOpen,
                        content: {
                            VStack(alignment: .leading, spacing: 20) {
                                MenuButton(icon: "phone.badge.plus", title: "Daily Call Register") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "doc.text.magnifyingglass", title: "Business Prospective Register") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "shippingbox", title: "Sales Plan") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "person.crop.circle.badge.checkmark", title: "Referral Register") {
                                    isMenuOpen = false
                                }
                            }
                            .padding(.leading, 20)
                        },
                        label: {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(.white)
                                Text("Books")
                                    .foregroundColor(.white)
                            }
                        }
                    )
                    .padding(.leading, 20)
                    .accentColor(.white)
                    
                    // Reports Dropdown
                    DisclosureGroup(
                        isExpanded: $isReportsMenuOpen,
                        content: {
                            VStack(alignment: .leading, spacing: 20) {
                                MenuButton(icon: "umbrella.percent", title: "View Payment Voucher") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "chart.bar.fill", title: "View Debtors Report") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "mail.and.text.magnifyingglass", title: "Marketing Figures") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "chart.line.downtrend.xyaxis", title: "Renewal Loss") {
                                    isMenuOpen = false
                                }
                                MenuButton(icon: "questionmark.circle.fill", title: "Claims") {
                                    isMenuOpen = false
                                }
                            }
                            .padding(.leading, 20)
                        },
                        label: {
                            HStack {
                                Image(systemName: "filemenu.and.cursorarrow")
                                    .foregroundColor(.white)
                                Text("Reports")
                                    .foregroundColor(.white)
                            }
                        }
                    )
                    .padding(.leading, 20)
                    .accentColor(.white)
                    
                    /*MenuButton(icon: "arrow.uturn.left", title: "Logout"){
                        isMenuOpen = false
                    }*/
                }
                .padding(.leading, 20)
                .padding(.bottom, 30)
                .padding(.trailing, 10)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
            )
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 1)
        }
    }
}

