//
//  NoInternetModifier.swift
//  Cars
//
//  Created by Adi Moldovan on 1/8/22.
//

import Foundation
import SwiftUI
import Combine
import Network
import ExytePopupView

extension View {
   
    func noInternetModifier() -> some View {
        ModifiedContent(content: self, modifier: NoInternetModifier())
    }
    
}

struct NoInternetModifier: ViewModifier {
   
    @ObservedObject private var viewModel: InternetAlertViewModel = InternetAlertViewModel()

    func body(content: Content) -> some View {
        content
            .popup(isPresented: self.$viewModel.isDisconnected, type: .floater(), position: .bottom,
                   animation: .spring(), closeOnTap: false, closeOnTapOutside: true, view: {

                    HStack {
                        
                        HStack {
                                                        
                            Spacer()
                            
                            Text("No Internet Connection")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                
                            Spacer()

                        }
                        .padding(12)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                    
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            
            })
    }
}

final class InternetAlertViewModel: ObservableObject {

    // MARK: - Properties

    @Published var isDisconnected: Bool = false
    private var monitorCancellable: Cancellable?
    
    // MARK: - Life cycle

    init() {
        self.checkConnection()
    }
    
    func checkConnection() {
        monitorCancellable =  NWPathMonitor.PathMonitorPublisher(monitor: NWPathMonitor(),
                                                                 queue: DispatchQueue.global(qos: .background))
                   .receive(on: RunLoop.main)
                   .map { $0.status == .unsatisfied }
                   .assign(to: \.isDisconnected, on: self)
    }
}

extension NWPathMonitor {
    
    public struct PathMonitorPublisher: Publisher {

          // MARK: - Nested types
      
          public typealias Output = NWPath
          public typealias Failure = Never
      
          // MARK: - Properties
      
          private let monitor: NWPathMonitor
          private let queue: DispatchQueue
      
          // MARK: - Life cycle
      
        init(
              monitor: NWPathMonitor,
              queue: DispatchQueue
          ) {
              self.monitor = monitor
              self.queue = queue
          }
      
          // MARK: - Public
      
          public func receive<S>(
              subscriber: S
          ) where S: Subscriber, S.Failure == Failure, S.Input == Output {
              let subscription = PathMonitorSubscription(
                  subscriber: subscriber,
                  monitor: monitor,
                  queue: queue
              )
      
              subscriber.receive(
                  subscription: subscription
              )
          }
      }

    final class PathMonitorSubscription<S: Subscriber>: Subscription where S.Input == NWPath {

        // MARK: - Nested types
  
        private let subscriber: S
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
  
        // MARK: - Life cycle
  
        init(
            subscriber: S,
            monitor: NWPathMonitor,
            queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }
  
        // MARK: - Public
  
        func request(
            _ demand: Subscribers.Demand
        ) {
            guard
                demand == .unlimited,
                monitor.pathUpdateHandler == nil
            else {
                return
            }
  
            monitor.pathUpdateHandler = { path in
                _ = self.subscriber.receive(path)
            }
  
            monitor.start(
                queue: queue
            )
        }
  
        func cancel() {
            monitor.cancel()
        }
    }
}


class BaseUIHostingController <Content>: UIHostingController<AnyView> where Content : View {

  public init(shouldShowNavigationBar: Bool, rootView: Content) {
      super.init(rootView: AnyView(rootView.navigationBarHidden(true)))
  }

  @objc required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
