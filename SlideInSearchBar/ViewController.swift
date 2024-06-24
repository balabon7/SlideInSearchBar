//
//  ViewController.swift
//  SlideInSearchBar
//
//  Created by Oleksandr Balabon on 24.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var searchBar: SlideInSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchBar()
    }
    
    private func setupSearchBar() {
        self.searchBar = SlideInSearchBar()
        
        // Set placeholder text
        self.searchBar.placeholderText = "App Library"
        
        // Set the frame of the search bar with left and right padding of 25 points
        self.searchBar.frame = CGRect(x: 25, y: 100, width: self.view.bounds.width - 50, height: 46)
        
        // Add the search bar to the view controller's view
        self.view.addSubview(self.searchBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the frame of the search bar to match the width of the view with left and right padding
        self.searchBar.frame = CGRect(x: 25, y: 100, width: self.view.bounds.width - 50, height: 46)
    }
}
