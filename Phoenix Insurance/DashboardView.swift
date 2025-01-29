import SwiftUI

struct DashboardView: View {
    @State private var isMenuOpen = false
    @ObservedObject var authManager = AuthManager.shared // Use the Singleton
    @State private var navigationPath = NavigationPath() // ✅ Use NavigationPath for programmatic navigation

    var body: some View {
        if authManager.isUserLoggedIn {
            NavigationStack(path: $navigationPath) { // ✅ Use NavigationStack instead of NavigationView
                ZStack {
                    MainContentView(navigationPath: $navigationPath)
                        .blur(radius: isMenuOpen ? 5 : 0)
                        .disabled(isMenuOpen)
                    
                    if isMenuOpen {
                        SideMenuView(isMenuOpen: $isMenuOpen, navigationPath: $navigationPath)
                            .frame(width: 250)
                            .background(Color.white.shadow(radius: 5))
                            .offset(x: isMenuOpen ? 0 : -250)
                            .transition(.move(edge: .leading))
                            .zIndex(1)
                    }
                }
                .navigationTitle("Dashboard")
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
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .AllContacts:
                        AllContacts()
                    }
                }
            }
            
        } else {
            LoginView()
        }
    }

    struct MainContentView: View {
        @State private var dashboardData: DashboardResponse?
        @State private var isLoading = true
        @State private var errorMessage: String?
        @Binding var navigationPath: NavigationPath // ✅ Receive navigationPath
        
        func formatCurrency(_ value: String?) -> String {
            guard let value = value, let doubleValue = Double(value) else {
                return "Rs. 0.00"
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.locale = Locale(identifier: "en_IN") // For Indian number formatting
            
            if let formattedValue = formatter.string(from: NSNumber(value: doubleValue)) {
                return "Rs. \(formattedValue)"
            } else {
                return "Rs. 0.00"
            }
        }
        
        var body: some View {
            ScrollView {
                if isLoading {
                    ProgressView()
                }
                else if let data = dashboardData {
                    VStack {
                        // Dashboard and Control Panel Section
                        HStack {
                            Text("Dashboard")
                                .font(.custom("Poppins-SemiBold", size: 25))
                                .foregroundColor(.black)
                            Text("Control Panel")
                                .font(.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.gray)
                        }
                        .padding(.leading,15)
                        
                        HStack {
                            VStack {
                                Text(formatCurrency(data.current.NEW_PREMIUM))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                Text("\(data.current.NEW_POL_NO) - New Policies")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 60)
                            .background(Color(hex: "#00C0EF"))
                            
                            VStack(alignment: .leading) {
                                Text(formatCurrency(data.current.RENEWAL_PREMIUM))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                Text("\(data.current.RENEWAL_POL_NO) - Renewal Policies")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 60)
                            .background(Color(hex: "#00A65A")) // Replace with custom background image
                        }
                        
                        HStack {
                            VStack {
                                Text(formatCurrency(data.current.ENDORSEMENT_PREMIUM))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                Text("\(data.current.ENDORSEMENT_POL_NO) - Endorsement Policies")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 60)
                            .background(Color(hex: "#F39C12"))
                            
                            VStack(alignment: .leading) {
                                Text(formatCurrency(data.current.CANCEL_PREMIUM))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                Text("\(data.current.CANCEL_POL_NO) - Cancelled Policies")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 60)
                            .background(Color(hex: "#DD4B39")) // Replace with custom background image
                        }
                        // Target Completion Section
                        VStack(alignment: .leading) {
                            Text("Target Completion")
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(.black)
                                .padding(.bottom, 25)
                            
                             HStack{
                                 VStack(alignment: .leading){
                                     Text("MOTOR (\(data.target.per_mot)%)")
                                         .font(.custom("Poppins-Bold", size: 12))
                                         .foregroundColor(.black)
                                 }
                                 Spacer() // Pushes the next VStack to the right
                                 VStack(alignment: .trailing){
                                     let achievedmotor = (Double(data.target.mc) ?? 0.00) + (Double(data.target.m3) ?? 0.00)
                                     let stringValue = String(format: "%.2f",achievedmotor)
                                     
                                     Text("\(formatCurrency(stringValue)) / \(formatCurrency(data.target.tr_mot))")
                                         .font(.custom("Poppins-Bold", size: 10))
                                         .foregroundColor(.black)
                                 }
                            }
                            ProgressView(value: Double(data.target.per_mot), total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                             HStack{
                                 VStack(alignment: .leading){
                                     Text("NON MOTOR (\(data.target.per_non)%)")
                                         .font(.custom("Poppins-Bold", size: 12))
                                         .foregroundColor(.black)
                                 }
                                 Spacer() // Pushes the next VStack to the right
                                 VStack(alignment: .trailing){
                                     Text("\(formatCurrency(data.target.mn))/\(formatCurrency(data.target.tr_non))")
                                         .font(.custom("Poppins-Bold", size: 10))
                                         .foregroundColor(.black)
                                 }
                            }
                            
                            ProgressView(value: Double(data.target.per_non), total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                .frame(height: 8)
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text("TOTAL ACH (\(data.target.per_total)%)")
                                        .font(.custom("Poppins-Bold", size: 12))
                                        .foregroundColor(.black)
                                }
                                Spacer() // Pushes the next VStack to the right
                                VStack(alignment: .trailing){
                                    Text("\(formatCurrency(data.target.tot_prem))/\(formatCurrency(data.target.tot_target))")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .foregroundColor(.black)
                                }
                           }
                            
                            ProgressView(value: Double(data.target.per_total), total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                                .frame(height: 8)
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text("TOTAL COMMISSION (Subject to clearance of Debtors / Cancellation)")
                                        .font(.custom("Poppins-Bold", size: 12))
                                        .foregroundColor(.black)
                                }
                                Spacer() // Pushes the next VStack to the right
                                VStack(alignment: .trailing){
                                    Text("Rs. 225,568")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .foregroundColor(.black)
                                }
                           }
                            
                            ProgressView(value: 100, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                .frame(height: 8)
                        }
                        .padding(15)
                    }
                    VStack{
                        // Debtors Section
                        HStack {
                            VStack {
                                Image("alarm_clock_tool") // Replace with custom image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            .frame(width: 60, height: 60)
                            .padding(20)
                            .background(Color(hex: "#44427D"))
                            
                            VStack(alignment: .leading) {
                                Text("Total Debtors as at Date")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                                
                                Text(formatCurrency(data.debtors_summ.DAYS_TOTAL))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                
                                Divider().background(Color.white)
                            }
                            .padding(31)
                            .background(Color(hex: "#555299")) // Replace with custom background image
                        }
                        .padding(.top, 0)
                    }
                    VStack(alignment: .leading, spacing: 25) {
                        // Title
                        Text("Personal Achievements")
                            .font(.custom("poppins_semibold", size: 15))
                            .foregroundColor(.black)
                        
                        // New Business Section
                        VStack(spacing: 15) {
                            Text("New Business (To be achieved)")
                                .font(.custom("poppins_bold", size: 12))
                                .foregroundColor(.red)
                            
                            // Horizontal Stack for Columns
                            HStack(spacing: 10) {
                                
                                let new_business_motor = (Double(data.target.tr_mot) ?? 0.00) - ((Double(data.ren_ach_m.ACH_REN_M) ?? 0.00) + (Double(data.new_ach_m.ACH_NEW_M) ?? 0.00) + (Double(data.m_pros.PREMIUM) ?? 0.00))
                                // Column 1 (Motor)
                                VStack {
                                    Text("Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    let snew_business_motor = String(format: "%.2f", new_business_motor)
                                    Text(formatCurrency(snew_business_motor)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 2 (Non Motor)
                                let ren_business_motor = (Double(data.target.tr_non) ?? 0.00) - ((Double(data.ren_ach_nm.ACH_REN_NM) ?? 0.00) + (Double(data.new_ach_nm.ACH_NEW_NM) ?? 0.00) + (Double(data.n_pros.PREMIUM) ?? 0.00))
                                VStack {
                                    Text("Non Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    let sren_business_motor = String(format: "%.2f",ren_business_motor)
                                    Text(formatCurrency(sren_business_motor)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 3 (Total)
                                VStack {
                                    Text("Total")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    let nbta_total = Double(new_business_motor + ren_business_motor);
                                    let snbta_total = String(format: "%.2f",nbta_total)
                                    Text(formatCurrency(snbta_total)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(10)
                        }
                        .padding(15)
                        .background(Color(hex:"#DFF0D8"))
                        .cornerRadius(10)
                    }
                    .padding(10)
                    VStack(alignment: .leading, spacing: 25) {
                        // New Business Section
                        VStack(spacing: 15) {
                            Text("Current Month Prospective")
                                .font(.custom("poppins_bold", size: 12))
                                .foregroundColor(Color(hex:"#008849"))
                            
                            // Horizontal Stack for Columns
                            HStack(spacing: 10) {
                                // Column 1 (Motor)
                                VStack {
                                    Text("Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.m_pros.PREMIUM)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 2 (Non Motor)
                                VStack {
                                    Text("Non Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.n_pros.PREMIUM)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 3 (Total)
                                VStack {
                                    Text("Total")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    let totalcmp = (Double(data.m_pros.PREMIUM) ?? 0.00) + (Double(data.n_pros.PREMIUM) ?? 0.00)
                                    let stotalcmp = String(format: "%.2f", totalcmp)
                                    Text(formatCurrency(stotalcmp)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(10)
                        }
                        .padding(15)
                        .background(Color(hex:"#D9EDF7"))
                        .cornerRadius(10)
                    }
                    .padding(10)
                    VStack(alignment: .leading, spacing: 25) {
                        // New Business Section
                        VStack(spacing: 15) {
                            Text("Current Month Achieved (New Policies)")
                                .font(.custom("poppins_bold", size: 12))
                                .foregroundColor(Color(hex:"#000000"))
                            
                            // Horizontal Stack for Columns
                            HStack(spacing: 10) {
                                // Column 1 (Motor)
                                VStack {
                                    Text("Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.new_ach_m.ACH_NEW_M)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 2 (Non Motor)
                                VStack {
                                    Text("Non Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.new_ach_nm.ACH_NEW_NM)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 3 (Total)
                                VStack {
                                    Text("Total")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    let totalcma = (Double(data.new_ach_m.ACH_NEW_M) ?? 0.00) + (Double(data.new_ach_nm.ACH_NEW_NM) ?? 0.00)
                                    let stotalcma = String(format: "%.2f", totalcma)
                                    Text(formatCurrency(stotalcma))
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(10)
                        }
                        .padding(15)
                        .background(Color(hex:"#FCF8E3"))
                        .cornerRadius(10)
                    }
                    .padding(10)
                    
                    //===========================================
                    VStack(alignment: .leading, spacing: 25) {
                        // New Business Section
                        VStack(spacing: 15) {
                            Text("Renewal Loss (not renewed polices)")
                                .font(.custom("poppins_bold", size: 12))
                                .foregroundColor(Color(hex:"#000000"))
                            
                            // Horizontal Stack for Columns
                            HStack(spacing: 10) {
                                // Column 1 (Motor)
                                VStack {
                                    Text("Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.ren_m.REN_PREM)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 2 (Non Motor)
                                //let renPrem = data.ren_nm?.REN_PREM ?? 0.00
                                VStack {
                                    Text("Non Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    Text("Rs. 0") // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 3 (Total)
                                //let totalrna = (Double(data.ren_m.REN_PREM) ?? 0.00) + (Double(data.ren_nm?.REN_PREM) ?? 0.00)
                                //let stotalrna = String(format: "%.2f", totalrna)
                                VStack {
                                    Text("Total")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    Text(formatCurrency(data.ren_m.REN_PREM))
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(10)
                        }
                        .padding(15)
                        .background(Color(hex:"#F2DEDE"))
                        .cornerRadius(10)
                    }
                    .padding(10)
                    VStack(alignment: .leading, spacing: 25) {
                        // New Business Section
                        VStack(spacing: 15) {
                            Text("Renewal Achieved (Renewed Policies)")
                                .font(.custom("poppins_bold", size: 12))
                                .foregroundColor(Color(hex:"#000000"))
                            
                            // Horizontal Stack for Columns
                            HStack(spacing: 10) {
                                // Column 1 (Motor)
                                VStack {
                                    Text("Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.ren_ach_m.ACH_REN_M)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 2 (Non Motor)
                                VStack {
                                    Text("Non Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.ren_ach_nm.ACH_REN_NM)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 3 (Total)
                                VStack {
                                    Text("Total")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    let totalra = (Double(data.ren_ach_m.ACH_REN_M) ?? 0.00) + (Double(data.ren_ach_nm.ACH_REN_NM) ?? 0.00)
                                    let stotalra = String(format: "%.2f", totalra)
                                    Text(formatCurrency(stotalra))
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(10)
                        }
                        .padding(15)
                        .background(Color(hex:"#D9EDF7"))
                        .cornerRadius(10)
                    }
                    .padding(10)
                    VStack(alignment: .leading, spacing: 25) {
                        // New Business Section
                        VStack(spacing: 15) {
                            Text("Current Month Target")
                                .font(.custom("poppins_bold", size: 12))
                                .foregroundColor(Color(hex:"#009752"))
                            
                            // Horizontal Stack for Columns
                            HStack(spacing: 10) {
                                // Column 1 (Motor)
                                VStack {
                                    Text("Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.target.tr_mot)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 2 (Non Motor)
                                VStack {
                                    Text("Non Motor")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.target.tr_non)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Column 3 (Total)
                                VStack {
                                    Text("Total")
                                        .font(.custom("Poppins-Bold", size: 10))
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formatCurrency(data.target.tot_target)) // This will be dynamic
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(10)
                        }
                        .padding(15)
                        .background(Color(hex:"#F5F5F5"))
                        .cornerRadius(10)
                    }
                    .padding(10)
                    
                    //Class Wise Achievement
                    VStack(alignment: .leading) {
                        // Class Wise Achievement
                        Text("Class wise Achievement")
                            .font(.custom("Poppins-Semibold", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 5)
                        
                        // First item with image and text
                        HStack {
                            VStack {
                                Image("car") // Replace with actual image asset
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                            }
                            .frame(width: 50, height: 70)
                            
                            VStack(alignment: .leading) {
                                Text("Motor Comprehensive")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.black)
                                Text(formatCurrency(data.target.mc))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.black)
                            }
                            .frame(height: 70)
                            .padding(10)
                        }
                        .frame(width:UIScreen.main.bounds.width - 80)
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder().foregroundColor(Color(hex:"#FEB602")))
                        .padding(.top, 10)
                        
                        // Second item with image and text
                        HStack {
                            VStack {
                                Image("motorbike") // Replace with actual image asset
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                            }
                            .frame(width: 50, height: 70)
                            
                            VStack(alignment: .leading) {
                                Text("Motor Third Party")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.black)
                                Text(formatCurrency(data.target.m3))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.black)
                            }
                            .frame(height: 70)
                            .padding(10)
                        }
                        .frame(width:UIScreen.main.bounds.width - 80)
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder().foregroundColor(Color(hex:"#FEB602")))
                        .padding(.top, 10)
                        
                        // Third item with image and text
                        HStack {
                            VStack {
                                Image("teamwork") // Replace with actual image asset
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                            }
                            .frame(width: 50, height: 70)
                            
                            VStack(alignment: .leading) {
                                Text("Non Motor")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.black)
                                Text(formatCurrency(data.target.mn))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.black)
                            }
                            .frame(height: 70)
                            .padding(10)
                        }
                        .frame(width:UIScreen.main.bounds.width - 80)
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder().foregroundColor(Color(hex:"#FEB602")))
                        .padding(.top, 10)
                        
                        // Fourth item with image and text
                        HStack {
                            VStack {
                                Image("trolley") // Replace with actual image asset
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                            }
                            .frame(width: 50, height: 70)
                            
                            VStack(alignment: .leading) {
                                Text("Total Premium")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.black)
                                Text(formatCurrency(data.target.tot_prem))
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.black)
                            }
                            .frame(height: 70)
                            .padding(10)
                        }
                        .frame(width:UIScreen.main.bounds.width - 80)
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder().foregroundColor(Color(hex:"#FEB602")))
                        .padding(.top, 10)
                    }
                    .padding()
                    
                    VStack(alignment:.leading){
                        // Monthly Performer Summary
                        Text("Monthly Performer Summary")
                            .font(.custom("Poppins-Semibold", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 5)
                        HStack {
                            VStack {
                                Image("price_tag") // Replace with custom image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            .frame(width: 60, height: 60)
                            .padding(20)
                            .background(Color(hex: "#C87F0D"))
                            
                            VStack(alignment: .leading) {
                                Text("Call Register - Daily target is 15 contacts")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                                Text(data.cdr.DAILY_CALL)
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                
                                Divider()
                                    .background(Color.white)
                                    .frame(height: 3)
                                
                                Text("\(data.cdr.DAILY_CALL) - Contacts for this month")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                            .padding(15)
                            .background(Color(hex: "#F39C12")) // Replace with custom background image
                        }
                        .padding(.top, 30)
                        HStack {
                            VStack {
                                Image("heart_") // Replace with custom image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            .frame(width: 60, height: 60)
                            .padding(20)
                            .background(Color(hex: "#008849"))
                            
                            VStack(alignment: .leading) {
                                Text("Finalised Quotations")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                                Text(data.fq.FQ)
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                
                                Divider()
                                    .background(Color.white)
                                    .frame(height: 3)
                                
                                Text("\(data.nfq.FQ) - New | \(data.rfq.FQ) - Renewal")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                            .padding(18)
                            .background(Color(hex: "#00A65A")) // Replace with custom background image
                        }
                        .padding(.top, 5)
                        HStack {
                            VStack {
                                Image("download_") // Replace with custom image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            .frame(width: 60, height: 60)
                            .padding(20)
                            .background(Color(hex: "#B63D2D"))
                            
                            VStack(alignment: .leading) {
                                Text("Lapsed Follow Ups")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                                Text(data.lf.LAPSED)
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                
                                Divider()
                                    .background(Color.white)
                                    .frame(height: 3)
                                
                                Text("Current Month")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                            .padding(18)
                            .background(Color(hex: "#DD4B39")) // Replace with custom background image
                        }
                        .padding(.top, 5)
                        HStack {
                            VStack {
                                Image("conversation_") // Replace with custom image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            .frame(width: 60, height: 60)
                            .padding(20)
                            .background(Color(hex: "#009EC6"))
                            
                            VStack(alignment: .leading) {
                                Text("Followups")
                                    .font(.custom("Poppins-Regular", size: 10))
                                    .foregroundColor(.white)
                                Text(data.fd.FD)
                                    .font(.custom("Poppins-Bold", size: 15))
                                    .foregroundColor(.white)
                                
                                Divider()
                                    .background(Color.white)
                                    .frame(height: 3)
                                
                                Text("Current Month")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                            .padding(18)
                            .background(Color(hex: "#00C0EF")) // Replace with custom background image
                        }
                        .padding(.top, 5)
                        
                    }.padding()
                }else if let errorMessage = errorMessage {
                   Text("Error: \(errorMessage)")
               }

            }
            .padding(20)
            .background(Color(hex:"#FFFFFF")) // Replace with actual background color or image
            .onAppear {
                fetchDashboardData()
            }
        }
        private func fetchDashboardData() {
            APIService.shared.fetchDashboardData(brn: UserDefaults.standard.string(forKey: "brn") ?? "", ucode: UserDefaults.standard.string(forKey: "ucode") ?? "") { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.dashboardData = data
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
