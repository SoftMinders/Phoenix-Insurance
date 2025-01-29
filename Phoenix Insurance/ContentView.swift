//
//  ContentView.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 25/01/25.
//

import SwiftUI


struct ContentView: View {
    @State private var showSplash = true
    @State private var isUserLoggedIn = false
    var body: some View {
        // Check the state and show either the splash screen or the login screen
        ZStack {
            if showSplash {
                SplashScreenView()
            } else {
                NavigationView {
                    if isUserLoggedIn {
                        DashboardView() // Redirect to Dashboard
                    } else {
                        LoginView() // Redirect to Login
                    }
                }
            }
        }
        .onAppear {
            // After 2 seconds, switch from splash to login screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.showSplash = false
                    checkLoginStatus()
                }
            }
        }
    }
    private func checkLoginStatus() {
        isUserLoggedIn = checkIfUserIsLoggedIn()
    }
    
}
func checkIfUserIsLoggedIn() -> Bool {
    let defaults = UserDefaults.standard
    return defaults.bool(forKey: "isLoggedIn") // Check login status
}
struct SplashScreenView: View {
    var body: some View {
        
        ZStack {
            Image("background") // Replace with your image name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 200,height: 20)
                    .clipped()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordSecure = true
    @State private var isLoading = false
    @State private var loginErrorMessage = ""
    @State private var isLoggedIn: Bool = false // Track login state
    var body: some View {
        if isLoggedIn {
            DashboardView() // Redirect to Dashboard if logged in
        } else {
            VStack {
                ZStack {
                    // Background Image
                    Image("login_back") // Replace with your image name
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)  // Ensures the image covers the entire screen
                    
                    // Login Form
                    VStack {
                        Image("logo_black")
                            .resizable()
                            .padding(.all,10)
                            .frame(width: 200,height: 38)
                            .clipped()
                            .edgesIgnoringSafeArea(.all)
                        
                        Text("Login")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("Login to Continue Using The App")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        
                        
                        Spacer() // Adds space at the top of the screen
                        
                        // Username TextField
                        VStack{
                            HStack {
                                Image(systemName: "person.fill") // System icon for user
                                    .foregroundColor(.gray)
                                    .padding(.leading,10)
                                TextField("Username", text: $username)
                                    .padding()
                                    .foregroundColor(.black)
                                    .font(.body)
                                    .autocapitalization(.none)
                            }
                            .padding(.horizontal, 20)
                            .background(Color.white.opacity(0.8)) // Background for the whole HStack
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.blue, lineWidth: 2) // Border for TextField
                            )
                        }.padding(.horizontal,50)
                            .padding(.vertical,30)
                        
                        // Password SecureField with Drawable Icon
                        VStack{
                            HStack {
                                Image(systemName: "lock.fill") // System icon for password
                                    .foregroundColor(.gray)
                                if isPasswordSecure {
                                    SecureField("Password", text: $password)
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.body)
                                } else {
                                    TextField("Password", text: $password) // Show plain text when not secure
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.body)
                                }
                                Button(action: {
                                    self.isPasswordSecure.toggle()
                                }) {
                                    Image(systemName: isPasswordSecure ? "eye" : "eye.slash") // System icon for password
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .padding(.horizontal, 20)
                            .background(Color.white.opacity(0.8)) // Background for the whole HStack
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.blue, lineWidth: 2) // Border for TextField
                            )
                        }.padding(.horizontal,50)
                        
                        VStack{
                            // Login Button
                            Button(action: {
                                login()
                            }) {
                                if isLoading {
                                    ProgressView() // Show loading indicator
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .foregroundColor(.white)
                                } else {
                                    Text("Login")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color(hex: "#007AFF"), Color(hex: "#6A5ACD")]), startPoint: .top, endPoint: .bottom)
                                        )
                                        .cornerRadius(50)
                                }
                            }
                            if !loginErrorMessage.isEmpty {
                                Text(loginErrorMessage) // Display error message if any
                                    .foregroundColor(.red)
                                    .padding(.top, 10)
                            }
                        }.padding(.horizontal,50)
                            .padding(.vertical,30)
                        
                        Spacer() // Adds space at the bottom of the screen
                    }
                    .padding(.top, 50) // Adds some padding at the top of the form
                    
                }
            }
        }
    }
    // Function to handle login
    private func login() {
        // Your login logic here
        //print("Username: \(username), Password: \(password)")
        guard !username.isEmpty, !password.isEmpty else {
            loginErrorMessage = "Please fill in all fields."
            return
        }

        isLoading = true
        loginErrorMessage = ""

        APIService.shared.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.success == 1 {
                        self.loginErrorMessage = "successfully loggedin"
                        saveUserDataToUserDefaults(user: response.user)
                        self.isLoggedIn = true
                        // Save token and navigate to the next screen
                    } else {
                        self.loginErrorMessage = response.message ?? "Unknown error."
                    }
                case .failure(let error):
                    self.loginErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
func saveUserDataToUserDefaults(user: User) {
    let defaults = UserDefaults.standard
    defaults.set(user.ucode, forKey: "ucode")
    defaults.set(user.fname, forKey: "fname")
    defaults.set(user.sname, forKey: "sname")
    defaults.set(user.username, forKey: "username")
    defaults.set(user.brn, forKey: "brn")
    defaults.set(user.email, forKey: "email")
    defaults.set(user.djoined, forKey: "djoined")
    defaults.set(true, forKey: "isLoggedIn") // Save login status
}
func getUserData() -> User? {
    let defaults = UserDefaults.standard
    guard let username = defaults.string(forKey: "username") else { return nil }
    
    let user = User(
        ucode: defaults.string(forKey: "ucode") ?? "",
        fname: defaults.string(forKey: "fname") ?? "",
        sname: defaults.string(forKey: "sname") ?? "",
        username: username,
        brn: defaults.string(forKey: "brn") ?? "",
        type: defaults.string(forKey: "type") ?? "",
        email: defaults.string(forKey: "email") ?? "",
        djoined: defaults.string(forKey: "djoined") ?? ""
    )
    return user
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPhone 12") // Preview on an iPhone 12
    }
}
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .previewDevice("iPhone 12") // Preview on an iPhone 12
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
