
# anyhoo_app_bar

A package providing a custom app bar
It supports some easier way to define action buttons,
use a background image or just a top bar.


## Example

```dart

  child: Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          AnyhooAppBar(
            scrollController: scrollController,
            hasBackButton: true,
            title: 'Example App Bar',
            imageUrl: imgUrl,
            actionButtons: [],
            isLoading: isLoading,
            alwaysCollapsed: alwaysCollapsed,
          ),

```
---

## Changelog

### 0.0.8
 
* Log if image can't be shown

### 0.0.7
 
* Simplify AnyhooAppBar

### 0.0.6
 
* Change color for app bar icon

### 0.0.5
 
* Update to GoRouterWrapper

### 0.0.4
 
* AnyhooBottomBar

### 0.0.3

* Don't care about dividers for showing overflow menu

### 0.0.2

* Add support for action buttons

### 0.0.1

* Create anyhoo_app_bar