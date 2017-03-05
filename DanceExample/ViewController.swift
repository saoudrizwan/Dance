//
//  ViewController.swift
//  DanceExample
//
//  Created by Saoud Rizwan on 2/12/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var whiteLine: UIView!
    
    @IBOutlet weak var hasAnimationLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var isRunningLabel: UILabel!
    @IBOutlet weak var isReversedLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var startPosition: CGPoint!
    var endPosition: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circle.layer.cornerRadius = circle.frame.width / 2
        startPosition = CGPoint(x: whiteLine.frame.minX, y: whiteLine.center.y / 2)
        endPosition = CGPoint(x: whiteLine.frame.maxX, y: whiteLine.center.y / 2)
        circle.center = startPosition
        slider.value = 0
        slider.isContinuous = true
        let _ = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (_) in
            self.updateValues()
        })
        
        /*
         In order to animate a view, you first need to define an animation block with that view's final properties inside.
         Remember, when you first access a view's dance, you must use the 'dance' keyword. (Ex. view.dance)
         
         For a list of properties you can animate, see Table 4-1 on:
         https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/AnimatingViews/AnimatingViews.html
         */
        
        /*
         You can create an animation using:
         
         1) built-in UIKit timing curve
         * easeInOut (slow at beginning and end)
         * easeIn (slow at beginning)
         * easeOut (slow at end)
         * linear
         */
        
        circle.dance.animate(duration: 10.0, curve: .easeInOut) { (make) in
            make.center = self.endPosition
        }
        
        // Better yet, let's do that with Swift's shorthand notation:
        
        circle.dance.animate(duration: 10.0, curve: .easeInOut) {
            $0.center = self.endPosition
        }
        
        /*
         Tip: Option + click the '.animate' part of that ^ function.
         That way you can see detailed documentation of each of Dance's functions.
         */
        
        /*
         2) custom timing curve object
         I recommend reading Apple's documentation on UITimingCurveProvider
         https://developer.apple.com/reference/uikit/uitimingcurveprovider
         */
        
        let timingParameters = UISpringTimingParameters(mass: 1.0, stiffness: 0.2, damping: 0.5, initialVelocity: CGVector(dx: 0, dy: 0))
        
        circle.dance.animate(duration: 10.0, timingParameters: timingParameters) {
            $0.center = self.endPosition
        }
        
        /*
         3) custom cubic Bézier timing curve
         https://developer.apple.com/reference/uikit/uiviewpropertyanimator/1648368-init
         */
        
        let controlPoint1 = CGPoint(x: 0, y: 1)
        let controlPoint2 = CGPoint(x: 1, y: 0)
        
        circle.dance.animate(duration: 10.0, controlPoint1: controlPoint1, controlPoint2: controlPoint2) {
            $0.center = self.endPosition
        }
        
        /*
         4) sping-based timing information
         Basically, dampingRatio should be a CGFloat between 0 and 1. The closer it is to 0, the 'springy-er' the animation will be. The closer it is to 1, the damper the spring animation will be.
         */
        
        circle.dance.animate(duration: 10.0, dampingRatio: 0.5) {
            $0.center = self.endPosition
        }
        
        /*
         
         You can even animate constraint changes easily with Dance:
         
         Recommended reading:
            * Animating Constraints
              http://stackoverflow.com/a/27372232/3502608
         
            * What is .layoutIfNeeded()
              http://stackoverflow.com/a/29151376/3502608
         
            * Animating Constraints Using iOS 10’s New UIViewPropertyAnimator
              https://medium.com/@sdrzn/animating-constraints-using-ios-10s-new-uiviewpropertyanimator-944bbb42347b#.du139c6c7
         
         TL;DR: you can call .layoutIfNeeded() on a view to layout it and its subviews. This means that you're updating its constraints and its subviews' constraints, and putting .layoutIfNeeded() in a Dance animation block (or any UIKit animation block) will animate the constraint changes.
         */
        
        circle.dance.animate(duration: 10.0, curve: .easeOut) {
            $0.layoutIfNeeded()
        }
        
        /*
         Wait, so what's being animated at the end of viewDidLoad? Didn't we just make a ton of .animate() blocks at once?
         
         Dance is forgiving, so if we accidentally create a new animation block for a view that already has an animation block associated with it, then Dance will finish the old animation (leaving it at its current position.)
         
         So let's set our desired animation block on circle (and set a completion block while we're at it) :
         */
        
        circle.dance.animate(duration: 10.0, curve: .linear) {
            $0.center = self.endPosition
        }.addCompletion { (position) in
            switch position {
            case .start:
                print("Finished the animation at the start position.")
            case .current:
                print("Finished the animation at the current position.")
            case .end:
                print("Finished the animation at the end position.")
            }
        }
        
        /* ----- IMPORTANT SIDE NOTE -----
         
         You can animate properties of other views besides the dancing view inside its animation block. For example:
         
         circle.dance.animate(duration: 2.0, curve: .easeIn) {
             $0.center = newCenter // $0 is circle
             self.triangle.center = newCenter // triangle is a view completely unassociated with circle, but Dance will make it a part of circle's animation block. So whenever you pause circle's dance animation, then the triangle gets paused as well. But you can't access that animation using triangle.dance, since the animation is associated with circle.
         }
         */
        
        /* ---------- DEBUGGING ----------
         
         Debugging with Dance is easy. Let's say you accidentally call circle.dance.start() before you ever create a Dance animation for circle.
         Instead of causing a runtime error or fatal error, Dance will print the following:
         
            ** Dance Error: view with dance.tag = <tag> does not have an active animation! **
         
         Dance assigns each dance animation a dance tag, which you can access like so:
         
            circle.dance.tag
         
         This way you can keep track of you views' dance animations and easily handle any of Dance's error print logs.
         */
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
        // in case you tap 'circle.dance.start()' after the animation declared in viewDidLoad has already finished
        if !circle.dance.hasAnimation { resetCircleAnimation() }
        
        // start the animation associated with circle
        circle.dance.start()
        
        // or circle.dance.start(after: 5.0) for a delay before we start the animation
        
        /*
         We could have just as easily started our animation after declaring an animation block for circle using function chaining, like so:
         
        circle.dance.animate(duration: 2.0, curve: .easeOut) {
            $0.center = self.endPosition
        }.addCompletion { (position) in
            switch position {
            case .start:
                print("Finished the animation at the start position.")
            case .current:
                print("Finished the animation at the current position.")
            case .end:
                print("Finished the animation at the end position.")
            }
        }.start()
         
         Notice how we don't have to use the 'dance' keyword when function chaining.
        */
        
        
    }
    
    @IBAction func pauseTapped(_ sender: Any) {
        // Note: .pause() doesn't render the view at it's current position, you need to call .finish(at:) in order to render the view and its subviews at the desired finishing position (.start, .current, or .end)
        
        circle.dance.pause()
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        /*
         .finish(at:) takes a UIViewAnimatingPosition, which can be one of .start, .end, or .current. This method ends the view's animation block and renders the view in the desired position. Then it immediately triggers any completion blocks declared for the view's animation.
         Go ahead and change '.current' to '.end' and see what happens.
         */
        
        circle.dance.finish(at: .current)
    }
    
    @IBAction func reverseTapped(_ sender: Any) {
        // .reverse() reverses the animation block. Think of the animation block as a movie, and .reverse() plays the movie backwards.
 
        circle.dance.reverse()
        
        /*
         You could just as easily do:
         circle.dance.isReversed = true
         */
        
        /*
         Note: you can only reverse an animation if it's been started at least once. If you want to reverse an animation from the first start(), you could do something like:
         circle.dance.start().reverse()
         */
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        circle.dance.setProgress(to: slider.value)
        // or circle.dance.progress = CGFloat(slider.value)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        resetCircleAnimation()
    }
    
    func resetCircleAnimation() {
        if circle.dance.hasAnimation {
            circle.dance.finish(at: .current)
        }
        circle.center = startPosition
        circle.dance.animate(duration: 10.0, curve: .linear) {
            $0.center = self.endPosition
        }.addCompletion { (position) in
            switch position {
            case .start:
                print("Finished the animation at the start position.")
            case .current:
                print("Finished the animation at the current position.")
            case .end:
                print("Finished the animation at the end position.")
            }
        }
    }
    
}

