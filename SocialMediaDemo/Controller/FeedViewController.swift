//
//  FeedViewController.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 8/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
    }

    @IBAction func signOutBtnPressed(_ sender: UIBarButtonItem) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        //TODO: Perform Segue to SignIn View
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return feedTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
}
