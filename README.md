<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/22870997/ce90f9d4-f161-11e6-88c4-9573cf109383.png" alt="Dance" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS%2010%2B-blue.svg" alt="Platform: iOS 10+" />
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Language-Swift%203-orange.svg" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/Dance"><img src="https://img.shields.io/badge/pod-v1.0-red.svg" alt="CocoaPods compatible" /></a>
    <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License: MIT" />
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#function">Chaining</a>
  • <a href="#animatable">Animatable Properties</a>
  • <a href="https://github.com/saoudrizwan/Dance/issues">Issues</a>
  • <a href="#license">License</a>
</p>

Dance is a lightweight and straightforward animations framework built upon the new UIViewPropertyAnimator class introduced in iOS 10. With Dance, creating an animation for a view is as easy as calling `view.dance.animate{ … }` and can be started, paused, stopped, reversed, scrubbed through, and finished anywhere that the view can be referenced. Dance is especially forgiving, and provides the power that UIViewPropertyAnimator brings to iOS while at the same time maintaining ease of use.
---
## Quick Start
```swift
import Dance

class MyViewController: UIViewController {

    var circle = UIView()

    override func viewDidAppear() {
        super.viewDidAppear()

        circle.dance.animate(duration: 2.0, curve: .easeInOut) {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            $0.center = self.view.center
            $0.backgroundColor = .blue
        }.addCompletion { (position) in
            if position == .end {
                print("Animation reached the target end position!")
            }
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
* `.progress = 0.85`
* `.finish(at: .end)`
anywhere the view can be referenced.

## Compatibility

Dance requires iOS 10+ and is compatible with **Swift 3** projects.

## Installation

* Installation for [CocoaPods](https://cocoapods.org):

```ruby
use_frameworks!

pod 'Dance'
```
* Or drag and drop 'Dance.swift' into your project.

And `import Dance` in the files you'd like to use it.
---
## Usage

*I recommend looking through the example project, it has detailed documentation of everything Dance has to offer*

<a href="#animatable">What properties can I animate?</a>

### Creating an Animation

#### UIKit timing curve
* easeInOut (slow at beginning and end)
* easeIn (slow at beginning)
* easeOut (slow at end)
* linear

```swift
circle.dance.animate(duration: 10.0, curve: .easeInOut) { (make) in
    make.center = newCenter
}
```
#### Alternatively

```swift
circle.dance.animate(duration: 2.0, curve: .easeInOut) {
    $0.center = newCenter
}
```

#### [UITimingCurveProvider](https://developer.apple.com/reference/uikit/uitimingcurveprovider)
```swift
let timingParameters = UISpringTimingParameters(mass: 1.0, stiffness: 0.2, damping: 0.5, initialVelocity: CGVector(dx: 0, dy: 0))

circle.dance.animate(duration: 10.0, timingParameters: timingParameters) {
    $0.center = newCenter
}
```

#### [Custom Cubic Bézier Timing Curve](https://developer.apple.com/reference/uikit/uiviewpropertyanimator/1648368-init)
```swift
let timingParameters = UISpringTimingParameters(mass: 1.0, stiffness: 0.2, damping: 0.5, initialVelocity: CGVector(dx: 0, dy: 0))

circle.dance.animate(duration: 10.0, timingParameters: timingParameters) {
    $0.center = newCenter
}
```

#### Sping-based Timing Information
```swift
circle.dance.animate(duration: 10.0, springiness: 0.5) {
    $0.center = self.endPosition
}
```

### What About Constraints?

Dance works great with constraints, to animate constraint changes:

```swift
// update constraints for circle and/or its subviews first
// ...
circle.dance.animate(duration: 2.0, curve: .easeInOut) {
    $0.layoutIfNeeded()
}
```
> Usually most developers would call self.view.layoutIfNeeded() in a standard `UIView.animate()` block. However this is bad practice as it lays out all subviews in the current view, when they may only want to animate constraint changes for certain views. With Dance, calling `$0.layoutIfNeeded() only lays out the view that's being animated and its subviews, ensuring low energy impact and high FPS.

