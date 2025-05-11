//
//  ErrorViewController.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import UIKit
import Combine
import CombineCocoa

class ErrorViewController: UIViewController {
    
    private var appState: AppState?
    private var suscriptors = Set<AnyCancellable>()
    private var errorString: String
    
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    init(appState: AppState? = nil, error: String) {
        self.appState = appState
        self.errorString = error
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.numberOfLines = 0
        self.errorLabel.text = self.errorString
        self.errorButton.setTitle(
            NSLocalizedString("error-button", comment: ""),
            for: .normal
        )
        
        self.errorButton.tapPublisher
            .sink {
                self.appState?.loginStatus = .none //Para volver al login
            }
            .store(in: &suscriptors)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
