//
//  ToDoTableViewController.swift
//  To Do List
//
//  Created by Evgeniy Goncharov on 30.09.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    var todos = [ToDo]()
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        todos = [
            ToDo(title: "Купить хлеб", image: UIImage(named: "bread")),
            ToDo(title: "Купить молока", image: UIImage(named: "milk")),
            ToDo(title: "Накормить кота", image: UIImage(named: "cat")),
            ToDo(title: "Сделать домашку", image: UIImage(named: "post")),
            ToDo(title: "Сходить на почту", image: UIImage(named: "homework"))
        ]
    }
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        let todo = todos[indexPath.row]
        configure(cell, with: todo)
        return cell
    }
    
    //MARK: - Cell Content
    func configure(_ cell: ToDoCell, with todo: ToDo ) {
        // Check StackView
        guard let stackView = cell.stackView else { return }
        // Check element isEmpty
//        guard stackView.arrangedSubviews.count == 0 else { return }
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for index in 0 ..< todo.keys.count {
            let key = todo.capitilisedKeys[index]
            let value = todo.values[index]
            
            if let stringValue = value as? String {
                
                let label = UILabel()
                label.text = "\(key): \(stringValue)"
                stackView.addArrangedSubview(label)
                
            } else if let dateValue = value as? Date {
                
                let label = UILabel()
                label.text = "\(key): \(dateValue.formattedDate)"
                stackView.addArrangedSubview(label)
                
            } else if let boolValue = value as? Bool {
                
                let label = UILabel()
                label.text = "\(key): \(boolValue ? "✅" : "⚪️" )"
                stackView.addArrangedSubview(label)
                
            } else if let imageValue = value as? UIImage {
                
                let imageView = UIImageView(image: imageValue)
                imageView.contentMode = .scaleAspectFit
                let heightConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .height,
                    multiplier: 1,
                    constant: 200
                )
                imageView.addConstraint(heightConstraint)
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check identifier
        guard segue.identifier == "ToDoItemSegue" else { return }
        // Get index element
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        let destination = segue.destination as! ToDoItemTableViewController
        destination.todo = todos[selectedIndex.row].copy() as! ToDo
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        guard seque.identifier == "SaveSegue" else { return }
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        let source = seque.source as! ToDoItemTableViewController
        todos[selectedIndex.row] = source.todo
        
        if let toDoCell = tableView.cellForRow(at: selectedIndex) as? ToDoCell
        {
            if let stackView = toDoCell.stackView {
                stackView.arrangedSubviews.forEach { subview in
                    stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
        }
        tableView.reloadRows(at: [selectedIndex], with: .automatic)
        
    }
    
}
