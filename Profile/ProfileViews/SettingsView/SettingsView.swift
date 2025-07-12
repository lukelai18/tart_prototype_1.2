import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToAccountSettings = false
    @State private var navigateToPrivacySettings = false
    @State private var navigateToNotificationSettings = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    @StateObject private var loginModel = LoginModel()
    @State private var showLogoutAlert = false
    
    var body: some View {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    
                    Text("Settings")
                        .font(AppFont.subtitle.font)
                        .padding(.leading)
                    
                    Spacer()
                }
                .padding()
                
                // Settings List
                ScrollView {
                    VStack(spacing: 0) {
                        // Account Settings section
                        VStack(spacing: 0) {
                            SettingsRow(
                                title: "Account Settings",
                                action: {
                                    navigateToAccountSettings = true
                                }
                            )
                            
                            SettingsRow(
                                title: "Privacy Settings",
                                action: {
                                    navigateToPrivacySettings = true
                                }
                            )
                            
                            
                            SettingsRow(
                                title: "Notification Settings",
                                action: {
                                    navigateToNotificationSettings = true
                                }
                            )
                                
                            
                        }
                        
                        // Spacer between sections
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 20)
                        
                        // Preferences section
                        VStack(spacing: 0) {
                            SettingsRow(title: "Content Preferences") {
                                // Handle content preferences
                            }
                            
                            SettingsRow(title: "Dark Mode") {
                                // Handle dark mode
                            }
                            
                            SettingsRow(title: "Font Size") {
                                // Handle font size
                            }
                        }
                        
                        // Spacer between sections
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 20)
                        
                        // App section
                        VStack(spacing: 0) {
                            SettingsRow(title: "Rate Our App") {
                                // Handle rate app
                            }
                            
                            SettingsRow(title: "About Tart") {
                                // Handle about
                            }
                        }
                        
                        // Spacer before logout
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                        
                        // Log Out button
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            if loginModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            } else {
                                Text("Log Out")
                                    .font(AppFont.body.font)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .disabled(loginModel.isLoading)
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                
                // Hidden NavigationLink for Account Settings
                NavigationLink(
                    destination: AccountSettingsView(),
                    isActive: $navigateToAccountSettings
                ) {
                    EmptyView()
                }
               
                NavigationLink(
                    destination: PrivacySettingsView(),
                    isActive: $navigateToPrivacySettings
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                                destination: NotificationSettingsView(),
                                isActive: $navigateToNotificationSettings
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                        // Also hide navigation bar when view appears
                        UINavigationBar.appearance().isHidden = false
                    }
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    Task {
                        await loginModel.signOut()
                        isLoggedIn = false
                    }
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }


struct SettingsRow: View {
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    init(title: String, subtitle: String? = nil, action: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFont.body.font)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.05))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
