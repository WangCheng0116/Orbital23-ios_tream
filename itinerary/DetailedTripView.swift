import SwiftUI
import UIKit

struct DetailedTripView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented = false
    @State private var isDocumentSheetPresented = false
    @State private var activityList: [String] = [
        "Activity 1",
        "Activity 2",
        "Activity 3"
    ]
    
    var body: some View {
        VStack {
            Text("Detailed Trip View")
                .font(.title)
            
            Button(action: {
                // Display weather
            }) {
                Text("Display Weather")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: {
                isDocumentSheetPresented = true
            }) {
                Label("Documents", systemImage: "doc.fill")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isDocumentSheetPresented) {
                DocumentSheet(selectedImages: $selectedImages)
            }
            
            List {
                ForEach(activityList, id: \.self) { activity in
                    Text(activity)
                }
            }
            
            Spacer()
        }
    }
}

struct DocumentSheet: View {
    @Binding var selectedImages: [UIImage]
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack {
            Text("Documents")
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 10) {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                isImagePickerPresented = true
            }) {
                Label("Add Image", systemImage: "plus")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(sourceType: .photoLibrary, onImagePicked: { image in
                    selectedImages.append(image)
                }, onCaptureCancelled: {
                    isImagePickerPresented = false
                })
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage) -> Void
    var onCaptureCancelled: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update needed
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ imagePicker: ImagePicker) {
            self.parent = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                parent.onImagePicked(pickedImage)
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCaptureCancelled?()
            picker.dismiss(animated: true)
        }
    }
}

struct DetailedTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTripView()
    }
}
