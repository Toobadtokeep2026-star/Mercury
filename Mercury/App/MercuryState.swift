import Foundation
import SwiftUI

@MainActor
final class MercuryState: ObservableObject {
    @Published var activePersona: MercuryPersona = .soulSworn
    @Published var isKernelReady = false
    @Published var activeRelics: [String] = []

    func boot() {
        MercuryKernel.shared.boot()
        isKernelReady = true
    }
}
