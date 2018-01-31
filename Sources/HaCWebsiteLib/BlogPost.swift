import Foundation

public struct BlogPost: Codable {
  let title: String
  let subtitle: String
  let url: String
  let datePublished: Date
  let previewImageURL: URL
  let author: String
}
