# RouteFoundation
An easy-to-use and lightweight Route in swift for UIKit

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate RouteFoundation into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '13.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'RouteFoundation', '~> 0.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

> Xcode 13+ is required to build RouteFoundation using Swift Package Manager.

To integrate RouteFoundation into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/tjerwinchen/RouteFoundation.git", .upToNextMajor(from: "0.0.1"))
]
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate RouteFoundation into your project manually.

---

## Usage

### Quick Start
```swift
import RouteFoundation

// define the route
enum AppRoute: String, Route {
  case home
  case profile

  // define the view-controller provider for each route
  var viewControllerProvider: ViewControllerProvider {
    switch self {
    case .home:
      return { arg in
        let (url, params, context) = arg
        let viewController = HomeViewController()
        viewController.title = params["title"]
        return viewController
      }
    case .profile:
      return { arg in
        let (url, params, context) = arg
        let viewController = ProfileViewController()
        viewController.title = params["title"]
        return viewController
      }
    }
  }
}

// show/show-detail/push/present pages via routes
AppRoute.home.show()
AppRoute.home.showDetail()
AppRoute.profile.push()
AppRoute.profile.present()

// Optional: In SceneDelegate.swift, implement scene:openURLContexts
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  //...
  
  /// Outside the app to open 
  ///
  /// * home page: your-app-schema://app-bundle-identifier/home?title="HOME_PAGE"
  /// * profile page: your-app-schema://app-bundle-identifier/profile?title="HOME_PAGE"&other_param="OTHER_PARAM"
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      RouteManager.shared.open(url: url)
    }
  }
}
```

## License

RouteFoundation is released under the MIT license. See LICENSE for details.
