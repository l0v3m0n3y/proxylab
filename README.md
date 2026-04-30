# proxylab
api for proxylab.live онлайн-чекер прокси и конвертер форматов. Проверка IPv4, SOCKS5, HTTP, HTTPS прокси: гео, ASN, ISP, тип (Datacenter/Residential/Mobile), анонимность, Static/Rotating. Free online proxy checker &amp; format converter
# main
```swift
import Foundation
import proxylab
let client = Proxylab()

do {
    let proxy_status = try await client.check_proxy(proxy: "1.1.1.1:443")
    print(proxy_status)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
