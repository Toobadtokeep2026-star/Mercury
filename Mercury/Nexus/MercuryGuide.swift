import Foundation

struct MercuryGuideStep {
    let title: String
    let explanation: String
    let action: String
}

final class MercuryGuide {
    static let shared = MercuryGuide()

    let steps: [MercuryGuideStep] = [
        MercuryGuideStep(title: "Observe", explanation: "Review available system signals and permissions.", action: "Inspect"),
        MercuryGuideStep(title: "Understand", explanation: "Translate diagnostics into human meaning.", action: "Analyze"),
        MercuryGuideStep(title: "Improve", explanation: "Recommend supported configuration changes.", action: "Optimize")
    ]
}
