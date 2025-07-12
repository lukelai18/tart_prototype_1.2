import SwiftUI

struct LoginView: View {
    @StateObject private var loginModel = LoginModel()
    @State private var currentScreen: Screen = .welcome
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    enum Screen {
        case welcome
        case login
        case register
        case verifyEmail
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                switch currentScreen {
                case .welcome:
                    WelcomeView(currentScreen: $currentScreen)
                case .login:
                    SigninView(currentScreen: $currentScreen, loginModel: loginModel)
                case .register:
                    RegisterView(currentScreen: $currentScreen, loginModel: loginModel)
                case .verifyEmail:
                    VerifyEmailView(currentScreen: $currentScreen, loginModel: loginModel)
                }
            }
        }
        .onChange(of: loginModel.isAuthenticated) { authenticated in
            if authenticated {
                isLoggedIn = true
            }
        }
    }
}

struct WelcomeView: View {
    @Binding var currentScreen: LoginView.Screen
    
    var body: some View {
        ZStack {
            // Background Image
            Image("nightSky")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Header Text
                HStack {
                    Text("Welcome to")
                        .font(AppFont.largeTitle.font)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.leading, 24)
                
                HStack {
                    Spacer()
                    
                    Text("Tart")
                        .font(AppFont.largeTitle.font)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 24)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        currentScreen = .login
                    }) {
                        Text("Login")
                            .font(AppFont.bodyBold.font)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.35, green: 0.35, blue: 0.35))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        currentScreen = .register
                    }) {
                        Text("Register")
                            .font(AppFont.bodyBold.font)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // TODO: 实现游客模式
                    }) {
                        Text("Continue as Guest")
                            .font(AppFont.body.font)
                            .foregroundColor(.white)
                            .underline()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct SigninView: View {
    @Binding var currentScreen: LoginView.Screen
    @ObservedObject var loginModel: LoginModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showError = false
    
    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with forest background
                ZStack(alignment: .leading) {
                    // Forest background image
                    Image("forestGlow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .position(x: UIScreen.main.bounds.width/2, y: 100)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome!")
                            .font(AppFont.title.font)
                            .foregroundColor(.white)
                        
                        Text("Glad to see you...")
                            .font(AppFont.subtitle.font)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 24)
                }
                
                // Login options
                VStack(spacing: 16) {
                    // Social login options
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.signInWithGoogle()
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            
                            Text("Sign in with Google")
                                .font(AppFont.body.font)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(loginModel.isLoading)
                    
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.signInWithApple()
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 24)
                                .foregroundColor(.black)
                            
                            Text("Sign in with Apple")
                                .font(AppFont.body.font)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(loginModel.isLoading)
                    
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.signInWithFacebook()
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "f.square.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            
                            Text("Sign in with Facebook")
                                .font(AppFont.body.font)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(loginModel.isLoading)
                    
                    // Or text
                    Text("Or")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                    
                    // Email field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        
                        TextField("Your email", text: $email)
                            .font(AppFont.body.font)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Password field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                            .font(AppFont.body.font)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Remember me checkbox
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                                
                                if rememberMe {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        
                        Text("Remember me")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    // Sign in button
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.signInWithEmail(email, password: password)
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        if loginModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                                .cornerRadius(12)
                        } else {
                            Text("Sign in")
                                .font(AppFont.bodyBold.font)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                                .cornerRadius(12)
                        }
                    }
                    .disabled(loginModel.isLoading || email.isEmpty || password.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                Spacer()
            }
            
            // App title at the top
            VStack {
                HStack {
                    Text("tart")
                        .font(AppFont.title.font)
                        .padding(.leading, 24)
                        .padding(.top, 12)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                loginModel.clearError()
            }
        } message: {
            Text(loginModel.error ?? "An error occurred")
        }
        .onChange(of: loginModel.error) { error in
            if error != nil {
                showError = true
            }
        }
    }
}

