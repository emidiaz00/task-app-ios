import SwiftUI

class Task: Identifiable {
    var id = UUID()
    var title: String
    var completed = false
    
    init(title: String) {
        self.title = title
    }
}

class TaskManager: ObservableObject {
    @Published var tasks = [Task]()
    
    func addTask(title: String) {
        let newTask = Task(title: title)
        tasks.append(newTask)
    }
    
    func editTask(task: Task, newTitle: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = newTitle
        }
    }
    
    func deleteTask(task: Task) {
        tasks.removeAll(where: { $0.id == task.id })
    }
}

struct TaskListView: View {
    @ObservedObject var taskManager = TaskManager()
    @State private var isEditing = false
    @State private var editedTask: Task?
    @State private var newTitle = ""
    @State private var showActionSheet : Bool = false
    
    
    var action: ActionSheet {
        ActionSheet(title: Text("Desear eliminar la tarea?"), message:
                        Text("Selecciona una opcion"), buttons: [
                            .default(Text("Si")),
                            .default(Text("No"))
                        ]
        )
    }
    var body: some View {
        VStack {
            List {
                ForEach(taskManager.tasks) { task in
                    if isEditing && task.id == editedTask?.id {
                        TextField("Enter new title", text: $newTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                if !newTitle.isEmpty {
                                    taskManager.editTask(task: task, newTitle: newTitle)
                                    editedTask = nil
                                    newTitle = ""
                                    isEditing = false
                                }
                            }
                    } else {
                        HStack {
                            Text(task.title)
                            Spacer()
                            Button(action: {
                                isEditing = true
                                editedTask = task
                                newTitle = task.title
                            }) {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                    HStack {
                        Button(action: {
                            self.showActionSheet.toggle()
                            taskManager.deleteTask(task: task)
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                    .actionSheet(isPresented: self.$showActionSheet) { () ->
                        ActionSheet in self.action
                    }
                }
            }
            Button(action: {
                taskManager.addTask(title: "New Task")
            }) {
                Text("Add Task")
            }
        }
        .padding()
    }
}
