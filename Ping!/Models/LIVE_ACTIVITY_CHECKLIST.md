# Live Activity Not Showing - Complete Checklist

## ✅ CRITICAL CHECKS - Do These First

### 1. Target Membership for PingAttributes.swift
**THIS IS THE MOST COMMON ISSUE**

1. In Xcode, select `PingAttributes.swift` in the Project Navigator
2. Open the **File Inspector** (right panel, or View → Inspectors → File)
3. Look at **Target Membership** section
4. **BOTH targets must be checked:**
   - ✅ Ping
   - ✅ PingWidget
   
**If PingWidget is NOT checked, the widget can't access PingAttributes!**

---

### 2. Main App Target - Info.plist

**File:** Info.plist (main app target)

Add this key-value pair:
```
Key: NSSupportsLiveActivities
Type: Boolean
Value: YES
```

**How to add in Xcode:**
1. Select **Ping** target
2. Go to **Info** tab
3. Click **+** button
4. Type: "Supports Live Activities" (it will autocomplete to NSSupportsLiveActivities)
5. Set to **YES**

---

### 3. Widget Extension - Info.plist

**File:** PingWidget/Info.plist (already created)

Verify it contains:
```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.widgetkit-extension</string>
</dict>
```

---

### 4. App Groups Configuration

**Both targets need App Groups:**

#### Main App (Ping):
1. Select **Ping** target
2. **Signing & Capabilities** tab
3. Click **+ Capability** → **App Groups**
4. Check: `group.com.kristenHan.ping`

#### Widget Extension (PingWidget):
1. Select **PingWidget** target
2. **Signing & Capabilities** tab
3. Click **+ Capability** → **App Groups**
4. Check: `group.com.kristenHan.ping`

**IMPORTANT:** The group ID must be EXACTLY the same in both targets!

---

### 5. Widget Extension is Embedded

1. Select **Ping** target (main app)
2. Go to **General** tab
3. Scroll to **Frameworks, Libraries, and Embedded Content**
4. **PingWidget.appex** should be listed there
5. If not there:
   - Go to **Build Phases** tab
   - Find **Embed Foundation Extensions** (or **Embed App Extensions**)
   - Click **+** and add **PingWidget.appex**

---

### 6. Build Settings - Deployment Target

Both targets should have the same iOS deployment target:

1. Select **Ping** target → **Build Settings** → Search "iOS Deployment Target" → Should be **16.2 or higher**
2. Select **PingWidget** target → **Build Settings** → Search "iOS Deployment Target" → Should be **16.2 or higher**

---

### 7. Bundle Identifiers

Check bundle identifiers are correct:

#### Main App:
- Bundle Identifier: `com.kristenHan.ping` (or similar)

#### Widget Extension:
- Bundle Identifier: `com.kristenHan.ping.PingWidget` (must be main app ID + `.PingWidget`)

**How to check:**
1. Select target
2. Go to **General** tab
3. Look at **Bundle Identifier** field

---

## 🔧 ADVANCED CHECKS

### 8. Device Settings

On your iPhone/iPad:

1. **Settings → Face ID & Passcode** (or Touch ID & Passcode)
2. Scroll down to **Live Activities**
3. Make sure it's **ON**
4. Look for your app name - if there's a toggle, make sure it's **ON**

### 9. Scheme Configuration

Make sure both schemes are configured properly:

1. Click scheme dropdown → **Edit Scheme**
2. For **PingWidget** scheme:
   - Run → Executable → **Ask on Launch** OR select your app
3. For **Ping** scheme:
   - Run → Executable → **Ping.app**

### 10. Clean and Rebuild

1. Product → Clean Build Folder (⇧⌘K)
2. Derived Data: Xcode → Preferences → Locations → Derived Data → Click arrow → Delete entire DerivedData folder
3. Restart Xcode
4. Build **PingWidget** target first
5. Then build **Ping** target

### 11. Delete App from Device

1. Delete the app completely from your device
2. Restart your device
3. Clean build folder in Xcode
4. Reinstall the app

---

## 🔍 DEBUGGING STEPS

### Test 1: Check if Extension is Installed

After installing the app:
1. Go to Settings → General → VPN & Device Management (or Profiles)
2. OR Settings → General → iPhone Storage → Find your app → Check size
3. The widget extension should be bundled with the app

### Test 2: Console Logs

After pressing "Send Ping", you should see in the console:
```
🔵 sendPing 시작
🔵 활성 Activity 개수: 1
🔵 Activity ID: [some UUID]
```

If you see Activity ID but no visual display, it's a widget rendering issue.

### Test 3: Run Diagnostic

Press the **"🔍 진단 실행"** button in the app. 

Expected output:
```
✓ areActivitiesEnabled: true
✓ 활성 Activity 수: 1
✅ 테스트 Activity 생성 성공!
```

---

## 📋 MOST COMMON CAUSES (In Order)

1. **PingAttributes.swift not in PingWidget target membership** ← 90% of cases
2. **NSSupportsLiveActivities missing from main app Info.plist**
3. **Widget extension not properly embedded in main app**
4. **App Groups not configured or mismatched IDs**
5. **Live Activities disabled in device Settings**
6. **iOS version below 16.2**
7. **Cached widget extension (needs reinstall)**

---

## 🎯 ACTION PLAN

Do these in order:

1. ✅ Check PingAttributes.swift target membership (MOST IMPORTANT)
2. ✅ Verify NSSupportsLiveActivities in main app Info.plist
3. ✅ Verify App Groups in both targets
4. ✅ Check widget extension is embedded
5. ✅ Delete app from device
6. ✅ Clean build folder
7. ✅ Rebuild and reinstall
8. ✅ Run diagnostic button
9. ✅ Lock phone to see Live Activity

---

## 💡 STILL NOT WORKING?

If you've verified ALL of the above and it still doesn't work:

1. Create a brand new test project with just Live Activity
2. If that works, compare project settings
3. Check for any build errors/warnings related to the widget extension
4. Try on a different device (if available)
5. Check Console app on Mac for system-level errors when Live Activity is created

---

Last Updated: 2026-02-04
