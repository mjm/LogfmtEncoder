# LogfmtEncoder

A Swift `Encoder` that serializes keyed values in a format similar to [logfmt][].

[logfmt]: https://godoc.org/github.com/kr/logfmt

Example:

```swift
import LogfmtEncoder

struct MyLogMessage: Encodable {
    var foo: String
    var bar: Int
    var baz: URL
}

let message = MyLogMessage(foo: "My string", bar: 42, baz: URL(string: "http://example.com/")!)
try TextEncoder().encoder(message)
# => foo="My string" bar=42 baz="http://example.com/"
```

## Limitations

* Unkeyed containers are not supported, since they don't map well to key identifiers for the log format. If you try to encode a value that asks for an unkeyed container, a `fatalError()` will be triggered.
* Exactly one level of keyed containers is supported. logfmt messages are a flat list of keys, and your `Encodable`s must match that. It is valid to encode something with a single value container as long as it's already within a keyed container.
