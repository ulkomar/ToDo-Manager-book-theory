//
//  TaskListController.swift
//  To-Do Manager
//
//  Created by Uladzislau Komar on 1.10.22.
//

import UIKit

class TaskListController: UITableViewController {

    var tasksStorage: TasksStorageProtocol = TasksStorage()
    var tasks: [TaskPriority: [TaskProtocol]] = [:]
    var sectionsTypePosition: [TaskPriority] = [.important, .normal]
    var taskStatusPosition: [TaskStatus] = [.planned, .completed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionsTypePosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        return currentTasksType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return getConfiguredTaskCell_constraints(for: indexPath)
        return getConfiguredTaskCell_stack(for: indexPath)
    }
    
    //using constraints
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        let taskType = sectionsTypePosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        textLabel?.text = currentTask.title
        
        if currentTask.status == .planned {
            symbolLabel?.textColor = .black
            textLabel?.textColor = .black
        } else {
            symbolLabel?.textColor = .lightGray
            textLabel?.textColor = .lightGray
        }
        
        return cell
    }
    
    //using stack
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        let taskType = sectionsTypePosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        cell.title.text = currentTask.title
        
        if currentTask.status == .planned {
            cell.symbol.textColor = .black
            cell.title.textColor = .black
        } else {
            cell.symbol.textColor = .lightGray
            cell.title.textColor = .lightGray
        }
        
        return cell
    }
    
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSympol: String
        if status == .planned {
            resultSympol = "\u{25CB}"
        } else if status == .completed {
            resultSympol = "\u{25C9}"
        } else {
            resultSympol = ""
        }
        
        return resultSympol
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let taskType = sectionsTypePosition[section]
        if taskType == .important {
            title = "Important tasks"
        } else if taskType == .normal {
            title = "Current tasks"
        }
        
        return title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskType = sectionsTypePosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        
        guard tasks[taskType]![indexPath.row].status == .planned else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        tasks[taskType]![indexPath.row].status = .completed
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskType = sectionsTypePosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        
        guard tasks[taskType]![indexPath.row].status == .completed else {
            return nil
        }
        
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { [self] _, _, _ in
            tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionsTypePosition[indexPath.section]
        tasks[taskType]?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let typeTaskFrom = sectionsTypePosition[sourceIndexPath.section]
        let typeTaskTo = sectionsTypePosition[destinationIndexPath.section]
        
        guard let movedTask = tasks[typeTaskFrom]?[sourceIndexPath.row] else {
            return
        }
        tasks[typeTaskFrom]?.remove(at: sourceIndexPath.row)
        tasks[typeTaskTo]?.insert(movedTask, at: destinationIndexPath.row)
        
        if typeTaskFrom != typeTaskTo {
            tasks[typeTaskTo]?[destinationIndexPath.row].type = typeTaskTo
        }
        
        tableView.reloadData()
        
    }
    
    private func loadTasks() {
        sectionsTypePosition.forEach { taskType in
            tasks[taskType] = []
            tasksStorage.loadTasks().forEach { task in
                tasks[task.type]?.append(task)
            }
        }
        
        for (tasksGroupPriority, tasksGroup) in tasks {
            tasks[tasksGroupPriority] = tasksGroup.sorted {task1, task2 in
                let task1position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                let task2position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                return task1position < task2position
            }
        }
    }

}
