//
//  MSCreateProfileViewController.swift
//  milkshake
//
//  Created by Brian Correa on 5/18/16.
//  Copyright © 2016 milkshake-systems. All rights reserved.
//

import UIKit

class MSCreateProfileViewController: MSViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    static let fields = ["E-mail", "Image", "Password"]
    var field: UITextField!
    var nxtBtn: UIButton!
    var pageControl: UIPageControl!
    var step: Int!
    
    var textFields = Array<UITextField>()
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Register Profile"
    }
    
    override func loadView() {
        print("Load View: \(self.step)")
        
        var placeholder = ""
        var bgColor = UIColor.whiteColor()
        var btnText = ""
        
        switch self.step {
            case 0:
                placeholder = "E-mail"
                bgColor = UIColor.darkGrayColor()
                btnText = "Next"
            
            case 1:
                placeholder = "Profile Picture (Optional)"
                bgColor = UIColor.redColor()
                btnText = "Next"
            
            case 2:
                placeholder = "Password"
                bgColor = UIColor.greenColor()
                btnText = "Finish"
            
            default:
                break
        }
        
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = bgColor
        
        let padding = CGFloat(20)
        
        let xMark = UIImage(named: "x-mark.png")
        let btnCancel = UIButton(frame: CGRect(x: padding, y: 2*padding, width: xMark!.size.width, height: xMark!.size.height))
        btnCancel.setImage(xMark, forState: .Normal)
        btnCancel.autoresizingMask = .FlexibleTopMargin
        btnCancel.addTarget(self, action: #selector(MSCreateProfileViewController.cancel(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btnCancel)
        
        var y = 0.30*frame.size.height
        let h = CGFloat(32)
        let width = frame.size.width-2*padding
        
        self.field = UITextField(frame: CGRect(x: padding, y: y, width: width, height: h))
        self.field.delegate = self
        self.field.autoresizingMask = .FlexibleTopMargin
        self.field.font = UIFont(name: "Heiti SC", size: 16)
        self.field.textColor = .whiteColor()
        self.field.autocorrectionType = .No
        self.field.borderStyle = .None
        
        let transparent = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
        self.field.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: transparent])
        
        view.addSubview(self.field)
        
        y += self.field.frame.size.height+padding
        
        self.nxtBtn = UIButton(frame: CGRect(x: padding, y: y, width: width, height: 44))
        self.nxtBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.nxtBtn.setTitle(btnText, forState: .Normal)
        self.nxtBtn.titleLabel?.font = self.field.font
        self.nxtBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.nxtBtn.layer.borderWidth = 2.0
        self.nxtBtn.layer.cornerRadius = 0.5*self.nxtBtn.frame.size.height
        self.nxtBtn.alpha = 1
        self.nxtBtn.addTarget(self, action: #selector(MSCreateProfileViewController.nextScreen(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(self.nxtBtn)
        y += self.nxtBtn.frame.size.height+padding
        
        self.pageControl = UIPageControl(frame: CGRect(x: padding, y: y, width: width, height: 20))
        self.pageControl.numberOfPages = MSCreateProfileViewController.fields.count
        self.pageControl.currentPage = self.step
        self.pageControl.alpha = 1
        view.addSubview(self.pageControl)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.field.becomeFirstResponder()
    }
    
    func nextScreen(btn: UIButton){
        print("nextScreen")
        
        let selectedField = MSCreateProfileViewController.fields[self.step]
        
        if(self.field.text?.characters.count == 0){
            let msg = "Please enter "+selectedField
            let alert = UIAlertController(title: "Missing Value", message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if (self.step < 2){
            print("IF statement working")
            let createProfileVc = MSCreateProfileViewController()
            createProfileVc.step = self.step+1
            self.navigationController?.pushViewController(createProfileVc, animated: true)
            return
        }
        
        print("After If Statement:")
    }
    
    //Dismiss Controller
    
    func cancel (btn: UIButton){
        if (self.step == 0){
            self.dismissViewControllerAnimated(true, completion: {
                
                })
            return
        }
       
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - TextFieldDelegate
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        return true
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
