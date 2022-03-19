# OpenSwiftUIViews

### A _non gesture blocking_, _non clipping by default_ custom scroll view implementation with example code.

This is an atempt for a custom scroll view in SwiftUI that will not block other gestures or be blocked by other gestures unless specified with a view modifier. I tried to implement some of the other scroll view features like a scroll view reader and proxy as well.

Ideally I'd like to find a way to use this view together with the regular ScrollView reader but I wasn't able to figure out the internals of it to make it work.

It does work for my purposes but could probably be extended and made more generic and simplified.

[Related questions and answer on Stack Overflow](https://stackoverflow.com/a/64592385/12764795)
