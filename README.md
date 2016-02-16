# New Feature: Add binarySearch, lowerBound, upperBound, and equalRange to CollectionType

* Proposal: [SR-368](https://bugs.swift.org/browse/SR-368)
* Authors: Dimitri Gribenko
* Assignee: Jeff Hajewski
* Status: In Progress

## Introduction
The Swift Standard Library does not currenly have an implementation of of C++'s
`binary_search`, `lower_bound`, `upper_bound`, and `equal_range`. These should
be added to the Standard Library as extensions of CollectionType.

## Detail Design
The following API is proposed

```swift
@warn_unused_result
func lowerBound(@noescape isOrderedBelow: (partitioningValue: Self.Generator.Element) -> Bool) -> Index? {
    assertionFailure("Not implemented")
    return nil
}
```

```swift
@warn_unused_result
func upperBound(@noescape isOrderedBelow: (partitioningValue: Self.Generator.Element) -> Bool) -> Index? {
    assertionFailure("Not implemented")
    return nil
}
```
