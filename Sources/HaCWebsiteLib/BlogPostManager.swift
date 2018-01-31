import Foundation
import SwiftyRequest
import SwiftyJSON

public struct BlogPostManager {
  public private(set) static var blogPosts: [BlogPost] = []

  public static func update() {
    let request = RestRequest(method: .get, url: "https://medium.com/hackers-at-cambridge?format=json")
    request.responseString { response in
      switch response.result {
      case .success(let result):
        // Medium prepends all JSONs with a while(1) to stop malicious execution (https://stackoverflow.com/a/2669766)
        let cleanJSONString = result.replacingOccurrences(of: "])}while(1);</x>", with: "")

        let json = JSON.parse(string: cleanJSONString)

        guard let streamItems = json["payload"]["streamItems"].array else {
          print("Not found!")
          return
        }

        let postIds = streamItems
          .flatMap({ $0["section"]["items"].arrayValue })
          .flatMap({ $0["post"]["postId"].string })

        let postJSONs = postIds
          .map({ (postId: JSON) -> JSON in
            var post = json["payload"]["references"]["Post"][postId]
            post["creator"] = json["payload"]["references"]["User"][post["creatorId"]]
            return post
          }) // Populate post information

        postJSONs.forEach { print(">>>>Found post id \($0)") }

        // let posts = json//["streamItems"]//[0]["section"]["items"]

        // print("Success \(json)")

      case .failure(let error):
        print("Failure \(error)")
      }
    }
  }
}
