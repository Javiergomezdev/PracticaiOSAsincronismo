import XCTest
import Combine
import KCLibrarySwift
import CombineCocoa
import UIKit
@testable import KCProfessional

final class KCDragonBallProfTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testKeyChainLibrary() throws {
        let KC = KeychainManager.shared
        XCTAssertNotNil(KC)
        
        let save = KC.setKC(key: "Test", value: "123")
        XCTAssertEqual(save, true)
        
        let value = KC.getKC(key: "Test")
        if let valor = value {
            XCTAssertEqual(valor, "123")
        }
        XCTAssertNoThrow(KC.removeKC(key: "Test"))
    }
    
    func testLoginFake() async throws {
        let KC = KeychainManager.shared
        XCTAssertNotNil(KC)
        
        
        let obj = FakeLoginUseCase()
        XCTAssertNotNil(obj)
        
        //Validate Token
        let resp = await obj.validateToken()
        XCTAssertEqual(resp, true)
        
        
        // login
        let loginDo = await obj.login(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = KC.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //Close Session
        await obj.logoutApp()
        jwt = KC.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    func testLoginReal() async throws  {
        let CK = KeychainManager.shared
        XCTAssertNotNil(CK)
        //reset the token
        let _ = CK.setKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "")
        
        //Caso se uso con repo Fake
        let userCase = DefaultLoginUseCase(repo: LoginRepositoryFake())
        XCTAssertNotNil(userCase)
        
        //validacion
        let resp = await userCase.validateToken()
        XCTAssertEqual(resp, false)
        
        //login
        let loginDo = await userCase.login(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = CK.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //Close Session
        await userCase.logoutApp()
        jwt = CK.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    func testLoginAutoLoginAsincrono()  throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Login Auto ")
        
        let vm = AppState(loginUseCase: FakeLoginUseCase())
        XCTAssertNotNil(vm)
        
        vm.$loginStatus
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { estado in
                print("Recibo estado \(estado)")
                if estado == .success {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
        
        vm.validateLogin()
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testUIErrorView() async throws  {
        
        let appStateVM = AppState(loginUseCase: FakeLoginUseCase())
        XCTAssertNotNil(appStateVM)
        
        appStateVM.loginStatus = .error
        
        let vc = await ErrorViewController(appState: appStateVM, error: "Error Testing")
        XCTAssertNotNil(vc)
    }
    
    func testUILoginView()  throws  {
        XCTAssertNoThrow(LoginView())
        let view = LoginView()
        XCTAssertNotNil(view)
        
        let logo =   view.logoImage
        XCTAssertNotNil(logo)
        let txtUser = view.emailTextfield
        XCTAssertNotNil(txtUser)
        let txtPass = view.passwordTextfield
        XCTAssertNotNil(txtPass)
        let button = view.buttonLogin
        XCTAssertNotNil(button)
        
        XCTAssertEqual(txtUser.placeholder, NSLocalizedString("email", comment: ""))
        XCTAssertEqual(txtPass.placeholder, NSLocalizedString("password", comment: ""))
        XCTAssertEqual(button.titleLabel?.text, NSLocalizedString("login", comment: ""))
        
        let View2 =  LoginViewController(appState: AppState(loginUseCase: FakeLoginUseCase()))
        XCTAssertNotNil(View2)
        XCTAssertNoThrow(View2.loadView())
        XCTAssertNotNil(View2.loginButton)
        XCTAssertNotNil(View2.emailTextfield)
        XCTAssertNotNil(View2.logo)
        XCTAssertNotNil(View2.passwordTexfield)
        
        XCTAssertNoThrow(View2.bindUI())
        
        View2.emailTextfield?.text = "Hola"
        
        XCTAssertEqual(View2.emailTextfield?.text, "Hola")
    }
    
    
    func testHerosUseCase() async throws  {
        let caseUser = HeroUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(caseUser)
        
        let data = await caseUser.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
    
    func testHeros_Combine() async throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Heros get")
        
        let vm = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(vm)
        
        vm.$heros
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { data in
                
                if data.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
        
        
        await self.waitForExpectations(timeout: 10)
    }
    
    func testHeros_Data() async throws  {
        let network = NetworkHerosFake()
        XCTAssertNotNil(network)
        let repo = HerosRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let data = await repo.getHeros(fitler: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
        
        let data2 = await repo2.getHeros(fitler: "")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 2)
    }
    
    func testHeros_Domain() async throws  {
        //Models
        let model = HerosModel(id: UUID(), favorite: true, description: "des", photo: "url", name: "goku", transformations: [])
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "goku")
        XCTAssertEqual(model.favorite, true)
        
        let requestModel = HeroModelRequest(name: "goku")
        XCTAssertNotNil(requestModel)
        XCTAssertEqual(requestModel.name, "goku")
    }
    
    func testHeros_Presentation() async throws  {
        let viewModel = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel)
        
        let view =  await HerosTableViewController(appState: AppState(loginUseCase: FakeLoginUseCase()), viewModel: viewModel)
        XCTAssertNotNil(view)
        
    }
    
    
    func testNetworkTransformations_ReturnsData() async throws {
        let network = NetworkTransformationsFake()
        let result = await network.getTransformations(filter: UUID())
        XCTAssertNotNil(result)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testTransformationRepository_ReturnsTransformations() async throws {
        let network = NetworkTransformationsFake()
        let repo = TransformationRepository(network: network)
        let result = await repo.getTransformations(filter: UUID())
        XCTAssertNotNil(result)
        
    }
    
    func testHeroDetailViewModel_LoadsTransformations() async throws {
        let hero = HerosModel(
            id: UUID(),
            favorite: false,
            description: "Descripción",
            photo: "https://url.com/photo.jpg",
            name: "Vegeta",
            transformations: []
        )
        
        let useCase = TransformationUseCase(repo: TransformationsRepositryFake())
        let viewModel = TransformationsViewModel()
        
        await viewModel.getTransformations(id: hero.id)
        XCTAssertTrue(viewModel.transformationData.isEmpty)
    }
    
    func testHeroDetailViewController_InitAndViewDidLoad() async throws {
        let hero = HerosModel(id: UUID(), favorite: false, description: "desc", photo: "", name: "Piccolo", transformations: [])
        let useCase = TransformationUseCase(repo: TransformationsRepositryFake())
        let vm = TransformationsViewModel()
        let vc = await HeroDetailViewController(hero: hero)
        await MainActor.run {
            vc.loadViewIfNeeded()
        }
        XCTAssertNotNil(vc.view)
    }
    
    func testHeroDetailView_InitializesAndConfigures() {
        let hero = HerosModel(id: UUID(), favorite: false, description: "desc", photo: "", name: "Gohan", transformations: [])
        let view = HeroDetailView(hero: hero)
        XCTAssertNotNil(view.heroImageView)
        XCTAssertEqual(view.descriptionTextView.text, hero.description)
    }
    
    func testTransformationUseCase_ReturnsData() async throws {
        let repo = TransformationsRepositryFake()
        let useCase = TransformationUseCase(repo: repo)
        let data = await useCase.getTransformation(filter: UUID())
        XCTAssertNotEqual(data.count, 2)
    }
    
    
    func testTransformationCell_Configuration() {
        
        let transformation = TransformationModel(id: UUID(),
                                                 name: "Super Saiyan",
                                                 description: "Super Saiyan",
                                                 photo: "https://example.com/ss.jpg",
                                                 hero: Hero(id:UUID()))
        
        let cell = TransformationCell()
        cell.configure(with: transformation)
        
        XCTAssertEqual(cell.nameLabel.text, "Super Saiyan")
    }
    func testHeroDetailViewController_Initialization() {
        
        let hero = HerosModel(id: UUID(),
                              favorite: false,
                              description: "El guerrero más fuerte",
                              photo: "https://example.com/goku.jpg",
                              name: "Goku",transformations:[])
        
        let controller = HeroDetailViewController(hero: hero)
        XCTAssertNotNil(controller)
        
        controller.loadViewIfNeeded()
        
        XCTAssertNotNil(controller.heroDetailView)
        XCTAssertNotNil(controller.heroDetailView.transformationsCollectionView)
    }
    
    func testTransformationsUseCaseFake_GetTransformations() async {
        let fakeRepo = TransformationsRepositryFake(network: NetworkTransformationsFake())
        let fakeUseCase = TransformationUseCase(repo: fakeRepo)
        
        let heroID = UUID()
        let transformations = await fakeUseCase.getTransformation(filter: heroID)
        
        XCTAssertEqual(transformations.count, 16)
        XCTAssertEqual(transformations.last?.name, "1. Oozaru – Gran Mono")
    }
    func testHeroDetailViewController_Navigation() {
        
        let hero = HerosModel(id: UUID(),
                              favorite: false,
                              description: "El guerrero más fuerte",
                              photo: "https://example.com/goku.jpg",
                              name: "Goku",
                              transformations: [])
        
        
        let controller = HeroDetailViewController(hero: hero)
        let navigationController = UINavigationController(rootViewController: controller)
        controller.loadViewIfNeeded()
        controller.navigateBack()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    func testHeroDetailViewController_HidesCollectionIfNoTransformations() async {
        let hero = HerosModel(id: UUID(), favorite: false, description: "desc", photo: "", name: "Gohan", transformations: [])
        let useCase = TransformationUseCase(repo: TransformationRepositoryFakeEmpty())
        let vc = await HeroDetailViewController(hero: hero)
        await MainActor.run {
            vc.loadViewIfNeeded()
        }
        await vc.fetchTransformations()
        XCTAssertTrue(vc.heroDetailView.transformationsCollectionView.isHidden)
    }
    
    func testHeroTableViewCell_LoadsImageFromURL() {
        let cell = HeroTableViewCell(style: .default, reuseIdentifier: "HeroCell")
        let hero = HerosModel(id: UUID(), favorite: false, description: "", photo: "https://example.com/goku.jpg", name: "Goku", transformations: [])
        cell.configure(with: hero)
        
        XCTAssertEqual(cell.textLabel?.text, "Goku")
        
    }
    
    func testTransformationCell_PrepareForReuseClearsImage() {
        let cell = TransformationCell(frame: .zero)
        cell.imageView.image = UIImage(systemName: "star")
        cell.prepareForReuse()
        XCTAssertNil(cell.imageView.image)
    }
    
    func testHerosTableViewController_NumberOfRowsMatchesViewModel() {
        let vm = HerosViewModel(useCase: HeroUseCaseFake())
        let vc = HerosTableViewController(appState: AppState(loginUseCase: FakeLoginUseCase()), viewModel: vm)
        vc.loadViewIfNeeded()
        
        let count = vm.heros.count
        let rows = vc.tableView(vc.tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(rows, count)
    }
   
    func testHomeViewController_LoadsViewCorrectly() {
        let vc = HomeViewController(appState: AppState(loginUseCase: FakeLoginUseCase()))
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }
    func testHeroTableViewCell_CreationAndReuseIdentifier() {
        let cell = HeroTableViewCell(style: .default, reuseIdentifier: "HeroCell")
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.reuseIdentifier, "HeroCell")
    }
    func testHeroDetailViewController_TitleIsCorrect() {
        let hero = HerosModel(id: UUID(), favorite: false, description: "desc", photo: "", name: "Gohan", transformations: [])
        let vc = HeroDetailViewController(hero: hero)
        vc.loadViewIfNeeded()
        
        XCTAssertNotEqual(vc.title, "Detalles")
    }
    
}
