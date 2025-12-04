
# anyhoo_router

A package for handling routing using `GoRouter`. It will take a list of routes (`AnyhooRoute`) and some other arguments, to handle building the nested routing tree, handling redirects (when logged in or not).

## Arguments

* `routes` - list of routes (`RouteBase`)
* `authCubit` - `AnyhooAuthCubit`
* `debugLogDiagnostics` - boolean if logging debug diagnostics (default is `false`)
* `redirectNotFound` - string of where to redirect if a route isn't found (defaults to `/not-found`)
* `loginPath` - string of where to redirect when user is not logged in (defaults to `/login`)
* `initialPath` - string of where to redirect if no route is given (defaults to `/`)

## Redirecting

There are a 4 different ways to handle redirecting, always redirect, redirect based on some property,
redirecting for deep linking, and redirecting when route doesn't exist.

### Always redirect

This should be handled by the `GoRoute` which has a `redirect` parameter. Set this up to just return the path to redirect to.

### Redirect based on a property 

The most common case would be to redirect to the `login` page if the user is not logged in, and the route requires the user to be.
But it can also be any other property
This should also be handle by the `GoRoute` and the `redirect` parameter. The function can get ahold of the potential user object,
check if it is `null` or not, and if it is `null` then return `/login` (or whatever it should redirect to).

## Redirect for deep linking

When deep linking into the app, the path will contain the app name or url, so it will be needed to remove that part in order to
know what route to actually go to.
This will be handled by the redirect function for the `GoRouter` itself. For the `AnyhooRouter` that functionality is already built in,
and needs the url prefix and app name prefix to know what parts should be removed. 

### Redirect when no route exists

This is also handled by the redirect function for `GoRouter` and is built in to `AnyhooRouter`. 
It will check if any route is matching and if not, redirect to the route given by the parameter.
There is a parameter `redirectNotFound` that allows the user to specify where to redirect to. It defaults to `/not-found`.
