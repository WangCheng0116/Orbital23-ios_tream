import SwiftUI

class TripManager: ObservableObject {
    @Published var trips: [SingleTrip] = []
    
    init() {
        loadTrips()
    }
    
    func saveTrips() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(trips) {
            UserDefaults.standard.set(encodedData, forKey: "trips")
        }
    }
    
    func loadTrips() {
        if let encodedData = UserDefaults.standard.data(forKey: "trips") {
            let decoder = JSONDecoder()
            if let decodedTrips = try? decoder.decode([SingleTrip].self, from: encodedData) {
                trips = decodedTrips
            }
        }
    }
}


struct CreateTripView: View {
    @EnvironmentObject var tripManager: TripManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var destination: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var budget: Double = 0.0
    @State private var showAlert = false
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trip Details")) {
                    TextField("Title", text: $title)
                    TextField("Destination", text: $destination)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Start Date", selection: $startDate, in: Date()...)
                    DatePicker("End Date", selection: $endDate, in: startDate...)
                }
                
                Section(header: Text("Image")) {
                                    Button(action: {
                                        isShowingImagePicker = true
                                    }) {
                                        VStack {
                                            if let image = selectedImage {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: 200)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                              
                                                    .frame(width: 60, height: 60)
                                            }
                                        }
                                    }
                                    .sheet(isPresented: $isShowingImagePicker) {
                                        ImagePicker(selectedImage: $selectedImage)
                                    }
                                }
                
                Section(header: Text("Budget")) {
                    TextField("Budget", value: $budget, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("Create Trip")
            .navigationBarItems(trailing:
                Button(action: {
                    if validateInput() {
                        let newTrip = SingleTrip(title: title,
                                                 destination: destination,
                                                 description: description,
                                                 imageName: "",
                                                 startDate: startDate,
                                                 endDate: endDate,
                                                 budget: budget,
                        image: selectedImage)
                        
                        tripManager.trips.append(newTrip)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Save")
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"),
                      message: Text("Please fill in all the fields with valid data."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func validateInput() -> Bool {
        if title.isEmpty || destination.isEmpty || description.isEmpty || budget <= 0 {
            return false
        }
        
        return true
    }
}

struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Environment(\.presentationMode) private var presentationMode
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let selectedImage = info[.originalImage] as? UIImage {
                    parent.selectedImage = selectedImage
                }
                
                parent.presentationMode.wrappedValue.dismiss()
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
