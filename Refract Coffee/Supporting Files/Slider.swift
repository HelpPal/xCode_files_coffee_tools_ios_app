//
//  Slider.swift
//  SliderDemo
//
//  Created by Manish Gumbal on 07/09/16.
//  Copyright © 2016 Deftsoft. All rights reserved.
//

import UIKit

protocol SliderDelegate {
    func didChangeSliderValues(lowerValue: Double, upperValue: Double?)
}

@objc @IBDesignable class Slider: UIView {
    
    // MARK: UIViews
    var trackView: UIImageView?
    var selectedView: UIImageView?
    var rightThumb: UIImageView?
    var leftThumb: UIImageView?
    
    //MARK: Delegate
    var delegate: SliderDelegate?
    
    //MARK: Inspectable Data
    @IBInspectable var trackViewColor: UIColor = UIColor.lightGray {     //To change Track view color
        didSet {                                                                //by default light gray
            trackView?.backgroundColor = trackViewColor
        }
    }
    
    @IBInspectable var selectedViewColor: UIColor = UIColor.lightGray {       //To change Selected view color
        didSet {                                                                //by default Blue
            selectedView?.backgroundColor = selectedViewColor
        }
    }
    
    @IBInspectable var rightThumbColor: UIColor = UIColor.white {        //To change Right Thumb color
        didSet {                                                                //by default White
            rightThumb?.backgroundColor = rightThumbColor
        }
    }
    
    @IBInspectable var leftThumbColor: UIColor = UIColor.white {         //To change Left Thumb color
        didSet {                                                                //by default White
            leftThumb?.backgroundColor = leftThumbColor
        }
    }
    
    @IBInspectable var rightThumbValue: CGFloat = 0         //Change Right Thumb Default Value
    @IBInspectable var leftThumbValue: CGFloat = 100        //Change Left Thumb Default Value
    @IBInspectable var selectedViewEnabled: Bool = true     //Bool to check if selected view needed or not
    @IBInspectable var rightThumbEnabled: Bool = true
    @IBInspectable var trackRadiusEnables: Bool = true       // Boo to check if right thumb needed
    @IBInspectable var minValue: CGFloat = 0                //Minimum  Value for slider
    @IBInspectable var maxValue: CGFloat = 100              //Maximum value for slider
    
    
    @IBInspectable var trackViewImage: UIImage? = nil         //Set Image for track view
    @IBInspectable var selectedViewImage: UIImage? = nil      //Set Image for Selected view
    @IBInspectable var leftThumbImage: UIImage? = nil         //Set Image for Left Thumb view
    @IBInspectable var rightThumbImage: UIImage? = nil        //Set Image for Right Thumb view
    
    //MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        if(trackView == nil) {      //Add track view
            trackView = UIImageView()
            
