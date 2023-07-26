import SwiftUI
import Firebase
import FirebaseCore
import LeanCloud

@main
struct itineraryApp: App {

   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
                RootView()
            //MapRootView()
            //RootScreen()
          
        }
    }
}

class AppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        do {
            try LCApplication.default.set(
                id: "nsHkYQ7nw8J8wzdTYQXuMzhE-gzGzoHsz",
                key: "hKIfkXeacGEZ6wYwTzdEWobw",  
                serverURL: "nshkyq7n.lc-cn-n1-shared.com"
            )
        } catch {
            fatalError("\(error)")
        }
        
        LCApplication.logLevel = .debug
        
        let post = LCObject(className: "Post")
        
        try? post.set("words", value: "Hello world!")
        _ = post.save { result in
            switch result {
            case .success :
                break
            case.failure(let error):
                break
            }
        }
        return true
    }
    
    
    
    
}
