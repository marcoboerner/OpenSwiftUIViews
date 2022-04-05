# OpenSwiftUIViews

## This repository is a work in progress and should not be used directly yet.

### You can clone, fork, or copy parts of the code and make it work for your projects. Feedback, bug reports or pull requests, any sort of collaboration efforts are welcome. Once again:

* I do not recommend using it as a direct dependency
* The code will have bugs
* Using it as it is might cause unexpected behaviors
* I'm constantly changing it while developing another project
* Every change might be a breaking change, even bug fixes
* There are no tests
* The example app might not have example for all and is not always updated when the package changes
* This help file might not be up to date either

## Other than that I'm developing this package to implement some of the features I'm missing in SwiftUI the most or that are not implemented the way I find them useful.


### OpenScrollView

A _non gesture blocking_, _non clipping by default_ custom scroll view implementation with example code.

This is an attempt for a custom scroll view in SwiftUI that will not block other gestures or be blocked by other gestures unless specified with a view modifier. I tried to implement some of the other scroll view features like a scroll view reader and proxy as well.

Ideally I'd like to find a way to use this view together with the regular ScrollView reader but I wasn't able to figure out the internals of it to make it work.

It does work for my purposes but could probably be extended and made more generic and simplified.

[Related questions and answer on Stack Overflow](https://stackoverflow.com/a/64592385/12764795)

### OpenDragAndDrop

Similar to the drag and drop capabilities that SwiftUI provides but only meant for within the app. Allowing views to be dragged and dropped with drop detection and an attached dragged object.

### OpenAlignView

Allows to align the size of the frames of _multiple_ views from multiple stacks in rows and cols.

### OpenAlignOffset

Aligns the offset of _multiple_ views organized in rows and cols, aligning both axes.

### OpenRelativePosition and OpenRelativeOffset

Both allow the positioning of a view in another coordinate system. Relative position is using an internal position modifier, relative offset using an internal offset modifier.

[Related questions and answer on Stack Overflow](https://stackoverflow.com/a/65584150/12764795)
