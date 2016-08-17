//
//  ViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/10/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit

struct Section {
    var sectionTitle:String
    var sectionMember:[String]
    init(title:String,member:[String]){
        sectionTitle = title
        sectionMember = member
    }
}

class ViewControllers: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource:[Section] = []
    var screenWidthCol=CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initDatasource()
        
        
        self.collectionView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
        
        self.view?.backgroundColor = UIColor(patternImage: UIImage(named: "blur")!)
        
        self.title = "Admin Setting"
        
        
        if let layout = collectionView?.collectionViewLayout as? GridSystemLayout {
            layout.delegate = self
        }
    }
    
    func initDatasource(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let section1 = Section(title: "Section 1", member: ["Menu","Table","Staff"])
        let section2 = Section(title: "Section 2", member: ["Discount","Recipt(VATService)"])
        let section3 = Section(title: "Section 3", member: ["Admin","Email Report"])
        let section4 = Section(title: "Section 3", member: ["Printer"])
        dataSource.append(section1)
        dataSource.append(section2)
        dataSource.append(section3)
        dataSource.append(section4)
        
//        prepareLayoutForSize(view.frame.size)
        
    }
    
//    func prepareLayoutForSize(size: CGSize) {
//        screenWidthCol = size.width/12
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("reload")
        let numberOfSection = CGFloat(dataSource[indexPath.section].sectionMember.count)
        let columnWidth = screenWidthCol * (12/numberOfSection)
        
        let cell:MainCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("menu cell", forIndexPath: indexPath) as! MainCollectionViewCell
        
        cell.titleLabel.text =  dataSource[indexPath.section].sectionMember[indexPath.row]
        cell.imageView.image = UIImage(named: dataSource[indexPath.section].sectionMember[indexPath.row])
        
//        
//        // Cell Border 
//        cell.layer.shadowColor = [UIColor CGColor];
//        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
//        cell.layer.shadowRadius = 2.0f;
//        cell.layer.shadowOpacity = 1.0f;
//        cell.layer.masksToBounds = NO;
//        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
//        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                performSegueWithIdentifier("Manage Menu", sender: nil)
            case 1:
                performSegueWithIdentifier("Manage Table", sender: nil)
            case 2:
                performSegueWithIdentifier("Manage Staff", sender: nil)
            default:
                break
            }
        }
        
        if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                performSegueWithIdentifier("Manage Table", sender: nil)
            case 1:
                performSegueWithIdentifier("set recibt segue", sender: nil)
            default:
                break
            }
        }
        
        print(collectionView)
        
//        if collectionView.cellForItemAtIndexPath(indexPath){
        
//        }
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return dataSource[section].sectionMember.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
}


extension ViewControllers : GridSystemLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
//        let photo = photos[indexPath.item]
//        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//        let rect  = AVMakeRectWithAspectRatioInsideRect(photo.image.size, boundingRect)
        return 100
    }
    
    // 2
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
//        let photo = photos[indexPath.item]
//        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
//        let commentHeight = photo.heightForComment(font, width: width)
//        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return 50
    }
}