extension ViewController {
    func updateValues() {
        if circle.dance.hasAnimation {
            hasAnimationLabel.text = "circle.dance.hasAnimation = true"
            switch circle.dance.state {
            case .active:
                stateLabel.text = "circle.dance.state = .active"
            case .inactive:
                stateLabel.text = "circle.dance.state = .inactive"
            }
            if circle.dance.isRunning {
                isRunningLabel.text = "circle.dance.isRunning = true"
            } else {
                isRunningLabel.text = "circle.dance.isRunning = false"
            }
            if circle.dance.isReversed {
                isReversedLabel.text = "circle.dance.isReversed = true"
            } else {
                isReversedLabel.text = "circle.dance.isReversed = false"
            }
            slider.setValue(Float(circle.dance.progress), animated: false)
            progressLabel.text = String(format: "circle.dance.progress = %.2f", Float(circle.dance.progress))
        } else {
            hasAnimationLabel.text = "circle.dance.hasAnimation = false"
            stateLabel.text = "circle.dance.state = .inactive"
            isRunningLabel.text = "circle.dance.isRunning = false"
            isReversedLabel.text = "circle.dance.isReversed = false"
            slider.setValue(0, animated: false)
            progressLabel.text = String(format: "circle.dance.progress = 0.0")
        }
    }
}

