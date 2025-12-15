import Foundation


final class AppInjector {
    
    static let shared = AppInjector()
    
    private init() {}
    
    func provideStockRepository() -> StockRepositoryDummyImpl {
        return StockRepositoryDummyImpl()
    }
    let mailService = MailServiceImpl()
}
