import Foundation
import Kitura
import DotEnv
import SwiftyJSON
import LoggerAPI
import HeliumLogger
import HaCTML

func getWebsiteRouter() -> Router {
  let router = Router()

  router.all("/static", middleware: StaticFileServer(path: "./static/dist"))

  router.get("/", handler: LandingPageController.handler)

  router.get("/workshops") { _, response, next in
    try response.send(
      UI.Pages.workshops(workshops: WorkshopManager.workshops).render()
    ).end()
    next()
  }

  /// Intended for use by GitHub webhooks
  router.post("/api/refresh_workshops") { _, _, _ in
    try WorkshopManager.update()
  }

  return router
}

public func serveWebsite() {
  // Helium logger provides logging for Kitura processes
  HeliumLogger.use()
  // This speaks to Kitura's 'LoggerAPI' to set the default logger to HeliumLogger.
  // Kitura calls this API to log things

  Kitura.addHTTPServer(onPort: Config.listeningPort, with: getWebsiteRouter())
  Kitura.run() // This call never returns
}
