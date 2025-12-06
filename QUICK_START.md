# 🚀 QUICK START GUIDE - Running ORB_SLAM3_AR-for-Android

## ⚡ FASTEST WAY TO RUN (Automated)

### **Option 1: One-Command Setup (Recommended)**

Open PowerShell in this directory and run:

```powershell
.\setup.ps1
```

This will automatically:
- ✅ Download all dependencies (~300MB)
- ✅ Install Eigen, Sophus, and OpenCV
- ✅ Fix Boost C++17 compatibility
- ✅ Prepare project for building

**Time required:** 10-20 minutes (depending on internet speed)

---

### **Option 2: Manual Step-by-Step**

If you prefer manual control:

```powershell
# Step 1: Download dependencies
.\download_dependencies.ps1

# Step 2: Install dependencies
.\install_dependencies.ps1

# Step 3: Fix Boost compatibility
.\fix_boost_cpp17.ps1
```

---

## 📱 BUILD & RUN

### **Prerequisites**
- ✅ Android Studio 2023.1.1 or newer
- ✅ Android device with Android 10+ (API 29+)
- ✅ USB debugging enabled on device
- ✅ Android SDK installed (already configured in local.properties)

### **Building the App**

**Method 1: Using Android Studio (Recommended)**

1. Open Android Studio
2. Click: `File → Open`
3. Select this project folder: `ORB_SLAM3_AR-for-Android`
4. Wait for Gradle sync (may take 2-5 minutes first time)
5. Connect your Android device via USB
6. Click the green ▶️ Run button (or press `Shift+F10`)

**Expected build time:** 10-15 minutes (first build)

**Method 2: Using Command Line**

```powershell
# Build APK
.\gradlew assembleDebug

# Install to connected device
.\gradlew installDebug

# Or build and install in one command
.\gradlew installDebug
```

APK location: `app\build\outputs\apk\debug\app-debug.apk`

---

## 🎯 RUNNING THE APP

### **When App Launches:**

1. **Grant Permissions**
   - Camera permission (required)
   - Storage permission (if prompted)

2. **Initialize SLAM**
   - Point camera at a **textured surface** (posters, patterns, books)
   - Move camera slowly
   - Wait for status to change from red "SLAM NOT INITIALIZED" to green "SLAM ON"
   - **Avoid:** blank walls, uniform surfaces, low light

3. **AR Rendering**
   - Once SLAM initializes, you'll see a 3D Earth model
   - Move camera to see AR object stay in place
   - Use seekbar to adjust scale

### **Troubleshooting**

| Problem | Solution |
|---------|----------|
| "SLAM NOT INITIALIZED" stays red | Point at textured surface, move camera slowly |
| App crashes on start | Check camera permission granted |
| Black screen | Check if device camera is working |
| Build fails | Ensure all dependencies installed correctly |
| Gradle sync fails | Check internet connection, invalidate cache & restart |

---

## 📋 WHAT WAS CONFIGURED

✅ **Updated Files:**
- `local.properties` → Set to your Android SDK path
- `app/build.gradle` → Removed unused import
- Created setup automation scripts

✅ **Dependencies (when you run setup):**
- Eigen 3.4.0 → Matrix operations for SLAM
- Sophus 1.24.6 → Lie algebra for 3D transformations
- OpenCV 4.12.0 Android SDK → Computer vision library
- Boost C++17 fix → Compatibility patch

---

## 📊 PROJECT STATUS

### Current Implementation:
- ✅ ORB-SLAM3 (Visual SLAM)
- ✅ Monocular camera tracking
- ✅ AR object rendering (Earth model)
- ✅ Real-time pose estimation

### Missing for Course Project:
- ❌ **Dead Reckoning (DR) using IMU**
- ❌ **DR vs SLAM comparison visualization**
- ❌ **Inertial sensor integration**
- ❌ **Session logging/data export**
- ❌ **Performance comparison metrics**

**See `PROJECT_ANALYSIS_AND_IMPROVEMENTS.md` for complete details**

---

## 🔧 SYSTEM REQUIREMENTS

**Development Machine:**
- Windows 10/11, macOS, or Linux
- 16GB RAM recommended
- 50GB free disk space
- Android Studio 2023.1.1+

**Android Device:**
- Android 10+ (API 29+)
- ARM64 architecture (arm64-v8a)
- 4GB+ RAM recommended
- Working camera with autofocus

---

## 📚 NEXT STEPS

After successfully running the app:

1. **Test basic functionality**
   - Verify SLAM initialization works
   - Test AR rendering
   - Try different environments

2. **For course project, you need to ADD:**
   - Dead Reckoning implementation
   - IMU sensor integration
   - Dual trajectory visualization
   - Data logging for analysis

3. **Read the analysis document:**
   - `PROJECT_ANALYSIS_AND_IMPROVEMENTS.md`
   - Contains detailed implementation guide
   - Shows what's needed for course requirements

---

## 💾 CLEANUP (Optional)

After successful setup, you can delete temporary files:

```powershell
Remove-Item -Recurse -Force .\temp_downloads
```

This will save ~500MB of disk space.

---

## 🆘 HELP

**If setup fails:**
1. Check error messages in terminal
2. Verify internet connection
3. Ensure Android SDK is properly installed
4. Try running scripts individually instead of setup.ps1

**If build fails:**
1. Check Android Studio's "Build" tab for errors
2. Try: `Build → Clean Project` then `Build → Rebuild Project`
3. Verify all dependencies installed by checking these folders:
   - `app/src/main/cpp/Eigen/eigen-3.4.0/Eigen/` (should have .h files)
   - `app/src/main/cpp/ORB/Thirdparty/Sophus/sophus/` (should have .hpp files)
   - `opencvLibrary/java/` (should have OpenCV files)

**If app crashes:**
1. Check logcat in Android Studio
2. Verify camera permissions granted
3. Test camera works in other apps
4. Try different device if available

---

## 📄 LICENSE

See original project: https://github.com/Rishik-Y/ORB_SLAM3_AR-for-Android

---

**Ready to start? Run: `.\setup.ps1`** 🎉
