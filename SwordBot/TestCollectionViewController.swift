//
//  TestCollectionViewController.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/26/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

class TestCollectionViewController: UIViewController {
  
  class func getVC() -> TestCollectionViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil);
    let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TestCollectionViewController.self)) as! TestCollectionViewController
    return vc
  }
  let reuse = "reuse"
  
  @IBOutlet var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "TestCollectionViewController"
  }
}