struct VerifyEmailView: View {
    @Binding var currentScreen: LoginView.Screen
    @ObservedObject var loginModel: LoginModel
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var showError = false
    
    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Navigation back button
                HStack {
                    Button(action: {
                        currentScreen = .login
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(.top, 12)
                
                // Title and subtitle
                VStack(alignment: .leading, spacing: 8) {
                    Text("Check your email")
                        .font(AppFont.title.font)
                        .foregroundColor(.black)
                    
                    Text(loginModel.currentUser?.email ?? "")
                        .font(AppFont.body.font)
                        .foregroundColor(Color(red: 0.6, green: 0.7, blue: 0.3))
                    
                    Text("If this email exist, you will receive an email with a\nOne Time Password (OTP).\nType that code below:")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // OTP input fields
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPTextField(text: $otpFields[index],
                                    isFocused: focusedField == index,
                                    onCommit: {
                                        if otpFields[index].count > 0 && index < 5 {
                                            focusedField = index + 1
                                        }
                                    })
                            .focused($focusedField, equals: index)
                    }
                }
                
                // Help text
                VStack(alignment: .leading, spacing: 12) {
                    BulletPoint(text: "Emails can take up to 5 minutes to arrive")
                    
                    HStack(spacing: 4) {
                        BulletPoint(text: "If you did not receive an email, click")
                        
                        Button(action: {
                            // Action to request another OTP
                        }) {
                            Text("here")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.blue)
                        }
                        
                        Text("to")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray)
                    }
                    
                    Text("request another OTP")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                    
                    HStack(spacing: 4) {
                        Text("If you need help, please visit our")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            // Action to go to support page
                        }) {
                            Text("support")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.blue)
                        }
                        
                        Text("page.")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 16)
                
                Spacer()
                
                // Sign in button
                Button(action: {
                    Task {
                        do {
                            let otp = otpFields.joined()
                            let username = loginModel.currentUser?.username ?? ""
                            try await loginModel.verifyOTP(username, otp: otp)
                        } catch {
                            showError = true
                        }
                    }
                }) {
                    if loginModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                            .cornerRadius(12)
                    } else {
                        Text("Verify Email")
                            .font(AppFont.bodyBold.font)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                            .cornerRadius(12)
                    }
                }
                .disabled(loginModel.isLoading || otpFields.joined().count != 6)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                loginModel.clearError()
            }
        } message: {
            Text(loginModel.error ?? "An error occurred")
        }
        .onChange(of: loginModel.error) { error in
            if error != nil {
                showError = true
            }
        }
    }
}

struct OTPTextField: View {
    @Binding var text: String
    var isFocused: Bool
    var onCommit: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1)
                .background(Color.white)
                .frame(width: 48, height: 48)
            
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(AppFont.subtitle.font)
                .onChange(of: text) { newValue in
                    if newValue.count > 1 {
                        text = String(newValue.suffix(1))
                    }
                    
                    if newValue.count == 1 {
                        onCommit()
                    }
                }
        }
    }
}

struct BulletPoint: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(AppFont.subheadline.font)
                .foregroundColor(.gray)
            
            Text(text)
                .font(AppFont.subheadline.font)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct RegisterView: View {
    @Binding var currentScreen: LoginView.Screen
    @ObservedObject var loginModel: LoginModel
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError = false
    
    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with forest background
                ZStack(alignment: .leading) {
                    // Forest background image
                    Image("forestGlow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .position(x: UIScreen.main.bounds.width/2, y: 100)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Join Tart!")
                            .font(AppFont.title.font)
                            .foregroundColor(.white)
                        
                        Text("Create your artistic journey...")
                            .font(AppFont.subtitle.font)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 24)
                }
                
                // Registration options
                VStack(spacing: 16) {
                    // Social registration options
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.registerWithGoogle()
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            
                            Text("Register with Google")
                                .font(AppFont.body.font)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(loginModel.isLoading)
                    
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.registerWithApple()
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 24)
                                .foregroundColor(.black)
                            
                            Text("Register with Apple")
                                .font(AppFont.body.font)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(loginModel.isLoading)
                    
                    // Or text
                    Text("Or")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                    
                    // Username field
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                        
                        TextField("Username", text: $username)
                            .font(AppFont.body.font)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Email field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        
                        TextField("Your email", text: $email)
                            .font(AppFont.body.font)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Password field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                            .font(AppFont.body.font)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Terms and privacy notice
                    Text("By registering, you agree to our Terms of Service and Privacy Policy")
                        .font(AppFont.caption.font)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 8)
                    
                    // Register button
                    Button(action: {
                        Task {
                            do {
                                try await loginModel.registerWithEmail(email, username: username, password: password)
                                if loginModel.needsEmailVerification {
                                    currentScreen = .verifyEmail
                                }
                            } catch {
                                showError = true
                            }
                        }
                    }) {
                        if loginModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                                .cornerRadius(12)
                        } else {
                            Text("Create Account")
                                .font(AppFont.bodyBold.font)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                                .cornerRadius(12)
                        }
                    }
                    .disabled(loginModel.isLoading || email.isEmpty || username.isEmpty || password.isEmpty)
                    
                    // Login link
                    Button(action: {
                        currentScreen = .login
                    }) {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.gray)
                            
                            Text("Sign in")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                Spacer()
            }
            
            // App title at the top
            VStack {
                HStack {
                    Button(action: {
                        currentScreen = .welcome
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    Text("tart")
                        .font(AppFont.title.font)
                        .padding(.trailing, 24)
                        .padding(.top, 12)
                }
                
                Spacer()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                loginModel.clearError()
            }
        } message: {
            Text(loginModel.error ?? "An error occurred")
        }
        .onChange(of: loginModel.error) { error in
            if error != nil {
                showError = true
            }
        }
    }
}

#Preview("Welcome") {
    WelcomeView(currentScreen: .constant(.welcome))
}

#Preview("Login") {
    SigninView(currentScreen: .constant(.login), loginModel: LoginModel())
}

#Preview("Register") {
    RegisterView(currentScreen: .constant(.register), loginModel: LoginModel())
}

#Preview("Verify Email") {
    VerifyEmailView(currentScreen: .constant(.verifyEmail), loginModel: LoginModel())
}

#Preview("Main LoginView") {
    LoginView()
}

