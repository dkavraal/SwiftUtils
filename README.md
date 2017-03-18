# SwiftUtils
Useful classes

* **ExpiringValue`<T>`**

  An expiring object, here is a sample:
  
  
```swift
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
```
