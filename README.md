<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/22904979/523aa5d2-f1f3-11e6-87f4-7937e0c8fa21.png" alt="Dance" />
</p>

<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/22878899/6cac52f2-f190-11e6-8891-8941e998275d.png" alt="Platform: iOS 10+" />
    <a href="https://developer.apple.com/swift" target="_blank"><img src="https://cloud.githubusercontent.com/assets/7799382/22878900/6cac5612-f190-11e6-868a-09b9510e1d5b.png" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/Dance" target="_blank"><img src="https://cloud.githubusercontent.com/assets/7799382/23048677/4dfdc7da-f46c-11e6-8468-958ae337c6ab.png" alt="CocoaPods compatible" /></a>
    <img src="https://cloud.githubusercontent.com/assets/7799382/22878898/6caa4ade-f190-11e6-892c-0d98c67b2bd1.png" alt="License: MIT" />
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#debugging">Debugging</a>
  • <a href="#animatable-properties">Animatable Properties</a>
  • <a href="#license">License</a>
</p>

Dance is a **powerful** and **straightforward** animation framework built upon the new <a href="https://developer.apple.com/reference/uikit/uiviewpropertyanimator" target="_blank">`UIViewPropertyAnimator`</a> class introduced in iOS 10. With Dance, creating an animation for a view is as easy as calling `view.dance.animate { ... }`, which can then be started, paused, reversed, scrubbed through, and finished anywhere that the view can be referenced. Dance is especially **forgiving**, and provides the power that `UIViewPropertyAnimator` brings to iOS while maintaining ease of use.

## Quick Start
```swift
import Dance

class MyViewController: UIViewController {

    let circle = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        circle.dance.animate(duration: 2.0, curve: .easeInOut) {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            $0.center = self.view.center
            $0.backgroundColor = .blue
            // ... see 'Animatable Properties' for more options
        }.addCompletion { _ in
            self.view.backgroundColor = .green
        }.start(after: 5.0)
    }
    
    func pauseAnimation() {
        circle.dance.pause()
    }
    
}
```

With Dance, you can create referenceable animations attached to views. That means you can call:
* `.pause()`
* `.start()`
* `.reverse()`
* `.setProgress(to:)`
* `.finish(at:)`

anywhere the view can be referenced.

## Compatibility

Dance requires **iOS 10+** and is compatible with **Swift 3** projects.

## Installation

* Installation for <a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>:

```ruby
platform :ios, '10.0'
target 'ProjectName' do
use_frameworks!

pod 'Dance'

end
```
* Or drag and drop `Dance.swift` into your project.

And `import Dance` in the files you'd like to use it.

## Usage

*It's recommended to look through the example project—it has detailed documentation of everything Dance has to offer.*

**Note:** throughout this document, `circle` will act as the view being animated. You can use Dance on any instance of a `UIView` or `UIView` subclass, such as `UILabel`, `UITextField`, `UIButton`, etc.

**Using Dance is easy.**

