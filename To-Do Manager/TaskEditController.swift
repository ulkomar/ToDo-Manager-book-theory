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
    @IBOutlet var taskStatusSwitch: UISwitch!
    
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
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            let destination = segue.destination as! TaskTypeController
            destination.selectedType = taskType
            
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        let title = taskTitle?.text ?? ""
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
        doAfterEdit?(title, type, status)
        navigationController?.popViewController(animated: true)
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
