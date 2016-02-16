// ======================================================================================================================
//
// MARK: - Collection Extension
//
// ======================================================================================================================

extension CollectionType {
	/// Returns an index such that each element at or above the indes is not less than the partition predicate
	///
	/// - Parameter isOrderedBelow: The partioning predicate. Returns `true` for elements in the collection that are
	///                             ordered below, with respet to the partitioning predicate.
	/// - Complexity: O(lg(n))
	///
	/// - Returns: An index such that each element evaluates as `false` with respect to `isOrderedBelow(_:)`
	@warn_unused_result
    func lowerBound(@noescape isOrderedBelow: (partitioningValue: Self.Generator.Element) -> Bool) -> Index {
		assertionFailure("Not implemented")
	}
	
	/// Returns an index such that each element below the index is strictly less than the partition predicate
	///
	/// - Parameter isOrderedBelow: The partioning predicate. Returns `true` for elements in the collection that are
	///                             ordered below, with respet to the partitioning predicate.
	/// - Complexity: O(lg(n))
	///
	/// - Returns: An index such that each element evaluates as `false` with respect to `isOrderedBelow(_:)`
	@warn_unused_result
	func upperBound(@noescape isOrderedBelow: (partitioningValue: Self.Generator.Element) -> Bool) -> Index {
		assertionFailure("Not implemented")
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
	
    /// Returns a collection such that each element in the collection is greater than or equal to `value`
    ///
    /// - Parameter value: The value that is less than or equal to all elements in the returned collection
	/// - Parameter comparator: Returns `true` if `lhs` is less than `rhs`, returns `false` otehrwise
	///
    /// - Requires: The calling collection is expected to be sorted
	///
    /// - Complexity: O(lg(n))
    ///
    /// - Returns: The index of the element that provides a lower bound the the elements in the calling array
    @warn_unused_result
    func lowerBound(value: Array.Element, @noescape comparator: (lhs: Array.Element, rhs: Array.Element) -> Bool) -> Int {
        // WARN: Should we check `isSorted` here?
        precondition(self.isSorted(comparator), "The calling CollectionType must be sorted")
        
        var len = self.count
        var firstIndex = 0
        while len > 0 {
            let half = len >> 1
            let tmpIndex = firstIndex.advancedBy(half)
            if comparator(lhs:self[tmpIndex], rhs:value) {
                firstIndex = tmpIndex.advancedBy(1)
                len = len - half - 1
            } else {
                len = half
            }
        }
        return firstIndex
    }
    
    /// Returns a collection such that each element in the collection is strictly less than `value`
    ///
    /// - Parameter value: The value that is strictly greater than all elements in the array
	///
    /// - Requires: The calling collection is expected to be sorted
	///
    /// - Complexity: O(lg(n))
    ///
    /// - Returns: An array whose elements are all strictly less than `value`
    @warn_unused_result
    func upperBound(value: Array.Element, @noescape comparator: (lhs: Array.Element, rhs: Array.Element) -> Bool) -> Int {
		
        var len = self.count
        var firstIndex = 0
        while len > 0 {
            let half = len >> 1
            let tmpIndex = firstIndex.advancedBy(half)
            if comparator(lhs:value, rhs:self[tmpIndex]) {
                len = half
            } else {
                firstIndex = tmpIndex.advancedBy(1)
                len = len - half - 1
            }
        }
        return firstIndex
    }
	
	@warn_unused_result
	func equalRange(value: Array.Element, @noescape comparator: (lhs: Array.Element, rhs: Array.Element) -> Bool) -> Range<Int>? {
		assertionFailure("Not implemented yet")
		return nil
	}
    
    // ------------------------------------------------------------------------------------------------------------------
    //
    // MARK: Binary Search Signatures
    //
    // ------------------------------------------------------------------------------------------------------------------
    
    
    @warn_unused_result
    func binarySearch(value: Array.Element, @noescape comparator:(lhs: Array.Element, rhs: Array.Element) -> Bool) -> Bool {
        let lb = lowerBound(value, comparator: comparator)
        return lb != self.count && !comparator(lhs: value, rhs: self[lb])
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

let lower = sortedArray.lowerBound(3) { $0 < $1 }
print("Lower is \(lower)")
print("Sorted array is now: \(sortedArray)")
let upper = sortedArray.upperBound(3) { $0 < $1 }
print("Upper is \(upper)")

print("sortedArray contains 2: \(sortedArray.binarySearch(2){ $0 < $1 })")
print("sortedArray contains 5: \(sortedArray.binarySearch(5){$0 < $1})")
