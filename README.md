# MadarSoft-Task

MadarSoftTask is a simple To-Do list application built with Swift, utilizing `CoreData` for offline storage and `Combine` for reactive data binding. The project demonstrates concepts like dependency injection, unit testing with mocked services, and UI integration with `UICollectionView` and custom search functionality.

## Features

- **Add, Delete, and Update Todos**: Users can add new tasks, delete them, and mark them as complete.
- **Search Todos**: Includes a search bar to filter tasks by title.
- **Offline Support**: Uses CoreData to store tasks locally.
- **Network Handling**: Fetches data from a network source and updates offline storage.
- **Reactive UI**: Built using Combine to observe and respond to state changes.
- **Unit Tested**: Core functionalities are tested with XCTest using mocked dependencies.

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.5+

## Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mohamed7420/MadarSoftTask.git
   cd MadarSoftTask
open MadarSoftTask.xcodeproj

Build and Run: Select an iOS Simulator or your device, then build and run the project (Cmd + R).

Project Structure
Model: Todo, TodoEntity
ViewModel: TodoListViewModel - Manages the app's data and business logic.
ViewController: TodoListViewController - Contains UI elements and binds to the ViewModel.
Network Layer: NetworkServiceProtocol, NetworkManager - Handles network calls.
CoreData Layer: Uses NSManagedObjectContext for local data management.
Testing
The project uses XCTest for unit testing. Core functionalities like network data fetching, adding/deleting/updating todos, and filtering are covered.

Run Tests
Open the project in Xcode.
Go to Product > Test or press Cmd + U to run all tests.
Mocking
Mock implementations of NetworkServiceProtocol and SoundManager are used to isolate TodoListViewModel logic in tests. This allows testing the ViewModel without making actual network calls or playing sounds.

Example Usage
Adding a Todo: Press the + button to add a new task.
Marking as Complete: Tap on a task to toggle its completion status.
Deleting a Todo: Swipe left on a task to delete it.
Searching: Use the search bar to filter tasks by title.
Dependencies
Combine: Used for reactive bindings within the ViewModel.
CoreData: For offline persistence of todos.
XCTest: For unit testing.
License
This project is licensed under the MIT License. See the LICENSE file for details.

Developer Instructions
Follow these steps to ensure the README file is complete and accurate for your project.

Clone the Repository and Project Information:

In the Setup section, replace the GitHub link https://github.com/yourusername/MadarSoftTask.git with your actual GitHub repository URL.
Customize the Project Information section with any unique details, such as specific frameworks, patterns, or libraries you used.
Verify Setup Instructions:

Open the project in Xcode and ensure that all dependencies load correctly. If you use CocoaPods or Swift Package Manager (SPM), make sure the setup steps match your specific configuration.
If necessary, include instructions to open the .xcworkspace file instead of .xcodeproj, especially if CocoaPods is in use.
Define Project Structure:

Check that each section mentioned under Project Structure (Model, ViewModel, ViewController, etc.) matches your folder and file organization.
Add any additional components or folders if the structure has more parts, such as Utilities or Resources.
Testing Instructions:

Confirm that the Run Tests steps are accurate by opening the project in Xcode and running Cmd + U.
If there are integration tests or UI tests in addition to unit tests, mention those separately and provide specific instructions.
Provide Example Usage:

Double-check that the steps under Example Usage match your app's interface. If there are extra steps, such as creating an account or navigating to different sections, include them here.
Add screenshots if desired, as they can help clarify the steps visually.
Dependencies:

Verify all dependencies are mentioned. If there are additional dependencies not listed in the initial README (e.g., Alamofire, Kingfisher, etc.), add them under Dependencies.
Licensing:

<img src="https://github.com/user-attachments/assets/02bfe752-0b04-4354-8223-30e83de11d7e" alt="Simulator Screenshot - iPhone 16 Pro" width="40%" />
<img src="https://github.com/user-attachments/assets/d8627926-c599-414b-808e-76fd7670284e" alt="Simulator Screenshot - iPhone 16 Pro" width="40%"/>
<img src="https://github.com/user-attachments/assets/ac358de7-d5fd-4e2f-b992-a3858058b47d" alt="Simulator Screenshot" width="40%"/>



If you’re using MIT License, ensure a LICENSE file exists with the appropriate text. Otherwise, update the License section with details on your specific licensing.
Final Touches:

Test all links (GitHub repository, LICENSE file) to confirm they’re correct.
Proofread for typos or formatting issues to ensure the README is clear and professional.
