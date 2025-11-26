
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