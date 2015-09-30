# ImbaKit

## Usage

You need NPM and CocoaPods:

```
$ npm install --save imba-kit
$ cat Podfile
pod 'ImbaKit', path: 'node_modules/imba-kit'
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

You can now run `imba-kitc` to compile it:

```
$ node_modules/.bin/imba-kitc app.imba
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

