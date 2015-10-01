# ImbaKit

## Usage

Create a package.json:

```json
{
  "dependencies": {
    "imba-kit": "github:judofyr/ImbaKit"
  },
  "scripts": {
    "build": "imba-kitc app.imba"
  }
}
```

Then add ImbaKit to your Podfile:

```ruby
pod 'ImbaKit', :path => 'node_modules/imba-kit'
```

Install everything:

```
$ npm install
$ pod install
```

Write an `app.imba`:

```imba
var IK = require 'imba-kit'

tag app < view
  def render
    # Not much is supported yet
    <self>
      <view flex=1>
      <view flex=2>

IK.onBoot do
  # Return a tag here
  <app>
```

Build your app:

```
$ npm run build
```

This will produce a `bundle.js`. Add this your Xcode project, and load it using:

```objc
// Intialize a new application
ImbaApplication *imbaApp = [[ImbaApplication alloc] init];

// Load the source
NSURL *url = [[NSBundle mainBundle] URLForResource:@"bundle" withExtension:@"js"];
[imbaApp loadSource:url];

// This will call your onBoot and insert the view
[imbaApp mount:self.view];
```

