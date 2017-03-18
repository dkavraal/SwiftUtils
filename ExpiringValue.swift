//
//  ExpiringValue.swift
//
//  Created by Dincer on 18/03/2017.
//
//  Copyright 2017, MCTData, under MIT License
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




// you can use this class to have expiring values
// not recommended to use many of this, since it has a large mem print
// you can have a number of them, though
import Foundation

final class ExpiringValue<T> {
    /* Sample:
     ---------
     DispatchQueue(label: "deneme", qos: .utility).async {
         let a = ExpiringValue<Bool>(value: true, expireInSecs: 3);
         for _ in 0..<100 {
             print(a.getValue() ?? "EXPIRED");
             sleep(1);
         }
     }
     
     
     Output:
     ---------
     true
     true
     true
     EXPIRED
     EXPIRED
     EXPIRED
     EXPIRED
     EXPIRED
     */
    
    
    private let forSingleton:DispatchQueue = DispatchQueue(label: UUID().uuidString, qos: .utility);
    private var expireTime:TimeInterval = 0.0;
    private var lastSet = Date(timeIntervalSince1970: 0);
    private var _val:T?
    
    init(value:T? = nil, expireInSecs:TimeInterval) {
        _val = value;
        expireTime = expireInSecs;
        lastSet = Date(timeIntervalSinceNow: 0);
    }
    
    func getValue() -> T? {
        var rVal:T? = nil;
        forSingleton.sync {
            if !hasExpired() {
                rVal = self._val;
            }
        }
        return rVal;
    }
    
    func setValue(newValue:T, expireInSecs:TimeInterval) {
        forSingleton.async {
            self._val = newValue;
            self.expireTime = expireInSecs
            self.lastSet = Date(timeIntervalSinceNow: 0);
        }
    }
    
    func setValue(newValue:T) {
        forSingleton.async {
            self._val = newValue;
            self.lastSet = Date(timeIntervalSinceNow: 0);
        }
    }
    
    func setNewTimeout(expireInSecs:TimeInterval) {
        forSingleton.async {
            self.expireTime = expireInSecs
        }
    }
    
    func doExpireAlready() {
        forSingleton.async {
            self._val = nil;
            self.expireTime = 0.0;
            self.lastSet = Date(timeIntervalSinceNow: 0);
        }
    }
    
    func hasExpired() -> Bool {
        return -self.lastSet.timeIntervalSinceNow > self.expireTime
    }
    
}
