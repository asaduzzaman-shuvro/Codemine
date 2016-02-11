// Copyright (c) 2015 Hyper Interaktiv AS
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

public enum DispatchQueue {
    case Main, Interactive, Initiated, Utility, Background, Custom(dispatch_queue_t)
}

private func getQueue(queue queueType: DispatchQueue = .Main) -> dispatch_queue_t {
    let queue: dispatch_queue_t
    
    switch queueType {
    case .Main:
        queue = dispatch_get_main_queue()
    case .Interactive:
        queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    case .Initiated:
        queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    case .Utility:
        queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    case .Background:
        queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    case .Custom(let userQueue):
        queue = userQueue
    }
    
    return queue
}

public func delay(delay:Double, queue queueType: DispatchQueue = .Main, closure: () -> Void) {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
        getQueue(queue: queueType),
        closure
    )
}

public func dispatch(queue queueType: DispatchQueue = .Main, closure: () -> Void) {
    dispatch_async(getQueue(queue: queueType), {
        closure()
    })
}