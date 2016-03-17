// ======================================================================================================================
//
// MARK: - Collection Extension
//
// ======================================================================================================================

extension CollectionType {
	/// Returns an index such that each element at or above the index is partitioned from below by the partition predicate
	///
	/// - Parameter isOrderedBefore: The partioning predicate returns `true` for elements in the collection that are
	///                              ordered below, with respet to the partitioning predicate.
	/// - Complexity: O(lg(n))
	///
	/// - Returns: An index such that each element at or above the returned index evaluates as `false` with respect to `isOrderedBefore(_:)`
	@warn_unused_result
    func lowerBound(@noescape isOrderedBefore: Self.Generator.Element -> Bool) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advancedBy(half)
            if isOrderedBefore(self[middle]) {
                firstIndex = middle.advancedBy(1)
                len -= half + 1
            } else {
                len = half
            }
        }
        return firstIndex
	}
	
	/// Returns an index such that each element below the index is strictly less than the partition predicate
	///
	/// - Parameter partitionPredicate: The partioning predicate. Returns `true` for elements in the collection that are
	///                             ordered below, with respet to the partitioning predicate.
	/// - Complexity: O(lg(n))
	///
	/// - Returns: An index such that each element evaluates as `false` with respect to `partitionPredicate(_:)`
	@warn_unused_result
	func upperBound(@noescape partitionPredicate:Self.Generator.Element -> Bool) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advancedBy(half)
            if partitionPredicate(self[middle]) {
                len = half
            } else {
                firstIndex = middle.advancedBy(1)
                len -= half + 1
            }
        }
        return firstIndex
	}
    
    /// Returns `true` if element is in Collection, `false` otherwise
    @warn_unused_result
    func binarySearch(@noescape partitionPredicate:Self.Generator.Element -> Bool) -> Bool {
        let lb = lowerBound(partitionPredicate)
        print("binary search lb: \(lb)")
        return (lb != self.endIndex) && !partitionPredicate(self[lb])
    }
    
}

// ======================================================================================================================
//
// MARK: - Tests
//
// ======================================================================================================================

// Tests
let sortedArray = [1, 2, 3, 4]
let unsortedArray = [2, 1, 4, 3]
let testDict = [ 1:"a", 2:"b", 0:"c"]
let testSet: Set = [2, 1, 3]

print(testDict)
print(testDict.sort {$0.0 < $1.0})
print(testSet.sort())
print(testDict.keys)

print("Sorted array is now: \(sortedArray)")

let lower = sortedArray.lowerBound { $0 <= 3 }
print("Lower is \(lower)")

let upper = sortedArray.upperBound { $0 <= 3 }
print("Upper is \(upper)")

print("sortedArray contains 2: \(sortedArray.binarySearch{ $0 <= 2 })")
print("sortedArray contains 5: \(sortedArray.binarySearch {$0 < 5})")

print("\n---------------------------------------\n")

let testArray1 = [4, 5, 9, 10, 19, 22, 24]
let testLower1 = testArray1.lowerBound { $0 < 9 }
let testUpper1 = testArray1.upperBound { $0 < 9 }
print("Predicate: { <9 }")
print("For array: \(testArray1)\nLower bound for 9: \(testLower1)\nUpper bound for 9: \(testUpper1)")

let testLower2 = testArray1.lowerBound { $0 <= 9 }
let testUpper2 = testArray1.upperBound { $0 <= 9 }
print("Predicate: { <=9 }")
print("For array: \(testArray1)\nLower bound for 9: \(testLower2)\nUpper bound for 9: \(testUpper2)")

print("\n---------------------------------------\n")

let testArray2 = [4, 5, 10, 19, 22, 24]
let testLower3 = testArray2.lowerBound { $0 < 9 }
let testUpper3 = testArray2.upperBound { $0 < 9 }
print("Predicate: { <9 }")
print("For array: \(testArray2)\nLower bound for 9: \(testLower3)\nUpper bound for 9: \(testUpper3)")

let testLower4 = testArray2.lowerBound { $0 <= 9 }
let testUpper4 = testArray2.upperBound { $0 > 9 }
print("Predicate: { <=9 }")
print("For array: \(testArray2)\nLower bound for 9: \(testLower4)\nUpper bound for 9: \(testUpper4)")


print("\n---------------------------------------\n")


let repeatTest = [1, 2, 3, 3, 3, 3, 4, 5]
let repeatLower = repeatTest.lowerBound { $0 < 3 }
let repeatUpper = repeatTest.upperBound { $0 > 3 }
print("Repeat test: \(repeatTest)")
print("Lower: \(repeatLower)\nUpper: \(repeatUpper)")
if (repeatTest.lowerBound { $0 > 3 }) == (repeatTest.upperBound { $0 > 3 }) {
    print("They are equivalent")
}
if (repeatTest.binarySearch{ $0 < 3 }) {
    print("Found 3!")
}