1. [Create an animation](#creating-an-animation) for a view, and optionally [add completion blocks](#adding-completion-blocks).

2. [Start](#starting-an-animation) the animation.

3. [Pause](#pausing-an-animation), [reverse](#reversing-an-animation), or [scrub through](#scrubbing-through-an-animation) the animation.

4. Let the animation complete on its own or manually [finish](#finishing-an-animation) the animation early, triggering any completion blocks.

### Creating an Animation

[What properties can I animate?](#animatable-properties)

#### UIKit timing curve
* easeInOut (slow at beginning and end)
* easeIn (slow at beginning)
* easeOut (slow at end)
* linear

```swift
circle.dance.animate(duration: 2.0, curve: .easeInOut) { (make) in
    make.center = newCenter
}
```
... alternatively:

```swift
circle.dance.animate(duration: 2.0, curve: .easeInOut) {
    $0.center = newCenter
}
```

#### <a href="https://developer.apple.com/reference/uikit/uitimingcurveprovider" target="_blank">UITimingCurveProvider</a>
```swift
let timingParameters = UISpringTimingParameters(mass: 1.0, stiffness: 0.2, damping: 0.5, initialVelocity: CGVector(dx: 0, dy: 5))

circle.dance.animate(duration: 2.0, timingParameters: timingParameters) {
    $0.center = newCenter
}
```

#### <a href="https://developer.apple.com/reference/uikit/uiviewpropertyanimator/1648368-init" target="_blank">Custom Cubic Bézier Timing Curve</a>
```swift
let controlPoint1 = CGPoint(x: 0, y: 1)
let controlPoint2 = CGPoint(x: 1, y: 0)
        
circle.dance.animate(duration: 2.0, controlPoint1: controlPoint1, controlPoint2: controlPoint2) {
    $0.center = newCenter
}
```
<img src="https://cloud.githubusercontent.com/assets/7799382/22905836/b5d6875c-f1f6-11e6-9ad8-30373ce211e8.png" alt="bezier curve">

*<sub>https://developer.apple.com/videos/play/wwdc2016/216/</sub>*

#### Sping-based Timing Information
```swift
circle.dance.animate(duration: 2.0, dampingRatio: 0.5) {
    $0.center = newCenter
}
```

### Starting an Animation
After creating an animation block using `.animate { ... }`, the animation doesn't start until you call `.start()`.
```swift
circle.dance.start()
```
```swift
circle.dance.start(after: 5.0) // for a delay (in seconds) before starting the animation
```

### Adding Completion Blocks
Add as many completion blocks as you need, wherever you need to. When an animation finishes, either by playing out the set animation or by calling `.finish(at:)`, then all completion blocks are triggered.
```swift
circle.dance.addCompletion { (position) in
    switch position {
    case .start:
        print("Finished the animation at the start position.")
    case .current:
        print("Finished the animation at the current position.")
    case .end:
        print("Finished the animation at the end position.")
    }
}
```
**Note:** you can't add a completion block to a finished animation.

### Pausing an Animation
```swift
circle.dance.pause()
```
```swift
circle.dance.pause(after: 5.0) // for a delay (in seconds) before pausing the animation
```
**Note:** this won't render the view at the paused position, you must then also call <a href="#finishing-an-animation">`.finish(at: .current)`</a> to do that.


### Reversing an Animation
Calling this method will reverse the animation in its tracks, like playing a video backwards.
```swift
circle.dance.reverse()
```
```swift
circle.dance.isReversed = true
```
**Note:** the position value in the completion block will stay the same after calling `.reverse()`. For example, if a view's animation is reversed and the view ends up in its initial position, then the completion closure's position parameter will be `.start`, not `.end`.


### Scrubbing Through an Animation
Dance animations are like movies—you can scrub through them using the `.progress` property. 
```swift
circle.dance.setProgress(to: 0.5) // takes value 0-1
```
```swift
circle.dance.progress = 0.5
```

### Finishing an Animation
Animations will automatically finish when they complete and reach their target values, triggering any completion blocks. However if you pause an animation and/or want to finish that animation early, you must call `.finish(at:)`.
```swift
circle.dance.finish(at: .current) // or .start, .end
```

### Dance Properties 
```swift
circle.dance.hasAnimation: Bool { get }
```
```swift
circle.dance.progress: CGFloat { get, set }
```
```swift
circle.dance.isRunning: Bool { get }
```
```swift
circle.dance.isReversed: Bool { get, set }
```
For [debugging](#debugging) purposes:
```swift
circle.dance.state: DanceAnimationState { get } // .inactive, .active
```
```swift
circle.dance.tag: Int { get }
```

### What About Constraints?

Dance works great with constraints. To animate constraint changes:

```swift
// update constraints for circle and/or its subviews first
// ...
circle.dance.animate(duration: 2.0, curve: .easeInOut) {
    $0.layoutIfNeeded()
}
```
> Usually most developers would call `self.view.layoutIfNeeded()` in a standard `UIView.animate()` block. However this is bad practice as it lays out all subviews in the current view, when they may only want to animate constraint changes for certain views. With Dance, calling `$0.layoutIfNeeded()` only lays out the view that's being animated and its subviews, ensuring low energy impact and high FPS.

### Function Chaining

Dance allows you to chain multiple animation commands together, resulting in an elegant and easy-to-read syntax.
For example:
```swift
circle.dance.animate(duration: 2.0, curve: .easeInOut) {
    $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    $0.center = self.view.center
    $0.backgroundColor = .blue
}.addCompletion { (position) in
    if position == .end {
        print("Animation reached the target end position!")
    }
}.start(after: 5.0)
```
```swift
circle.dance.pause().setProgress(to: 0.25)
```
```swift
print(circle.dance.pause().progress)
```
```swift
circle.dance.start().reverse()
```

### Debugging

Dance is *forgiving*, meaning that it handles any mistakes that you might make without causing any runtime errors. If you do make a mistake, for example starting an animation that doesn't exist, then Dance will print the following error in the console:
```
** Dance Error: view with dance.tag = <tag> does not have an active animation! **
```
Dance assigns each dance animation a dance tag, which you can access like so:
```swift         
circle.dance.tag
 ```       
This way you can keep track of you views' dance animations and easily handle any of Dance's error print logs.

Furthermore, you can get the state of a view's dance animation:

```swift
switch circle.dance.state {
case .active:
    // A dance animation has been created for the view and has been started.
    // Note: a paused animation's state will return .active
case .inactive:
    // Either there is no dance animation associated with the view, or an animation exists but hasn't been started.
    // Note: a finished animation is inactive because the animation effectively ceases to exist after it finishes
}
```

## Animatable Properties

| UIView Property      | Changes you can make                                       |
| -------------------- |------------------------------------------------------------|
| [frame](https://developer.apple.com/reference/uikit/uiview/1622621-frame)                    | Modify this property to change the view’s size and position relative to its superview’s coordinate system. (If the `transform` property does not contain the identity transform, modify the `bounds` or `center` properties instead.)                                 |
| [bounds](https://developer.apple.com/reference/uikit/uiview/1622580-bounds)                   | Modify this property to change the view’s size.      |
| [center](https://developer.apple.com/reference/uikit/uiview/1622627-center)                   | Modify this property to change the view’s position relative to its superview’s coordinate system.     |
| [transform](https://developer.apple.com/reference/uikit/uiview/1622459-transform)             | Modify this property to scale, rotate, or translate the view relative to its center point. Transformations using this property are always performed in 2D space. (To perform 3D transformations, you must animate the view’s layer object using Core Animation.)      |
| [alpha](https://developer.apple.com/reference/uikit/uiview/1622417-alpha)                     | Modify this property to gradually change the transparency of the view.      |
| [backgroundColor](https://developer.apple.com/reference/uikit/uiview/1622591-backgroundcolor) | Modify this property to change the view’s background color. |
| [contentStretch](https://developer.apple.com/reference/uikit/uiview/1622511-contentstretch)   | Modify this property to change the way the view’s contents are stretched to fill the available space. |

*<sub>https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/AnimatingViews/AnimatingViews.html</sub>*

## Documentation
Option + click on any of Dance's methods for detailed documentation.
<img src="https://cloud.githubusercontent.com/assets/7799382/22877101/ae6ae940-f188-11e6-8f60-7c69b94ade33.png" alt="documentation">

## License

Dance uses the MIT license. Please file an issue if you have any questions or if you'd like to share how you're using Dance.

## Contribute

Dance is in its infancy, but v1.0 provides the barebones of a revolutionary new way to animate in iOS. Please feel free to send pull requests of any features you think would add to Dance and its philosophy.

## Questions?

Contact me by email <a href="mailto:hello@saoudmr.com">hello@saoudmr.com</a>, or by twitter <a href="https://twitter.com/sdrzn" target="_blank">@sdrzn</a>. Please create an <a href="https://github.com/saoudrizwan/Dance/issues">issue</a> if you come across a bug or would like a feature to be added.

## Credits

Disco Ball Icon by [Effach from the Noun Project](https://thenounproject.com/francois.hardy.359/)
