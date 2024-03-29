import Foundation
import UserNotifications

var encoder = JSONEncoder()
var decoder = JSONDecoder()

let NotificationContent = UNMutableNotificationContent()

class ToDo: ObservableObject {
    @Published var ToDoList: [SingleToDo]
    var count = 0
    
    init() {
        self.ToDoList = []
    }
    init(data: [SingleToDo]) {
        self.ToDoList = []
        for item in data {
            self.ToDoList.append(SingleToDo(title: item.title, duedate: item.duedate, isChecked: item.isChecked, isFavorite: item.isFavorite ,id: self.count))
            count += 1
        }
    }
    
    func check(id: Int) {
        self.ToDoList[id].isChecked.toggle()
        
        self.dataStore()
    }
    
    func add(data: SingleToDo) {
        self.ToDoList.append(SingleToDo(title: data.title, duedate: data.duedate, isFavorite: data.isFavorite, id: self.count))
        self.count += 1
        
        self.sort()
        
        self.dataStore()
        self.sendNotification(id: self.ToDoList.count - 1)
    }
    
    func edit(id: Int, data: SingleToDo) {
        self.withdrawNotificaion(id: id)
        self.ToDoList[id].title = data.title
        self.ToDoList[id].duedate = data.duedate
        self.ToDoList[id].isChecked = false
        
        self.ToDoList[id].isFavorite = data.isFavorite
        
        self.sort()
        
        self.dataStore()
        self.sendNotification(id: id)
    }
    
    func sendNotification(id: Int) {
        NotificationContent.title = self.ToDoList[id].title
        NotificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1,self.ToDoList[id].duedate.timeIntervalSinceNow), repeats: false)
        let request = UNNotificationRequest(identifier: self.ToDoList[id].title + self.ToDoList[id].duedate.description, content: NotificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func withdrawNotificaion(id: Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.ToDoList[id].title + self.ToDoList[id].duedate.description])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.ToDoList[id].title + self.ToDoList[id].duedate.description])
    }
    
    func delete(id: Int) {
        self.withdrawNotificaion(id: id)
        self.ToDoList[id].deleted = true
        self.sort()
        
        self.dataStore()
    }
    

    func sort() {
        self.ToDoList.sort(by: {(data1, data2) in
            return data1.duedate.timeIntervalSince1970 < data2.duedate.timeIntervalSince1970
        })
    }
    
    func dataStore() {
        let dataStored = try! encoder.encode(self.ToDoList)
        UserDefaults.standard.set(dataStored, forKey: "ToDoListData")
    }
    
}

struct SingleToDo: Identifiable, Codable {
    var title: String = ""
    var duedate: Date = Date()
    var isChecked: Bool = false
    
    var isFavorite: Bool = false
    
    var deleted = false
    
    var id: Int = 0
}

