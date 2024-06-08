//
//  OllamaKit+Chat.swift
//
//
//  Created by Kevin Hermawan on 02/01/24.
//

import Combine
import Foundation

extension OllamaKit {
    /// Establishes an asynchronous stream for chat responses from the Ollama API, based on the provided data.
    ///
    /// This method sets up a streaming connection using Swift's concurrency features, allowing for real-time data handling as chat responses are generated by the Ollama API.
    ///
    /// ```swift
    /// let ollamaKit = OllamaKit()
    /// let chatData = OKChatRequestData(/* parameters */)
    ///
    /// Task {
    ///     do {
    ///         for try await response in ollamaKit.chat(data: chatData) {
    ///             // Handle each chat response
    ///         }
    ///     } catch {
    ///         // Handle error
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter data: The ``OKChatRequestData`` used to initiate the chat streaming from the Ollama API.
    /// - Returns: An `AsyncThrowingStream<OKChatResponse, Error>` emitting the live stream of chat responses from the Ollama API.
    public func chat(data: OKChatRequestData) -> AsyncThrowingStream<OKChatResponse, Error> {
        do {
            let request = try OKRouter.chat(data: data).asURLRequest()
            
            return OKHTTPClient.shared.stream(request: request, with: OKChatResponse.self)
        } catch {
            return AsyncThrowingStream { continuation in
                continuation.finish(throwing: error)
            }
        }
    }
    
    /// Establishes a Combine publisher for streaming chat responses from the Ollama API, based on the provided data.
    ///
    /// This method sets up a streaming connection using the Combine framework, facilitating real-time data handling as chat responses are generated by the Ollama API.
    ///
    /// ```swift
    /// let ollamaKit = OllamaKit()
    /// let chatData = OKChatRequestData(/* parameters */)
    ///
    /// ollamaKit.chat(data: chatData)
    ///     .sink(receiveCompletion: { completion in
    ///         // Handle completion or error
    ///     }, receiveValue: { chatResponse in
    ///         // Handle each chat response
    ///     })
    ///     .store(in: &cancellables)
    /// ```
    ///
    /// - Parameter data: The ``OKChatRequestData`` used to initiate the chat streaming from the Ollama API.
    /// - Returns: An `AnyPublisher<OKChatResponse, Error>` emitting the live stream of chat responses from the Ollama API.
    public func chat(data: OKChatRequestData) -> AnyPublisher<OKChatResponse, Error> {
        do {
            let request = try OKRouter.chat(data: data).asURLRequest()
            
            return OKHTTPClient.shared.stream(request: request, with: OKChatResponse.self)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
