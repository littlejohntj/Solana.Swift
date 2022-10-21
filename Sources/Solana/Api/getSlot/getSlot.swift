import Foundation

public extension Api {
    /// Returns the slot that has reached the given or default commitment level
    /// - Parameters:
    ///   - commitment: The commitment describes how finalized a block is at that point in time. (finalized, confirmed, processed)
    ///   - onComplete: Result of Current slot UInt64
    func getSlot(commitment: Commitment? = nil, onComplete: @escaping (Result<UInt64, Error>) -> Void) {
        router.request(parameters: [RequestConfiguration(commitment: commitment)]) { (result: Result<UInt64, Error>) in
            switch result {
            case .success(let slot):
                onComplete(.success(slot))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Api {
    /// Returns the slot that has reached the given or default commitment level
    /// - Parameters:
    ///   - commitment: The commitment describes how finalized a block is at that point in time. (finalized, confirmed, processed)
    /// - Returns: Result of Current slot UInt64
    func getSlot(commitment: Commitment? = nil) async throws -> UInt64 {
        try await withCheckedThrowingContinuation { c in
            self.getSlot(commitment: commitment, onComplete: c.resume(with:))
        }
    }
}

public extension ApiTemplates {
    struct GetSlot: ApiTemplate {
        public init(commitment: Commitment? = nil) {
            self.commitment = commitment
        }
        
        public let commitment: Commitment?
        
        public typealias Success = UInt64
        
        public func perform(withConfigurationFrom apiClass: Api, completion: @escaping (Result<Success, Error>) -> Void) {
            apiClass.getSlot(commitment: commitment, onComplete: completion)
        }
    }
}
