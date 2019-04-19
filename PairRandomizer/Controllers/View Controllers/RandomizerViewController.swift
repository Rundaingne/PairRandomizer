//
//  RandomizerViewController.swift
//  PairRandomizer
//
//  Created by Brooke Kumpunen on 4/19/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class RandomizerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -IBOutlets
    @IBOutlet weak var entityTableView: UITableView!
    @IBOutlet weak var createAnEntityTextField: UITextField!
    @IBOutlet weak var randomizePairsButton: UIButton!
    @IBOutlet weak var groupingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entityTableView.dataSource = self
        entityTableView.delegate = self
        EntityController.shared.fetchEntities { (entities) in
            DispatchQueue.main.async {
                guard let entities = entities else {return}
                self.group(entities: entities)
                self.entityTableView.reloadData()
            }
        }
    }
    
    //MARK: -DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntityController.shared.entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entityCell")
        let entity = EntityController.shared.entities[indexPath.row]
        cell?.textLabel?.text = entity.name
        cell?.detailTextLabel?.text = entity.grouping
        //WHY IS THE CELL DETAIL TEXT LABEL NIL
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entity = EntityController.shared.entities[indexPath.row]
            EntityController.shared.deleteEntity(entity: entity) { (entity) in
                DispatchQueue.main.async {
                    self.entityTableView.reloadData()
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: -Methods
    func group(entities: [Entity]) {
        let newEntities = entities.sorted(by: {$0.grouping > $1.grouping})
        EntityController.shared.entities = newEntities
    }
    
    //MARK: -Actions
    
    @IBAction func addEntityButtonTapped(_ sender: UIButton) {
        //When this button gets tapped, we need to create an entity.
        guard let name = createAnEntityTextField.text, !name.isEmpty,
            let grouping = groupingTextField.text, !grouping.isEmpty else {return}
        EntityController.shared.createEntity(name: name, grouping: grouping) { (entity) in
            DispatchQueue.main.async {
                self.entityTableView.reloadData()
            }
        }
    }
    
    
    @IBAction func randomizePairsButtonTapped(_ sender: UIButton) {
        //FINALLY. When I tap this button, what needs to happen? Hmmm...well, the tableView needs to reload, and the names need to be scrambled. I'll claim this as for SecretSanta. I could add an enum switch feature later for a pairing use. But one thing at a time; that debug took bloody eternity.
        EntityController.shared.entities.shuffle()
        entityTableView.reloadData()
        let entities = EntityController.shared.entities
        for entity in entities {
            //For each entity, I want to shuffle it's name and grouping.
            let originalName = entity.name
            entity.name = entity.grouping
            entity.grouping = originalName
        }
    }
}
