import SwiftUI

/// 设置页面
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var soundManager = SoundManager.shared
    @ObservedObject var hapticManager = HapticManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("主题")) {
                    ForEach(Theme.allCases) { theme in
                        HStack {
                            Text(theme.rawValue)
                                .foregroundColor(theme.textColor)

                            Spacer()

                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(theme.textColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            themeManager.setTheme(theme)
                        }
                    }
                }

                Section(header: Text("反馈设置")) {
                    Toggle("音效", isOn: $soundManager.isSoundEnabled)
                    Toggle("触觉反馈", isOn: $hapticManager.isHapticEnabled)
                }

                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0 - Phase 3")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
#endif
