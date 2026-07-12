import SwiftUI

struct ObservatoryView: View {
    @EnvironmentObject var mercury: MercuryState

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("☿ Mercury")
                    .font(.largeTitle.bold())

                Text("Quicksilver Intelligence")
                    .foregroundStyle(.gray)

                Circle()
                    .stroke(.white.opacity(0.4), lineWidth: 2)
                    .frame(width: 180, height: 180)
                    .overlay {
                        VStack {
                            Text(mercury.activeAspect)
                            Text(mercury.status)
                                .font(.caption)
                        }
                    }

                Text("The Observatory awakens.")
                    .italic()
            }
            .foregroundStyle(.white)
            .onAppear {
                mercury.boot()
            }
        }
    }
}
