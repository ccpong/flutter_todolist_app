# 📝 Flutter Todo List

一個簡潔美觀的待辦事項管理應用程式，使用 Flutter 開發。

## ✨ 功能特色

- 📋 新增、編輯、刪除待辦事項
- ✅ 標記完成/未完成狀態
- 💾 本地資料持久化儲存
- 🎨 現代化 Material Design UI
- 📱 支援多平台（Web、Android、iOS、Desktop）
- 🔄 滑動刪除功能
- ⚡ 即時資料同步

## 🛠️ 技術棧

- **Flutter** - UI 框架
- **Dart** - 程式語言
- **SharedPreferences** - 本地資料儲存
- **Material 3** - 設計系統

## 📷 應用程式截圖

（這裡可以加入應用程式的截圖）

## 🚀 快速開始

### 環境要求

- Flutter SDK 3.0 或更高版本
- Dart SDK
- Android Studio / VS Code

### 安裝步驟

1. **克隆專案**
   ```bash
   git clone https://github.com/你的用戶名/flutter-todo-list.git
   cd flutter-todo-list
   ```

2. **安裝依賴**
   ```bash
   flutter pub get
   ```

3. **運行應用程式**
   ```bash
   # 在 Chrome 瀏覽器中運行
   flutter run -d chrome
   
   # 在 Android 模擬器中運行
   flutter run -d android
   
   # 在 iOS 模擬器中運行
   flutter run -d ios
   ```

## 📚 學習價值

這個專案展示了以下 Flutter 開發概念：

- **狀態管理** - 使用 StatefulWidget 管理應用程式狀態
- **本地儲存** - 使用 SharedPreferences 實現資料持久化
- **JSON 序列化** - 物件與 JSON 之間的轉換
- **異步程式設計** - async/await 的使用
- **Widget 組合** - 複雜 UI 的模組化設計
- **Material Design** - 現代化的 UI 設計

## 🔧 專案結構

```
lib/
├── main.dart          # 應用程式入口點
├── models/
│   └── todo.dart      # Todo 資料模型
├── widgets/
│   └── todo_item.dart # 待辦事項 Widget
└── utils/
    └── storage.dart   # 資料儲存工具
```

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

## 📄 授權

本專案採用 MIT 授權 - 詳見 [LICENSE](LICENSE) 檔案

## 🎓 作者

由 [您的名字] 開發，作為 Flutter 學習專案。

---

⭐ 如果這個專案對您有幫助，請給一個星星！
