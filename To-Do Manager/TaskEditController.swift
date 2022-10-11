//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Uladzislau Komar on 10.10.22.
//

import UIKit

class TaskEditController: UITableViewController {
    
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    private var taskTitles: [TaskPriority: String] = [
        .important: "Important",
        .normal: "Current"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTitle.text = taskText
        taskTypeLabel?.text = taskTitles[taskType]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
}
