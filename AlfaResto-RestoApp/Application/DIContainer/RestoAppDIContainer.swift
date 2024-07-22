//
//  RestoAppDIContainer.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation

final class RestoAppDIContainer {
    
    // MARK: - Services
    private let authenticationServices: AuthenticationServices
    private let firestoreServices: FirestoreServices
    private let firebaseStorageServices: FirebaseStorageServices
    private let firebaseDatabaseServices: FirebaseDatabaseServices
    private let locationServices: LocationServices
    
    // MARK: - Repository
    private let restoRespository: RestoRepository
    private let menuRepository: MenuRepository
    private let orderRepository: OrderRepository
    private let shipmentRepository: ShipmentRepository
    private let notificationRepository: NotificationRepository
    private let locationRepository: LocationRepository
    private let chatRepository: ChatRepository
    
    // MARK: - DTS
    private let notifDTS: DataTransferService
    
    init() {
        self.authenticationServices = AuthenticationServicesImpl()
        self.firestoreServices = FirestoreServicesImpl()
        self.firebaseStorageServices = FirebaseStorageServicesImpl()
        self.firebaseDatabaseServices = FirebaseDatabaseServicesImpl()
        self.locationServices = LocationServicesImpl()
        
        self.notifDTS = AppDIContainer().notifApiDataTransferServices
        
        self.restoRespository = RestoRepositoryImpl(authenticationServices: self.authenticationServices, firestoreServices: self.firestoreServices, firebaseStorageServices: self.firebaseStorageServices)
        self.menuRepository = MenuRepositoryImpl(firestoreServices: self.firestoreServices, firebaseStorageServices: self.firebaseStorageServices)
        self.orderRepository = OrderRepositoryImpl(firestoreServices: self.firestoreServices, firebaseRealtimeServices: self.firebaseDatabaseServices)
        self.shipmentRepository = ShipmentRepositoryImpl(firestoreServices: self.firestoreServices)
        self.notificationRepository = NotificationRepositoryImpl(dataTranseferService: self.notifDTS)
        self.locationRepository = LocationRepositoryImpl(locationServices: self.locationServices, firebaseDatabaseServices: self.firebaseDatabaseServices, dataTransferServices: self.notifDTS)
        self.chatRepository = ChatsRepositoryImpl()
    }
    
}

extension RestoAppDIContainer {
    // MARK: - Login View Model
    func makeLoginViewModel() -> LoginViewModel {
        let restoUseCase = RestoUseCaseImpl(restoRepository: self.restoRespository)
        return LoginViewModelImpl(restoUseCase: restoUseCase, fcmTokenHandler: self.makeFCMTokenHandler())
    }
    
    // MARK: - Menu View Model
    func makeListMenuViewModel() -> ListMenuViewModel {
        let menuUseCase = MenuUseCaseImpl(menuRepository: self.menuRepository)
        return ListMenuViewModelImpl(menuUseCase: menuUseCase)
    }
    
    func makeAddMenuViewModel() -> AddMenuViewModel {
        let menuUseCase = MenuUseCaseImpl(menuRepository: self.menuRepository)
        return AddMenuViewModelImpl(menuUseCase: menuUseCase)
    }
    
    func makeEditMenuViewModel() -> EditMenuViewModel {
        let menuUseCase = MenuUseCaseImpl(menuRepository: self.menuRepository)
        return EditMenuViewModelImpl(menuUseCase: menuUseCase)
    }

    // MARK: - Profile View Model
    func makeProfileViewModel() -> ProfileViewModel {
        let restoUseCase = RestoUseCaseImpl(restoRepository: self.restoRespository)
        return ProfileViewModelImpl(restoUseCase: restoUseCase, fcmTokenHanlder: self.makeFCMTokenHandler())
    }

    func makeEditProfileViewModel() -> EditProfileViewModel {
        let restoUseCase = RestoUseCaseImpl(restoRepository: self.restoRespository)
        return EditProfileViewModelImpl(restoUseCase: restoUseCase)
    }
    
    func makeOrderViewModel() -> OrderViewModel {
        let shipmentUseCase = ShipmentUseCaseImpl(shipmentRepository: self.shipmentRepository)
        let orderUseCase = OrderUseCaseImpl(orderRepository: self.orderRepository)
        
        return OrderViewModelImpl(orderUseCase: orderUseCase, shipmentUseCase: shipmentUseCase)
    }
    
    // MARK: - Tab Bar View Model
    func makeTabBarViewModel() -> TabBarViewModel {
        let orderUseCase = OrderUseCaseImpl(orderRepository: self.orderRepository)
        return TabBarViewModelImpl(orderUseCase: orderUseCase)
    }
    
    // MARK: - Handler
    func makeNotificationHandler() -> NotificationHandler {
        return NotificationHandlerImpl()
    }
    
    func makeFCMTokenHandler() -> FCMTokenHandler {
        let restoUseCase = RestoUseCaseImpl(restoRepository: self.restoRespository)
        return FCMTokenHandlerImpl(restoUseCase: restoUseCase)
    }
    
    // MARK: - Order View Model
    func makeOrderDetailViewModel() -> OrderDetailViewModel {
        let shipmentUseCase = ShipmentUseCaseImpl(shipmentRepository: self.shipmentRepository)
        let restoUseCase = RestoUseCaseImpl(restoRepository: self.restoRespository)
        let orderUseCase = OrderUseCaseImpl(orderRepository: self.orderRepository)
        let notificationUseCase = NotificationUseCaseImpl(notificationRepository: self.notificationRepository)
        let locationUseCase = LocationUseCaseImpl(locationRepository: self.locationRepository)
        
        return OrderDetailViewModelImpl(shipmentUseCase: shipmentUseCase, orderUseCase: orderUseCase, notificationUseCase: notificationUseCase, locationUseCase: locationUseCase, restoUseCase: restoUseCase)
    }
    
    //MARK: - Chat View Model
    func makeChatViewModel() -> ChatViewModel {
        let notificationUseCase = NotificationUseCaseImpl(notificationRepository: self.notificationRepository)
        let chatUseCase = ChatUseCaseImpl(chatRepository: self.chatRepository)
        let orderUseCase = OrderUseCaseImpl(orderRepository: self.orderRepository)
        
        return ChatViewModelImpl(chatUseCase: chatUseCase, notifUseCase: notificationUseCase, orderUseCase: orderUseCase)
    }
    
}
