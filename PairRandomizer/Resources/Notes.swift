//
//  Notes.swift
//  PairRandomizer
//
//  Created by Brooke Kumpunen on 4/19/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation

//Write a single view Pair Randomizer application that takes a list of objects and pairs them together. Potential use cases may be creating an app for Pair Programming teams, or matching people for a Secret Santa gift exchange. Add the following features:
//
//Add entities to a list in a table list view
//Display a list of the added entities grouped by section
//Include a button that allows me to randomize the list
//Implement swipe to delete for individual entities
//    Persist the list of entities

//1) I need a tableView, put onto a regular view. The view will have:
//2) Have a button that randomizes the list. The list being, the items in each cell of the tableView; a textField where you can add an entity.
//3) Swipe to delte. Easy. Persist. Also, easy. I think for persistence I'll use...either CoreData, or simply Codable and save to...the Cloud. Yeh. B)
//4) Just one model object, call it, say...entity. Let's go work on that first.
