# macOS Terminal-Adjacent Preferences

## Always show hidden files in Finder

```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

Undo:

```bash
defaults write com.apple.finder AppleShowAllFiles -bool false
killall Finder
```

## Hide macOS "Last login" message

```bash
touch ~/.hushlogin
```

Undo:

```bash
rm ~/.hushlogin
```
