//
//  MessageDecoding.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

extension Message: Decodable {
    enum CodingKeys: CodingKey { case id, message, progress, state }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        content = try {
            let message = try container.decode(
                String.self,
                forKey: CodingKeys.message)
            switch message {
            case "progress":
                return .inProgress(
                    progress: try container.decode(
                        Double.self,
                        forKey: .progress))
            case "completed":
                return .completed(
                    state: try container.decode(
                        String.self,
                        forKey: .state))
            default:
                // The documentation specifies that `message` can only be either
                //  `progress` or `completed`.
                throw DecodingError.dataCorruptedError(
                    forKey: .message,
                    in: container,
                    debugDescription: "Unrecognized message: " + message)
            }
        }()
    }
}