### Starting an Animation
After creating an animation block using `.animate`, the animation doesn't start until you call `.start()`.
```swift
circle.dance.start()
```
```swift
circle.dance.start(after: 5.0) // for a delay (in seconds) before starting the animation
```

### Pausing an Animation
When an animation is running, you can pause it. 
```swift
circle.dance.pause()
```
```swift
circle.dance.pause(after: 5.0) // for a delay (in seconds) before pausing the animation
```
**Note:** this won't render the view at the paused position, you must call [`.finish(at: .current)`](#finish) to do that.

### Reverse an Animation
Calling this method will reverse the animation in its tracks.
```swift
circle.dance.reverse()
```
```swift
circle.dance.isReversed = true
```
**Note:** the position value in the completion block will stay the same after calling `.reverse()`. For example, if a view's animation is reversed and the view ends up in its initial position, then the position parameter will be `.start`, not `.end`.

### Scrubbing through an Animation
Dance animations are like movies—you can scrub through them using its `.progress` property. 
```swift
circle.dance.setProgress(to: 0.5) // takes value between 0 and 1
```
```swift
circle.dance.progress = 0.5
```

### Finishing an Animation
Animations will automatically finish when they complete and reach their target values. However if you pause an animation and want to render it, or if you want to finish an animation early, you must call `.finish(at:)`.
```swift
circle.dance.finish(at: .current) // or .start, .end
```

### Dance Properties 
```swift
circle.dance.hasAnimation: Bool
```
```swift
circle.dance.progress: CGFloat
```
```swift
circle.dance.state: UIViewAnimatingState // .inactive, .active, .stopped
```
```swift
circle.dance.isRunning: Bool
```
```swift
circle.dance.isReversed: Bool
```

##Function Chaining
Dance allows you to chain multiple animation commands together, resulting in an elegant and easy-to-read syntax.
Examples:
```swift
circle.dance.animate(duration: 2.0, curve: .easeInOut) {
    $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    $0.center = self.view.center
    $0.backgroundColor = .blue
}.addCompletion { (position) in
    if position == .end {
        print("Animation reached the target end position!")
    }
}.start(after: 2.0)
```
```swift
circle.dance.pause().setProgress(to: 0.9)
```
```swift
circle.dance.start().reverse()
```
---
##Animatable Properties

| Property      | Changes you can make                                       |
| ------------- |------------------------------------------------------------|
| [frame](https://developer.apple.com/reference/uikit/uiview/1622621-frame)                     | Modify this property to change the view’s size and position relative to its superview’s coordinate system. (If the `transform` property does not contain the identity transform, modify the `bounds` or `center` properties instead.)                                 |
| [bounds](https://developer.apple.com/reference/uikit/uiview/1622580-bounds)                   | Modify this property to change the view’s size.      |
| [center](https://developer.apple.com/reference/uikit/uiview/1622627-center)                   | Modify this property to change the view’s position relative to its superview’s coordinate system.     |
| [transform](https://developer.apple.com/reference/uikit/uiview/1622459-transform)             | Modify this property to scale, rotate, or translate the view relative to its center point. Transformations using this property are always performed in 2D space. (To perform 3D transformations, you must animate the view’s layer object using Core Animation.)      |
| [alpha](https://developer.apple.com/reference/uikit/uiview/1622417-alpha)                     | Modify this property to gradually change the transparency of the view.      |
| [backgroundColor](https://developer.apple.com/reference/uikit/uiview/1622591-backgroundcolor) | Modify this property to change the view’s background color. |
| [contentStretch](https://developer.apple.com/reference/uikit/uiview/1622511-contentstretch)   | Modify this property to change the way the view’s contents are stretched to fill the available space. |

Source: https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/AnimatingViews/AnimatingViews.html
---
## License

Dance uses the MIT license. Please file an issue if you have any questions or if you'd like to share how you're using this tool.
---
## Credits

Disco Logo by [Effach from the Noun Project](https://thenounproject.com/francois.hardy.359/)
