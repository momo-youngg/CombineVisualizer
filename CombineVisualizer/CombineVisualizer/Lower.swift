//
//  Lower.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/11.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZFilter {

    public func czFilter(_ isIncluded: @escaping (Publishers.Filter<Upstream>.Output) -> Bool) -> Publishers.CZFilter<Upstream> {
        return Publishers.CZFilter(inner: self.inner.filter(isIncluded), uuid: self.uuid)
    }

    public func czTryFilter(_ isIncluded: @escaping (Publishers.Filter<Upstream>.Output) throws -> Bool) -> Publishers.CZTryFilter<Upstream> {
        return Publishers.CZTryFilter(inner: self.inner.tryFilter(isIncluded), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZTryFilter {

    public func czFilter(_ isIncluded: @escaping (Publishers.TryFilter<Upstream>.Output) -> Bool) -> Publishers.CZTryFilter<Upstream> {
        return Publishers.CZTryFilter(inner: self.inner.filter(isIncluded), uuid: self.uuid)
    }

    public func czTryFilter(_ isIncluded: @escaping (Publishers.TryFilter<Upstream>.Output) throws -> Bool) -> Publishers.CZTryFilter<Upstream> {
        return Publishers.CZTryFilter(inner: self.inner.tryFilter(isIncluded), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZContains : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A contains publisher to compare for equality.
    ///   - rhs: Another contains publisher to compare for equality.
    /// - Returns: `true` if the two publishers’ `upstream` and `output` properties are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZContains<Upstream>, rhs: Publishers.CZContains<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCombineLatest : Equatable where A : Equatable, B : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A combineLatest publisher to compare for equality.
    ///   - rhs: Another combineLatest publisher to compare for equality.
    /// - Returns: `true` if the corresponding upstream publishers of each combineLatest publisher are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZCombineLatest<A, B>, rhs: Publishers.CZCombineLatest<A, B>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

/// Returns a Boolean value that indicates whether two publishers are equivalent.
///
/// - Parameters:
///   - lhs: A combineLatest publisher to compare for equality.
///   - rhs: Another combineLatest publisher to compare for equality.
/// - Returns: `true` if the corresponding upstream publishers of each combineLatest publisher are equal; otherwise `false`.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCombineLatest3 : Equatable where A : Equatable, B : Equatable, C : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Publishers.CZCombineLatest3<A, B, C>, rhs: Publishers.CZCombineLatest3<A, B, C>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

/// Returns a Boolean value that indicates whether two publishers are equivalent.
///
/// - Parameters:
///   - lhs: A combineLatest publisher to compare for equality.
///   - rhs: Another combineLatest publisher to compare for equality.
/// - Returns: `true` if the corresponding upstream publishers of each combineLatest publisher are equal; otherwise `false`.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCombineLatest4 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Publishers.CZCombineLatest4<A, B, C, D>, rhs: Publishers.CZCombineLatest4<A, B, C, D>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSetFailureType : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `SetFailureType` publisher to compare for equality.
    ///   - rhs: Another `SetFailureType` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `upstream` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZSetFailureType<Upstream, Failure>, rhs: Publishers.CZSetFailureType<Upstream, Failure>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCollect : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `Collect` instance to compare.
    ///   - rhs: Another `Collect` instance to compare.
    /// - Returns: `true` if the corresponding `upstream` properties of each publisher are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZCollect<Upstream>, rhs: Publishers.CZCollect<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCollectByCount : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `CollectByCount` instance to compare.
    ///   - rhs: Another `CollectByCount` instance to compare.
    /// - Returns: `true` if the corresponding `upstream` and `count` properties of each publisher are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZCollectByCount<Upstream>, rhs: Publishers.CZCollectByCount<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCompactMap {

    public func czCompactMap<T>(_ transform: @escaping (Output) -> T?) -> Publishers.CZCompactMap<Upstream, T> {
        return Publishers.CZCompactMap(inner: self.inner.compactMap(transform), uuid: self.uuid)
    }

    public func czMap<T>(_ transform: @escaping (Output) -> T) -> Publishers.CZCompactMap<Upstream, T> {
        return Publishers.CZCompactMap(inner: self.inner.map(transform), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZTryCompactMap {

    public func czCompactMap<T>(_ transform: @escaping (Output) throws -> T?) -> Publishers.CZTryCompactMap<Upstream, T> {
        return Publishers.CZTryCompactMap(inner: self.inner.compactMap(transform), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge : Equatable where A : Equatable, B : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality..
    /// - Returns: `true` if the two merging - rhs: Another merging publisher to compare for equality.
    public static func == (lhs: Publishers.CZMerge<A, B>, rhs: Publishers.CZMerge<A, B>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge3 : Equatable where A : Equatable, B : Equatable, C : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality.
    /// - Returns: `true` if the two merging publishers have equal source publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZMerge3<A, B, C>, rhs: Publishers.CZMerge3<A, B, C>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge4 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality.
    /// - Returns: `true` if the two merging publishers have equal source publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZMerge4<A, B, C, D>, rhs: Publishers.CZMerge4<A, B, C, D>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge5 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable, E : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality.
    /// - Returns: `true` if the two merging publishers have equal source publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZMerge5<A, B, C, D, E>, rhs: Publishers.CZMerge5<A, B, C, D, E>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge6 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable, E : Equatable, F : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality.
    /// - Returns: `true` if the two merging publishers have equal source publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZMerge6<A, B, C, D, E, F>, rhs: Publishers.CZMerge6<A, B, C, D, E, F>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge7 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable, E : Equatable, F : Equatable, G : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality.
    /// - Returns: `true` if the two merging publishers have equal source publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZMerge7<A, B, C, D, E, F, G>, rhs: Publishers.CZMerge7<A, B, C, D, E, F, G>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMerge8 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable, E : Equatable, F : Equatable, G : Equatable, H : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A merging publisher to compare for equality.
    ///   - rhs: Another merging publisher to compare for equality.
    /// - Returns: `true` if the two merging publishers have equal source publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZMerge8<A, B, C, D, E, F, G, H>, rhs: Publishers.CZMerge8<A, B, C, D, E, F, G, H>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMergeMany : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `MergeMany` publisher to compare for equality.
    ///   - rhs: Another `MergeMany` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `publishers` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZMergeMany<Upstream>, rhs: Publishers.CZMergeMany<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZCount : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///     /// - Parameters:
    ///   - lhs: A `Count` instance to compare.
    ///   - rhs: Another `Count` instance to compare.
    /// - Returns: `true` if the two publishers' `upstream` properties are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZCount<Upstream>, rhs: Publishers.CZCount<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZIgnoreOutput : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: An ignore output publisher to compare for equality.
    ///   - rhs: Another ignore output publisher to compare for equality.
    /// - Returns: `true` if the two publishers have equal upstream publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZIgnoreOutput<Upstream>, rhs: Publishers.CZIgnoreOutput<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZRetry : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `Retry` publisher to compare for equality.
    ///   - rhs: Another `Retry` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `upstream` and `retries` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZRetry<Upstream>, rhs: Publishers.CZRetry<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZReplaceEmpty : Equatable where Upstream : Equatable, Upstream.Output : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A replace empty publisher to compare for equality.
    ///   - rhs: Another replace empty publisher to compare for equality.
    /// - Returns: `true` if the two publishers have equal upstream publishers and output elements; otherwise `false`.
    public static func == (lhs: Publishers.CZReplaceEmpty<Upstream>, rhs: Publishers.CZReplaceEmpty<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZReplaceError : Equatable where Upstream : Equatable, Upstream.Output : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A replace error publisher to compare for equality.
    ///   - rhs: Another replace error publisher to compare for equality.
    /// - Returns: `true` if the two publishers have equal upstream publishers and output elements; otherwise `false`.
    public static func == (lhs: Publishers.CZReplaceError<Upstream>, rhs: Publishers.CZReplaceError<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZDropUntilOutput : Equatable where Upstream : Equatable, Other : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `Publishers.DropUntilOutput` instance to compare for equality.
    ///   - rhs: Another `Publishers.DropUntilOutput` instance to compare for equality.
    /// - Returns: `true` if the publishers have equal `upstream` and `other` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZDropUntilOutput<Upstream, Other>, rhs: Publishers.CZDropUntilOutput<Upstream, Other>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZConcatenate : Equatable where Prefix : Equatable, Suffix : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A concatenate publisher to compare for equality.
    ///   - rhs: Another concatenate publisher to compare for equality.
    /// - Returns: `true` if the two publishers’ `prefix` and `suffix` properties are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZConcatenate<Prefix, Suffix>, rhs: Publishers.CZConcatenate<Prefix, Suffix>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZLast : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A last publisher to compare for equality.
    ///   - rhs: Another last publisher to compare for equality.
    /// - Returns: `true` if the two publishers have equal upstream publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZLast<Upstream>, rhs: Publishers.CZLast<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZMap {

    public func czMap<T>(_ transform: @escaping (Output) -> T) -> Publishers.CZMap<Upstream, T> {
        return Publishers.CZMap(inner: self.inner.map(transform), uuid: self.uuid)
    }

    public func czTryMap<T>(_ transform: @escaping (Output) throws -> T) -> Publishers.CZTryMap<Upstream, T> {
        return Publishers.CZTryMap(inner: self.inner.tryMap(transform), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZTryMap {

    public func czMap<T>(_ transform: @escaping (Output) -> T) -> Publishers.CZTryMap<Upstream, T>{
        return Publishers.CZTryMap(inner: self.inner.map(transform), uuid: self.uuid)
    }

    public func czTryMap<T>(_ transform: @escaping (Output) throws -> T) -> Publishers.CZTryMap<Upstream, T> {
        return Publishers.CZTryMap(inner: self.inner.tryMap(transform), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Failure == Never {

    public func czMin(by areInIncreasingOrder: (Publishers.Sequence<Elements, Failure>.Output, Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.min(by: areInIncreasingOrder), uuid: self.uuid)
    }

    public func czMax(by areInIncreasingOrder: (Publishers.Sequence<Elements, Failure>.Output, Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.max(by: areInIncreasingOrder), uuid: self.uuid)
    }

    public func czFirst(where predicate: (Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.first(where: predicate), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence {

    public func czAllSatisfy(_ predicate: (Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Result<Bool, Failure>.CZPublisher {
        return Result<Bool, Failure>.CZPublisher(inner: self.inner.allSatisfy(predicate), uuid: self.uuid)
    }

    public func czTryAllSatisfy(_ predicate: (Publishers.Sequence<Elements, Failure>.Output) throws -> Bool) -> Result<Bool, Error>.CZPublisher {
        return Result<Bool, Error>.CZPublisher(inner: self.inner.tryAllSatisfy(predicate), uuid: self.uuid)
    }

    public func czCollect() -> Result<[Publishers.Sequence<Elements, Failure>.Output], Failure>.CZPublisher {
        return Result<[Publishers.Sequence<Elements, Failure>.Output], Failure>.CZPublisher(inner: self.inner.collect(), uuid: self.uuid)
    }

    public func czCompactMap<T>(_ transform: (Publishers.Sequence<Elements, Failure>.Output) -> T?) -> Publishers.CZSequence<[T], Failure> {
        return Publishers.CZSequence<[T], Failure>(inner: self.inner.compactMap(transform), uuid: self.uuid)
    }

    public func czContains(where predicate: (Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Result<Bool, Failure>.CZPublisher {
        return Result<Bool, Failure>.CZPublisher(inner: self.inner.contains(where: predicate), uuid: self.uuid)
    }

    public func czTryContains(where predicate: (Publishers.Sequence<Elements, Failure>.Output) throws -> Bool) -> Result<Bool, Error>.CZPublisher {
        return Result<Bool, Error>.CZPublisher(inner: self.inner.tryContains(where: predicate), uuid: self.uuid)
    }

    public func czDrop(while predicate: (Elements.Element) -> Bool) -> Publishers.CZSequence<DropWhileSequence<Elements>, Failure> {
        return Publishers.CZSequence<DropWhileSequence<Elements>, Failure>(inner: self.inner.drop(while: predicate), uuid: self.uuid)
    }

    public func czDropFirst(_ count: Int = 1) -> Publishers.CZSequence<DropFirstSequence<Elements>, Failure> {
        return Publishers.CZSequence<DropFirstSequence<Elements>, Failure>(inner: self.inner.dropFirst(count), uuid: self.uuid)
    }

    public func czFilter(_ isIncluded: (Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure> {
        return Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure>(inner: self.inner.filter(isIncluded), uuid: self.uuid)
    }

    public func czIgnoreOutput() -> CZEmpty<Publishers.Sequence<Elements, Failure>.Output, Failure> {
        return CZEmpty<Publishers.Sequence<Elements, Failure>.Output, Failure>(inner: self.inner.ignoreOutput(), uuid: self.uuid)
    }

    public func czMap<T>(_ transform: (Elements.Element) -> T) -> Publishers.CZSequence<[T], Failure> {
        return Publishers.CZSequence<[T], Failure>(inner: self.inner.map(transform), uuid: self.uuid)
    }

    public func czPrefix(_ maxLength: Int) -> Publishers.CZSequence<PrefixSequence<Elements>, Failure> {
        return Publishers.CZSequence<PrefixSequence<Elements>, Failure>(inner: self.inner.prefix(maxLength), uuid: self.uuid)
    }

    public func czPrefix(while predicate: (Elements.Element) -> Bool) -> Publishers.CZSequence<[Elements.Element], Failure> {
        return Publishers.CZSequence<[Elements.Element], Failure>(inner: self.inner.prefix(while: predicate), uuid: self.uuid)
    }

    public func czReduce<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Publishers.Sequence<Elements, Failure>.Output) -> T) -> Result<T, Failure>.CZPublisher {
        return Result<T, Failure>.CZPublisher(inner: self.inner.reduce(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func czTryReduce<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Publishers.Sequence<Elements, Failure>.Output) throws -> T) -> Result<T, Error>.CZPublisher {
        return Result<T, Error>.CZPublisher(inner: self.inner.tryReduce(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func czReplaceNil<T>(with output: T) -> Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure> where Elements.Element == T? {
        return Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure>(inner: self.inner.replaceNil(with: output), uuid: self.uuid)
    }

    public func czScan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Publishers.Sequence<Elements, Failure>.Output) -> T) -> Publishers.CZSequence<[T], Failure> {
        return Publishers.CZSequence<[T], Failure>(inner: self.inner.scan(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func czSetFailureType<E>(to error: E.Type) -> Publishers.CZSequence<Elements, E> where E : Error {
        return Publishers.CZSequence<Elements, E>(inner: self.inner.setFailureType(to: error), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements.Element : Equatable {

    public func czRemoveDuplicates() -> Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure> {
        return Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure>(inner: self.inner.removeDuplicates(), uuid: self.uuid)
    }

    public func czContains(_ output: Elements.Element) -> Result<Bool, Failure>.CZPublisher {
        return Result<Bool, Failure>.CZPublisher(inner: self.inner.contains(output), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Failure == Never, Elements.Element : Comparable {

    public func czMin() -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.min(), uuid: self.uuid)
    }

    public func czMax() -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.max(), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : Collection, Failure == Never {

    public func czFirst() -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.first(), uuid: self.uuid)
    }

    public func czOutput(at index: Elements.Index) -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.output(at: index), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : Collection {

    public func czCount() -> Result<Int, Failure>.CZPublisher {
        return Result<Int, Failure>.CZPublisher(inner: self.inner.count(), uuid: self.uuid)
    }

    public func czOutput(in range: Range<Elements.Index>) -> Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure> {
        return Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure>(inner: self.inner.output(in: range), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : BidirectionalCollection, Failure == Never {

    public func czLast() -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.last(), uuid: self.uuid)
    }

    public func czLast(where predicate: (Publishers.Sequence<Elements, Failure>.Output) -> Bool) -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.last(where: predicate), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : RandomAccessCollection, Failure == Never {

    public func czOutput(at index: Elements.Index) -> Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher {
        return Optional<Publishers.Sequence<Elements, Failure>.Output>.CZPublisher(inner: self.inner.output(at: index), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : RandomAccessCollection {

    public func czOutput(in range: Range<Elements.Index>) -> Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure> {
        return Publishers.CZSequence<[Publishers.Sequence<Elements, Failure>.Output], Failure>(inner: self.inner.output(in: range), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : RandomAccessCollection, Failure == Never {

    public func czCount() -> CZJust<Int> {
        return CZJust<Int>(inner: self.inner.count(), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : RandomAccessCollection {

    public func czCount() -> Result<Int, Failure>.CZPublisher {
        return Result<Int, Failure>.CZPublisher(inner: self.inner.count(), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence where Elements : RangeReplaceableCollection {

    public func czPrepend(_ elements: Publishers.Sequence<Elements, Failure>.Output...) -> Publishers.CZSequence<Elements, Failure> {
        return Publishers.CZSequence<Elements, Failure>(inner: self.inner.prepend(elements), uuid: self.uuid)
    }

    public func czPrepend<S>(_ elements: S) -> Publishers.CZSequence<Elements, Failure> where S : Sequence, Elements.Element == S.Element {
        return Publishers.CZSequence<Elements, Failure>(inner: self.inner.prepend(elements), uuid: self.uuid)
    }

    public func czPrepend(_ publisher: Publishers.Sequence<Elements, Failure>) -> Publishers.CZSequence<Elements, Failure> {
        return Publishers.CZSequence<Elements, Failure>(inner: self.inner.prepend(publisher), uuid: self.uuid)
    }

    public func czAppend(_ elements: Publishers.Sequence<Elements, Failure>.Output...) -> Publishers.CZSequence<Elements, Failure> {
        return Publishers.CZSequence<Elements, Failure>(inner: self.inner.append(elements), uuid: self.uuid)
    }

    public func czAppend<S>(_ elements: S) -> Publishers.CZSequence<Elements, Failure> where S : Sequence, Elements.Element == S.Element {
        return Publishers.CZSequence<Elements, Failure>(inner: self.inner.append(elements), uuid: self.uuid)
    }

    public func czAppend(_ publisher: Publishers.Sequence<Elements, Failure>) -> Publishers.CZSequence<Elements, Failure> {
        return Publishers.CZSequence<Elements, Failure>(inner: self.inner.append(publisher), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZSequence : Equatable where Elements : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `Sequence` publisher to compare for equality.
    ///   - rhs: Another `Sequewnce` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `sequence` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZSequence<Elements, Failure>, rhs: Publishers.CZSequence<Elements, Failure>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZZip : Equatable where A : Equatable, B : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A zip publisher to compare for equality.
    ///   - rhs: Another zip publisher to compare for equality.
    /// - Returns: `true` if the corresponding upstream publishers of each zip publisher are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZZip<A, B>, rhs: Publishers.CZZip<A, B>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZZip3 : Equatable where A : Equatable, B : Equatable, C : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A zip publisher to compare for equality.
    ///   - rhs: Another zip publisher to compare for equality.
    /// - Returns: `true` if the corresponding upstream publishers of each zip publisher are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZZip3<A, B, C>, rhs: Publishers.CZZip3<A, B, C>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZZip4 : Equatable where A : Equatable, B : Equatable, C : Equatable, D : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: A zip publisher to compare for equality.
    ///   - rhs: Another zip publisher to compare for equality.
    /// - Returns: `true` if the corresponding upstream publishers of each zip publisher are equal; otherwise `false`.
    public static func == (lhs: Publishers.CZZip4<A, B, C, D>, rhs: Publishers.CZZip4<A, B, C, D>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZOutput : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: An `Output` publisher to compare for equality.
    ///   - rhs: Another `Output` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `upstream` and `range` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZOutput<Upstream>, rhs: Publishers.CZOutput<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZDrop : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A drop publisher to compare for equality.
    ///   - rhs: Another drop publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `upstream` and `count` properties; otherwise `false`.
    public static func == (lhs: Publishers.CZDrop<Upstream>, rhs: Publishers.CZDrop<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CZFirst : Equatable where Upstream : Equatable {

    /// Returns a Boolean value that indicates whether two first publishers have equal upstream publishers.
    ///
    /// - Parameters:
    ///   - lhs: A drop publisher to compare for equality.
    ///   - rhs: Another drop publisher to compare for equality.
    /// - Returns: `true` if the two publishers have equal upstream publishers; otherwise `false`.
    public static func == (lhs: Publishers.CZFirst<Upstream>, rhs: Publishers.CZFirst<Upstream>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

/// A publisher that allows for recording a series of inputs and a completion, for later playback to each subscriber.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CZRecord<Output, Failure> : CZPublisher where Failure : Error {

    /// The recorded output and completion.
    public let recording: Record<Output, Failure>.Recording
    
    public let inner: Record<Output, Failure>
    public let uuid: UUID
    
    public init(inner: Record<Output, Failure>, uuid: UUID) {
        self.recording = inner.recording
        self.inner = inner
        self.uuid = uuid
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Optional {

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public var czPublisher: Optional<Wrapped>.CZPublisher {
        return CZPublisher(inner: self.publisher, uuid: UUID())
    }

    /// The type of a Combine publisher that publishes the value of a Swift optional instance to each subscriber exactly once, if the instance has any value at all.
    ///
    /// In contrast with the ``Combine/Just`` publisher, which always produces a single value, this publisher might not send any values and instead finish normally, if ``output`` is `nil`.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct CZPublisher : CombineVisualizer.CZPublisher {

        /// The kind of value published by this publisher.
        ///
        /// This publisher produces the type wrapped by the optional.
        public typealias Output = Wrapped

        /// The kind of error this publisher might publish.
        ///
        /// The optional publisher never produces errors.
        public typealias Failure = Never

        /// The output to deliver to each subscriber.
        public let output: Optional<Wrapped>.Publisher.Output?
        
        public let inner: Optional<Wrapped>.Publisher
        public let uuid: UUID

        public init(inner: Optional<Wrapped>.Publisher, uuid: UUID) {
            self.output = inner.output
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Result {

    /// A Combine publisher that publishes this instance’s result to each subscriber exactly once, or fails immediately if the result indicates failure.
    ///
    /// In the following example, `goodResult` provides a successful result with the integer value `1`. A sink subscriber connected to the result's publisher receives the output `1`, followed by a normal completion (``Combine/Subscribers/Completion/finished``).
    ///
    ///      let goodResult: Result<Int, MyError> = .success(1)
    ///      goodResult.publisher
    ///          .sink(receiveCompletion: { print("goodResult done: \($0)")},
    ///                receiveValue: { print("goodResult value: \($0)")} )
    ///      // Prints:
    ///      // goodResult value: 1
    ///      // goodResult done: finished
    ///
    /// In contrast with the ``Combine/Just`` publisher, which always publishes a single value, this publisher might not send any values and instead terminate with an error, if the result is <doc://com.apple.documentation/documentation/Swift/Result/failure>. In the next example, `badResult` is a failure result that wraps a custom error. A sink subscriber connected to this result's publisher immediately receives a termination (``Combine/Subscribers/Completion/failure(_:)``).
    ///
    ///      struct MyError: Error, CustomDebugStringConvertible {
    ///          var debugDescription: String = "MyError"
    ///      }
    ///      let badResult: Result<Int, MyError> = .failure(MyError())
    ///      badResult.publisher
    ///          .sink(receiveCompletion: { print("badResult done: \($0)")},
    ///                receiveValue: { print("badResult value: \($0)")} )
    ///      // Prints:
    ///      // badResult done: failure(MyError)
    ///
    public var czPublisher: Result<Success, Failure>.CZPublisher {
        return CZPublisher(inner: self.publisher, uuid: UUID())
    }

    /// The type of a Combine publisher that publishes this instance’s result to each subscriber exactly once, or fails immediately if the result indicates failure.
    ///
    /// If the result is <doc://com.apple.documentation/documentation/Swift/Result/success>, then the publisher waits until it receives a request for at least one value, then sends the output to all subscribers and finishes normally. If the result is <doc://com.apple.documentation/documentation/Swift/Result/failure>, then the publisher sends the failure immediately upon subscription. This latter behavior is a contrast with ``Combine/Just``, which always publishes a single value.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct CZPublisher : CombineVisualizer.CZPublisher {

        /// The kind of values published by this publisher.
        public typealias Output = Success

        /// The result to deliver to each subscriber.
        public let result: Result<Result<Success, Failure>.Publisher.Output, Failure>
        
        public let inner: Result<Success, Failure>.Publisher
        public let uuid: UUID
        
        public init(inner: Result<Success, Failure>.Publisher, uuid: UUID) {
            self.result = inner.result
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Sequence {

    public var czPublisher: Publishers.CZSequence<Self, Never> {
        return Publishers.CZSequence(inner: self.publisher, uuid: self.publisher.generateUUID())
    }
}
