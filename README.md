# CombineVisualizer

## Overview
CombineVisualizer is a project aimed at providing insights into the invocation sequence and threads used by various Combine elements, including Publishers, Subscribers, Subscriptions, and Subjects. The main objective is to visualize the order and thread of method invocations, enabling developers to better understand the execution flow within Combine.
The main purpose is to use it with [CombineVisualizerApplication](https://github.com/momo-youngg/CombineVisualizerApplication) for screen graphics, but you can also use custom handlers to log.

## Description
The CombineVisualizer project offers an alternative implementation for all Combine operators. By reimplementing the existing operators and prefixing them with "cz", it captures detailed information about the invocation sequence and thread usage of Combine methods. For example, when using the czReceive(on:) operator, the visualizer will indicate the scheduling performed by the specified Scheduler before the invocation of the Subscriber's receive() method. This information, including method order, scheduler, thread, and more, will be presented on the screen in a visual format.

To incorporate CombineVisualizer into your project, replace the standard Combine operators with their corresponding "cz" prefixed custom operators. By utilizing these custom operators, developers can observe and analyze the order and thread of method invocations as they occur within their Combine pipelines.

## Usage
To use CombineVisualizer in your Combine-based project, follow these steps:

- Import the CombineVisualizer library into your Xcode project.
- Setting the port that will be used in [CombineVisualizerApplication](https://github.com/momo-youngg/CombineVisualizerApplication)
```swift
CombineVisualizerConfig.setOutputType(.visualize(port: "8080"))
        
// or you can set the custom handlers
CombineVisualizerConfig.setOutputType(.custom({ info in
    // do whatever you want
}))
```
- Replace the standard Combine operators with their corresponding "cz" prefixed custom operators.
- Build and run your project.
```swift
let subject = CZPassthroughSubject(
    inner: PassthroughSubject<Int, Never>(),
    trid: UUID()
)

let cancellable = subject
    .czSubscribe(on: DispatchQueue.main)
    .czFilter { value in
        // Custom operator implementation
        return value > 0
    }
    .czMap { value in
        // Custom operator implementation
        return value * 2
    }
    .czReceive(on: DispatchQueue.global())
    .sink(receiveCompletion: { completion in
        // Handle completion
    }, receiveValue: { value in
        // Handle value
    })

subject.send(1)
subject.send(2)
```
- Observe the visual output on the screen(macOS application [CombineVisualizerApplication](https://github.com/momo-youngg/CombineVisualizerApplication)), which will display the method invocation information in a clear and informative manner.

By using the custom operators provided by CombineVisualizer, you can observe the order and thread of method invocations as they occur during the execution of your Combine pipeline.

## Contact
Any comments on this project are welcome. Feel free to register for the issue.