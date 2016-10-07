//
//  MapViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 10/6/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class MapViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mapView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapView
    }
}
