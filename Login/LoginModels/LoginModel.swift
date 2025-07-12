import Foundation
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

class LoginModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: LoginUser?
    @Published var isLoading = false
    @Published var error: String?
    @Published var needsEmailVerification = false
    
    // MARK: - Development Configuration
    static let isDevelopmentMode = true // 设为false使用真实API
    
    private let authService = AuthService.shared
    
    // MARK: - Authentication Methods
    
    // MARK: - Registration Methods
    
    func registerWithGoogle() async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                await MainActor.run {
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: "Google User",
                        username: "googleuser\(Int.random(in: 1000...9999))",
                        email: "user@gmail.com",
                        bio: "Registered with Google",
                        phoneNumber: "",
                        connections: 0
                    )
                    self.isAuthenticated = true
                }
            } else {
                // 真实API模式
                try await authService.socialRegister(provider: "google")
                if let user = authService.currentUser {
                    await MainActor.run {
                        self.currentUser = user.toLoginUser()
                        self.isAuthenticated = authService.isAuthenticated
                    }
                }
            }
        } catch let error as LoginAuthError {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        } catch {
            await MainActor.run {
                self.error = LoginAuthError.unknown.localizedDescription
            }
            throw LoginAuthError.unknown
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func registerWithApple() async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                await MainActor.run {
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: "Apple User",
                        username: "appleuser\(Int.random(in: 1000...9999))",
                        email: "user@icloud.com",
                        bio: "Registered with Apple",
                        phoneNumber: "",
                        connections: 0
                    )
                    self.isAuthenticated = true
                }
            } else {
                // 真实API模式
                try await authService.socialRegister(provider: "apple")
                if let user = authService.currentUser {
                    await MainActor.run {
                        self.currentUser = user.toLoginUser()
                        self.isAuthenticated = authService.isAuthenticated
                    }
                }
            }
        } catch let error as LoginAuthError {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        } catch {
            await MainActor.run {
                self.error = LoginAuthError.unknown.localizedDescription
            }
            throw LoginAuthError.unknown
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func registerWithEmail(_ email: String, username: String, password: String) async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
            self.needsEmailVerification = false
        }
        
        do {
            let options = AuthSignUpRequest.Options(userAttributes: [.init(.email, value: email)])
            let result = try await Amplify.Auth.signUp(username: username, password: password, options: options)
            
            await MainActor.run {
                switch result.nextStep {
                case .done:
                    self.isAuthenticated = true
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: username,
                        username: username,
                        email: email,
                        bio: "New user",
                        phoneNumber: "",
                        connections: 0
                    )
                case .confirmUser(let details, _, _):
                    self.needsEmailVerification = true
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: username,
                        username: username,
                        email: email,
                        bio: "New user",
                        phoneNumber: "",
                        connections: 0
                    )
                default:
                    self.error = "注册流程异常"
                }
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    // MARK: - Login Methods
    
    func signInWithEmail(_ username: String, password: String) async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
            self.needsEmailVerification = false
        }
        
        do {
            let result = try await Amplify.Auth.signIn(username: username, password: password)
            
            if result.isSignedIn {
                await MainActor.run {
                    self.isAuthenticated = true
                }
                // fetchCurrentUser is async, so we can call it directly here
                await fetchCurrentUser()
            } else {
                await MainActor.run {
                    self.error = "登录需要进一步验证"
                }
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func signInWithGoogle() async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                await MainActor.run {
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: "Google User",
                        username: "googleuser",
                        email: "google@example.com",
                        bio: "This is a Google user",
                        phoneNumber: "+1234567890",
                        connections: 0
                    )
                    self.isAuthenticated = true
                }
            } else {
                // TODO: 实现真实的 Google 登录逻辑
                throw LoginAuthError.unknown
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func signInWithApple() async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                await MainActor.run {
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: "Apple User",
                        username: "appleuser",
                        email: "apple@example.com",
                        bio: "This is an Apple user",
                        phoneNumber: "+1234567890",
                        connections: 0
                    )
                    self.isAuthenticated = true
                }
            } else {
                // TODO: 实现真实的 Apple 登录逻辑
                throw LoginAuthError.unknown
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func signInWithFacebook() async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                await MainActor.run {
                    self.currentUser = LoginUser(
                        id: UUID().uuidString,
                        name: "Facebook User",
                        username: "facebookuser",
                        email: "facebook@example.com",
                        bio: "This is a Facebook user",
                        phoneNumber: "+1234567890",
                        connections: 0
                    )
                    self.isAuthenticated = true
                }
            } else {
                // TODO: 实现真实的 Facebook 登录逻辑
                throw LoginAuthError.unknown
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func verifyOTP(_ username: String, otp: String) async throws {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            let result = try await Amplify.Auth.confirmSignUp(for: username, confirmationCode: otp)
            
            await MainActor.run {
                switch result.nextStep {
                case .done:
                    self.isAuthenticated = true
                    self.needsEmailVerification = false
                    // 验证成功后自动登录
                    Task {
                        try await self.autoSignInAfterVerification(username: username)
                    }
                case .confirmUser(let details, _, _):
                    self.error = "验证未完成: \(String(describing: details))"
                default:
                    self.error = "验证流程异常"
                }
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    // MARK: - Helper Methods
    
    private func autoSignInAfterVerification(username: String) async throws {
        // 邮箱验证成功后自动登录
        do {
            let result = try await Amplify.Auth.signIn(username: username, password: "")
            await MainActor.run {
                if result.isSignedIn {
                    self.isAuthenticated = true
                    Task { await self.fetchCurrentUser() }
                }
            }
        } catch {
            await MainActor.run {
                self.error = "自动登录失败: \(error.localizedDescription)"
            }
        }
    }
    
    private func fetchCurrentUser() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            await MainActor.run {
                self.currentUser = LoginUser(
                    id: user.userId,
                    name: user.username,
                    username: user.username,
                    email: user.username, // 可能需要从属性中获取
                    bio: "User",
                    phoneNumber: "",
                    connections: 0
                )
            }
        } catch {
            await MainActor.run {
                self.error = "获取用户信息失败: \(error.localizedDescription)"
            }
        }
    }
    
    func signOut() async {
        await MainActor.run { 
            self.isLoading = true 
            self.error = nil 
        }
        
        do {
            _ = try await Amplify.Auth.signOut()
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
                self.needsEmailVerification = false
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
        }
        
        await MainActor.run { self.isLoading = false }
    }
    
    func clearError() {
        error = nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
} 