            trackView!.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            if(trackViewImage != nil) {     //Check if image To be used or color for track view
                trackView!.image = trackViewImage!
            }
            else {
                trackView!.backgroundColor = trackViewColor
            }
            if trackRadiusEnables {
                trackView!.layer.cornerRadius = trackView!.frame.height/2
                trackView!.layer.masksToBounds = true
            }
            addSubview(trackView!)
            bringSubview(toFront: trackView!)
        }
        if(leftThumb == nil) {      //Add Left Thumb View
            leftThumb = UIImageView()
            if(leftThumbImage != nil) {     //Check if image To be used or color for Left Thumb view
                leftThumb!.image = leftThumbImage!
                leftThumb?.contentMode = .scaleAspectFill
            }
            else {
                leftThumb!.backgroundColor = leftThumbColor
            }
            leftThumb!.frame = CGRect(x: 0, y: 0, width: 10, height: trackView!.frame.height)

            let thumbCenter = setThumbPosition(value: leftThumbValue, thumb: leftThumb!)
            
            //Set Center according to Value
            leftThumb!.center.x = thumbCenter
            leftThumb!.frame.origin.y = 0
            leftThumb!.layer.cornerRadius = leftThumb!.frame.width/2
            leftThumb?.clipsToBounds = true
            //Set shadow to Left thumb view
//            leftThumb!.layer.shadowColor = UIColor.black.cgColor
//            leftThumb!.layer.shadowOpacity = 0.7
//            leftThumb!.layer.shadowOffset = .zero
//            leftThumb!.layer.shadowRadius = 5
            
            //Add to Super view
            trackView!.layer.masksToBounds = false
            trackView!.addSubview(leftThumb!)
            trackView!.isUserInteractionEnabled = true
            
            //Add Pan Gesture to Thumb
            leftThumb!.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.leftPanGesture(sender:)))
            leftThumb!.addGestureRecognizer(panGesture)
        }
        if(rightThumb == nil && rightThumbEnabled == true) { //Add Right Thumb View if needed
            rightThumb = UIImageView()
            if(rightThumbImage != nil) {    //Check if image To be used or color for Right Thumb view
                rightThumb!.image = rightThumbImage!
            }
            else {
                rightThumb!.backgroundColor = rightThumbColor
            }
            
            rightThumb!.frame = CGRect(x: 0, y: 0, width: 20, height: 203)
            let thumbCenter = setThumbPosition(value: rightThumbValue, thumb: rightThumb!)
            
            //Set Center according to Value
            rightThumb!.center.x = thumbCenter+10
            rightThumb!.frame.origin.y = -rightThumb!.frame.width/2 + trackView!.frame.height/2
            rightThumb!.layer.cornerRadius = rightThumb!.frame.width/2
            
            //Set shadow to Right thumb view
            rightThumb!.layer.shadowColor = UIColor.black.cgColor
            rightThumb!.layer.shadowOpacity = 0.7
            rightThumb!.layer.shadowOffset = .zero
            rightThumb!.layer.shadowRadius = 5
            
            //Add to Super view
            trackView!.layer.masksToBounds = false
            trackView!.addSubview(rightThumb!)
            
            //Add Pan Gesture to Thumb
            rightThumb!.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.rightPanGesture(sender:)))
            rightThumb!.addGestureRecognizer(panGesture)
        }
        if(selectedView == nil && selectedViewEnabled == true) {        //Add selected view if needed
            selectedView = UIImageView()
            if(selectedViewImage != nil) {      //Check if image To be used or color for Selected view
                selectedView!.image = selectedViewImage!
            }
            else {
                selectedView!.backgroundColor = selectedViewColor
            }
            
            //Set Width of Selected view according to range
            var selectedViewWidth = CGFloat()
            if(rightThumb == nil) {
                selectedViewWidth =  trackView!.frame.width-leftThumb!.frame.origin.x-leftThumb!.frame.width/2
            }
            else {
                selectedViewWidth = rightThumb!.frame.origin.x-leftThumb!.frame.origin.x
            }
            
            selectedView!.frame = CGRect(x: leftThumb!.frame.origin.x+leftThumb!.frame.width/2, y: 0, width: selectedViewWidth, height: trackView!.frame.height)
            selectedView!.layer.cornerRadius = selectedView!.frame.height/2
            
            //Add to Super View
            trackView!.addSubview(selectedView!)
            trackView!.bringSubview(toFront: leftThumb!)
            if(rightThumb != nil) {
                trackView!.bringSubview(toFront: rightThumb!)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.thumbPosition(notification:)), name: NSNotification.Name(rawValue: "positionChaged"), object: nil)
    }
    
    
    func thumbPosition(notification: NSNotification) {
        
        guard let value = NumberFormatter().number(from: notification.userInfo!["value"] as? String ?? "0.0") else { return }
        let thumbCenter = setThumbPosition(value: CGFloat(value), thumb: leftThumb!)
        //Set Center according to Value
        leftThumb!.center.x = thumbCenter-2
        leftThumb!.frame.origin.y = 0
        leftThumb!.layer.cornerRadius = leftThumb!.frame.width/2
        leftThumb?.clipsToBounds = true

    }
    
    //Change Thumb position
    func setThumbPosition(value: CGFloat, thumb: UIImageView) -> CGFloat {
        let widthDouble = thumb.frame.width
        return CGFloat(trackView!.frame.width - widthDouble) * (value - minValue) /
            (maxValue - minValue) + CGFloat(widthDouble / 2)
    }
    
    //MARK: Gesture Recognizer Methods
    func leftPanGesture(sender: UIPanGestureRecognizer) {
        if(sender.location(in: self).x >= trackView!.frame.origin.x && ((sender.location(in: self).x <= trackView!.frame.origin.x+trackView!.frame.width && rightThumb == nil) || (rightThumb != nil && sender.location(in: trackView!).x < rightThumb!.center.x-rightThumb!.frame.width/2))) {
            changeThumbPositionOnDrag(position: sender.location(in: trackView!).x, thumb: leftThumb!)
        }
    }
    
    func rightPanGesture(sender: UIPanGestureRecognizer) {
        if(sender.location(in: self).x <= trackView!.frame.origin.x+trackView!.frame.width && sender.location(in: trackView!).x > leftThumb!.center.x+leftThumb!.frame.width/2) {
            changeThumbPositionOnDrag(position: sender.location(in: trackView!).x, thumb: rightThumb!)
        }
    }
    
    //MARK: Change position on drag
    func changeThumbPositionOnDrag(position: CGFloat, thumb: UIImageView) {
        thumb.center.x = position
        var selectedViewWidth = CGFloat()
        if(rightThumb == nil) {
            selectedViewWidth =  trackView!.frame.width-leftThumb!.frame.origin.x-leftThumb!.frame.width/2
        }
        else {
            selectedViewWidth = rightThumb!.frame.origin.x-leftThumb!.frame.origin.x
        }
        
//        selectedView!.frame = CGRect(x: leftThumb!.frame.origin.x+leftThumb!.frame.width/2, y: 0, width: selectedViewWidth, height: trackView!.frame.height)
        delegate?.didChangeSliderValues(lowerValue: getValue(thumb: leftThumb)!, upperValue: getValue(thumb: rightThumb))
    }
    
    func getValue(thumb: UIImageView?) -> Double? {
        if(thumb != nil) {
            print(thumb!.center.x)
            let value = Double(((thumb!.center.x/trackView!.bounds.width)*(maxValue-minValue))+minValue)
            return Double(round(100*value)/100)
        }
        return nil
    }
}
