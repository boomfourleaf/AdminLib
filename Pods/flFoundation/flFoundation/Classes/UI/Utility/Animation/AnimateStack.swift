//
//  AnimateStack.swift
//  FuncationProgramming2
//
//  Created by Nattapon Nimakul on 2/12/2558 BE.
//  Copyright (c) 2558 Nattapon Nimakul. All rights reserved.
//

import UIKit

public class Animate2 {
    public typealias NormalTask = ()->Void
    public typealias AnimateTask = NormalTask
    
    public enum Task {
        case Animation(task: AnimateTask, duartion: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions)
        case Normal(NormalTask)
        // case Background(NormalTask) Not yet implement
    }
    
    public var tasks = [Task]()
    public var durationValue: NSTimeInterval = 0.5
    public var delayValue: NSTimeInterval = 0.0
    public var optionsValue: UIViewAnimationOptions = [.BeginFromCurrentState, .CurveEaseInOut]
    
    public init() {
        
    }
    
    public init(_ task: AnimateTask) {
        animate(task)
    }
    
    public func animate(task: AnimateTask) -> Animate2 {
        tasks.append(.Animation(task: task, duartion: durationValue, delay: delayValue, options: optionsValue))
        return self
    }
    
    public func task(task: NormalTask) -> Animate2 {
        tasks.append(.Normal(task))
        return self
    }
    
    public func duration(value: NSTimeInterval, animate task: AnimateTask? = nil) -> Animate2 {
        durationValue = value
        guard let taskValue = task else { return self }
        return animate(taskValue)
    }
    
    public func delay(value: NSTimeInterval, animate task: AnimateTask? = nil) -> Animate2 {
        delayValue = value
        guard let taskValue = task else { return self }
        return animate(taskValue)
    }
    
    public func options(value: UIViewAnimationOptions, animate task: AnimateTask? = nil) -> Animate2 {
        optionsValue = value
        guard let taskValue = task else { return self }
        return animate(taskValue)
    }
    
    // Recursive run task by task
    public func run() {
        guard tasks.count > 0 else { return }
        switch self.tasks[0] {
        case let .Animation(task, duartion, delay, options):
            UIView.animateWithDuration(duartion, delay: delay, options: options, animations: {
                task()
            }) { _ in
                _ = self.tasks.removeAtIndex(0)
                self.run()
            }
        case let .Normal(task):
            task()
            _ = self.tasks.removeAtIndex(0)
            self.run()
        }
    }
}

extension Animate2 {
    public static func dance(view: UIView) {
        Animate2().duration(0.12).options(.CurveEaseOut) {
            view.transform = CGAffineTransformMakeScale(1.15, 1.15)
        }.duration(0.1) {
            view.transform = CGAffineTransformMakeScale(0.85, 0.85)
        }.animate {
            view.transform = CGAffineTransformMakeScale(1.075, 1.075)
        }.animate {
            view.transform = CGAffineTransformMakeScale(0.925, 0.925)
        }.animate {
            view.transform = CGAffineTransformMakeScale(1.00, 1.00)
        }.run()
    }
    
    public static func blink(view: UIView) {
        Animate2().duration(0.2).options(.CurveEaseOut) {
            view.alpha = 0
        }.animate {
            view.alpha = 1
        }.run()
    }
}

public class Animate {
    public typealias NormalTask = (Void -> Void)
    public typealias NormalCompleteTask = NormalTask -> Void
    public typealias AnimateTask = NormalTask
    public typealias AnimateCompleteTask = NormalCompleteTask
    
    public enum Task {
        case Animation(AnimateCompleteTask)
        case Normal(NormalTask)
        // case Background(NormalTask) Not yet implement
    }
    
    public lazy var tasks = { [Task]() }()
    public var durationValue: NSTimeInterval = 0.5
    public var delayValue: NSTimeInterval = 0.0
    public var optionsValue: UIViewAnimationOptions = [.BeginFromCurrentState, .CurveEaseInOut]
    
    public init() {
        
    }
    
    public init(_ task: AnimateTask) {
        animate(task)
    }
    
    public func animate(task: AnimateTask?) -> Animate {
        if let taskValue = task {
            let animate = animator()
            tasks.append(.Animation({ (complete: AnimateTask) in animate( taskValue, { _ in complete() } ) }))
        }
        return self
    }
    
    public func task(task: NormalTask?) -> Animate {
        if let taskValue = task {
            tasks.append(.Normal(taskValue))
        }
        return self
    }
    
    public func duration(value: NSTimeInterval, animate task: AnimateTask? = nil) -> Animate {
        durationValue = value
        animate(task)
        return self
    }
    public class func duration(value: NSTimeInterval, animate: AnimateTask? = nil) -> Animate { return Animate().duration(value, animate: animate) }
    
    public func delay(value: NSTimeInterval, animate task: AnimateTask? = nil) -> Animate {
        delayValue = value
        animate(task)
        return self
    }
    public class func delay(value: NSTimeInterval, animate: AnimateTask? = nil) -> Animate { return Animate().delay(value, animate: animate) }
    
    public func options(value: UIViewAnimationOptions, animate task: AnimateTask? = nil) -> Animate {
        optionsValue = value
        animate(task)
        return self
    }
    public class func options(value: UIViewAnimationOptions, animate: AnimateTask? = nil) -> Animate { return Animate().options(value, animate: animate) }
    
    public func pop() -> Animate {
        if !tasks.isEmpty {
            _ = tasks.removeLast()
        }
        return self
    }
    
    public func append(animator: Animate) {
        self.tasks += animator.tasks
    }
    
    public func clone() -> Animate {
        let newAnimate = Animate()
        newAnimate.tasks = tasks
        newAnimate.durationValue = durationValue
        newAnimate.delayValue = delayValue
        newAnimate.optionsValue = optionsValue
        return newAnimate
    }
    
    private func animator() -> (AnimateTask, ((Bool) -> Void)?) -> Void {
        let animateDuration = durationValue, tmpDelay = delayValue, tmpOptions = optionsValue
        return { task, complete in UIView.animateWithDuration(animateDuration, delay: tmpDelay, options: tmpOptions, animations: task, completion: complete) }
    }
    
    private func run(_myTasks: [Task]) {
        var myTasks = _myTasks
        if !myTasks.isEmpty {
            let task = myTasks.removeAtIndex(0)
            switch task {
            case let .Animation(animationTask):
                animationTask({ self.run(myTasks) })
            case let .Normal(normalTask):
                let completeTask: NormalCompleteTask = { (complete: NormalTask) in normalTask(); complete()   }
                completeTask({ self.run(myTasks) })
            }
        }
    }
    
    public func run() {
        run(tasks)
        tasks.removeAll(keepCapacity: false)
    }
}

