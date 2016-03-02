// ======================================================================================================================
//
// MARK: - Collection Extension
//
// ======================================================================================================================

extension CollectionType {
	/// Returns an index such that each element at or above the index is partitioned from below by the partition predicate
	///
	/// - Parameter partitionPredicate: The partioning predicate returns `true` for elements in the collection that are
	///                                 ordered below, with respet to the partitioning predicate.
	/// - Complexity: O(lg(n))
	///
	/// - Returns: An index such that each element at or above the returned index evaluates as `false` with respect to `partitionPredicate(_:)`
	@warn_unused_result
    func lowerBound(@noescape partitionPredicate: Self.Generator.Element -> Bool) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let tmpIndex = firstIndex.advancedBy(half)
            if partitionPredicate(self[tmpIndex]) {
                firstIndex = tmpIndex.advancedBy(1)
                len = len - half - 1
            } else {
                len = half
            }
        }
        return firstIndex.advancedBy(-1)
	}
	
	/// Returns an index such that each element below the index is strictly less than the partition predicate
	///
	/// - Parameter isOrderedBelow: The partioning predicate. Returns `true` for elements in the collection that are
	///                             ordered below, with respet to the partitioning predicate.
	/// - Complexity: O(lg(n))
	///
	/// - Returns: An index such that each element evaluates as `false` with respect to `isOrderedBelow(_:)`
	@warn_unused_result
	func upperBound(@noescape partitionPredicate:Self.Generator.Element -> Bool) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let tmpIndex = firstIndex.advancedBy(half)
            if !partitionPredicate(self[tmpIndex]) {
                len = half
            } else {
                firstIndex = tmpIndex.advancedBy(1)
                len -= half + 1
            }
        }
        return firstIndex
	}
    
    @warn_unused_result
    func binarySearch(@noescape partitionPredicate:Self.Generator.Element -> Bool) -> Bool {
        let lb = lowerBound(partitionPredicate)
        print("binary search lb: \(lb)")
        return (lb != self.endIndex) && !partitionPredicate(self[lb])
    }
    
}



// ======================================================================================================================
//
// MARK: - Array Extension
//
// ======================================================================================================================
extension Array {
    /// Returns `true` if the calling collection is sorted and `false` otherwise
    ///
    /// - Parameter comparator: Returns `true` if `lhs` is less than `rhs`, returns `false` otherwise
    ///
    /// - Complexity: O(n)
    ///
    /// - Returns: `true` if collection is sorted, `false` otherwise
    @warn_unused_result
    func isSorted(@noescape comparator: (lhs: Array.Element, rhs: Array.Element) -> Bool) -> Bool {
        var priorVal: Generator.Element?
        for x in self {
            guard let nonNilPriorVal = priorVal else {
                priorVal = x
                continue
            }
            if !comparator(lhs: nonNilPriorVal, rhs: x) {
                return false
            }
        }
        // If executions reaches this point, collection must be sorted
        return true
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

print(sortedArray.isSorted { $0 < $1 })
print(unsortedArray.isSorted { $0 < $1 })
print(testDict)
print(testDict.sort {$0.0 < $1.0})
print(testSet.sort())
print(testDict.keys)
print(testDict.keys.sort({ (lhs, rhs) -> Bool in
    return lhs < rhs
}).isSorted{ $0 < $1 })
print("Sorted array is now: \(sortedArray)")

let lower = sortedArray.lowerBound { $0 <= 3 }
print("Lower is \(lower)")

let upper = sortedArray.upperBound { $0 <= 3 }
print("Upper is \(upper)")

print("sortedArray contains 2: \(sortedArray.binarySearch{ $0 <= 2 })")
print("sortedArray contains 5: \(sortedArray.binarySearch {$0 < 5})")

let testArray1 = [4, 5, 9, 10, 19, 22, 24]
let testLower1 = testArray1.lowerBound { $0 <= 9 }
let testUpper1 = testArray1.upperBound { $0 <= 9 }
print("For array: \(testArray1)\nLower bound for 9: \(testLower1)\nUpper bound for 9: \(testUpper1)")

let testArray2 = [4, 5, 10, 19, 22, 24]
let testLower2 = testArray1.lowerBound { $0 <= 9 }
let testUpper2 = testArray1.upperBound { $0 <= 9 }
print("For array: \(testArray2)\nLower bound for 9: \(testLower2)\nUpper bound for 9: \(testUpper2)")
