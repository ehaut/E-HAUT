#  EasyHautX
[![license WTFPL 2.0](https://img.shields.io/badge/license-WTFPL_2.0-blue.svg)](LICENSE)
[![](https://img.shields.io/github/release/ehaut/EasyHautX.svg)](https://github.com/ehaut/EasyHautX/releases/latest)
[![Build Status](https://dev.azure.com/zengxs/EhautX/_apis/build/status/ehaut.EhautX?branchName=master)](https://dev.azure.com/zengxs/EhautX/_build/latest?definitionId=1&branchName=master)

A easy client for haut campus network.

## Screenshot

## Developing
### Install Carthage
```sh
brew install carthage
```

### Checkout dependencies
```sh
git submodule update --init --recursive
```

### Build dependencies
#### For iOS
```sh
cd EhautX.iOS
carthage build --platform iOS
```

#### For macOS
```sh
cd EhautX.macOS
carthage build --platform macOS
```

## Contributing
PR are welcome.

## License
[WTFPL 2.0](LICENSE)

