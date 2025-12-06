# SLAMalyzer_IE415
## Introduction
This is an Android Augmented Reality APP based on [ORB-SLAM3](https://github.com/UZ-SLAMLab/ORB_SLAM3) and OpenGL. *(TODO: The demo video can be found in the links below.)*

## Notice
We thank the great contribution of [@muziyongshixin](https://github.com/muziyongshixin/ORB-SLAM2-based-AR-on-Android).

# ORB_SLAM3_AR-for-Android

A powerful Android AR application combining **ORB-SLAM3** visual localization with **Dead Reckoning (sensor-based navigation)** for robust indoor and outdoor mapping and tracking. Features real-time visualization, 2D map analysis, and comprehensive path drift analysis.

## 🌟 Key Features

- **ORB-SLAM3 Integration**: Monocular visual SLAM for accurate 3D reconstruction and camera pose estimation
- **Dead Reckoning Support**: Sensor fusion using linear acceleration and rotation vector for continuous positioning
- **Multi-Mode Tracking**:
  - **SLAM Mode**: Pure visual tracking
  - **SLAM + DR Mode**: Hybrid visual-inertial fusion
  - **DR-Only Mode**: Pure sensor-based dead reckoning (black screen with sensor data overlay)
- **Real-Time Visualization**:
  - Live camera feed with feature points counter
  - 3D AR visualization with detected map points
  - Live FPS monitoring
- **2D Map Analysis** (Post-Recording):
  - Interactive map with pinch-to-zoom and drag-to-pan
  - SLAM path (Blue), DR path (Green), and detected obstacles (Red)
  - Start (Cyan) and End (Magenta) point markers
  - Drift calculation and visualization
  - FPS and statistics display
- **Adjustable Scale Parameter**: Manually calibrate the scale to match real-world dimensions
- **Legible UI**: Large, bold, shadow-enhanced text for excellent readability in all lighting conditions

## 📋 Requirements

- Android Studio 2023.1.1 or higher
- Android SDK API Level 21+ (Android 5.0+)
- NDK for native C++ compilation
- OpenCV 4.12.0 Android SDK
- CMake 3.10+

## 🛠️ Dependencies

The following third-party libraries are partially included or require manual download:

| Library | Version | Status | Location |
|---------|---------|--------|----------|
| **Eigen** | 3.4.0 | Manual | `app/src/main/cpp/Eigen/eigen-3.4.0/` |
| **Boost** | 1.72.0 | Manual | `app/src/main/cpp/boost/boost-1_72_0/` |
| **OpenCV** | 4.12.0 | Manual* | `app/src/main/cpp/opencv/` & `opencvLibrary/` |
| **Sophus** | 1.24.6 | Manual | `app/src/main/cpp/ORB/Thirdparty/Sophus/` |
| **DBow2** | Included | ✓ | `app/src/main/cpp/ORB/Thirdparty/DBoW2/` |
| **g2o** | Included | ✓ | `app/src/main/cpp/ORB/Thirdparty/g2o/` |

*OpenCV for Android is partially included; native libraries must be downloaded.

## 📦 Installation & Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/Rishik-Y/ORB_SLAM3_AR-for-Android.git
cd ORB_SLAM3_AR-for-Android
```

### Step 2: Download External Dependencies

#### **1. Eigen 3.4.0**

1. Download from: https://gitlab.com/libeigen/eigen/-/releases/3.4.0
2. Extract and copy the `Eigen/` and `unsupported/` folders to:
   ```
   app/src/main/cpp/Eigen/eigen-3.4.0/
   ```

#### **2. Boost 1.72.0**

1. Download from: https://www.boost.org/users/history/version_1_72_0.html
2. Extract and copy the `boost/` folder to:
   ```
   app/src/main/cpp/boost/boost-1_72_0/
   ```
3. **Fix Boost C++17 Compatibility Issue**:
   
   Edit `app/src/main/cpp/boost/boost-1_72_0/boost/container_hash/hash.hpp` (around lines 129-130):
   
   Replace:
   ```cpp
   template <typename T>
   struct hash_base : std::unary_function<T, std::size_t> {};
   ```
   
   With:
   ```cpp
   template <typename T>
   #if defined(__cplusplus) && __cplusplus >= 201703L
       struct hash_base {
           typedef T argument_type;
           typedef std::size_t result_type;
       };
   #else
       struct hash_base : std::unary_function<T, std::size_t> {};
   #endif
   ```

#### **3. OpenCV 4.12.0 Android SDK**

1. Download from: https://opencv.org/releases/
2. Extract the SDK and:
   - Copy `opencv-android-sdk/sdk/` contents to `opencvLibrary/`
   - Copy include files from `sdk/native/jni/include/` to `app/src/main/cpp/opencv/opencv-4.12.0/include/`
   - Copy native libraries from `sdk/native/libs/` to `app/src/main/jniLibs/` (arm64-v8a, armeabi-v7a, x86, x86_64)

#### **4. Sophus 1.24.6**

1. Download from: https://github.com/strasdat/Sophus/releases/tag/1.24.6
2. Extract and copy the `sophus/` folder to:
   ```
   app/src/main/cpp/ORB/Thirdparty/Sophus/
   ```

### Step 3: Configure the Project

Edit `app/CMakeLists.txt` if needed to match your NDK and SDK paths.

### Step 4: Build and Run

#### Using Android Studio:
1. Open the project in Android Studio
2. Connect an Android device via USB (with Developer Mode enabled)
3. Click **Run** → **Run 'app'**

#### Using Gradle (Command Line):
```bash
./gradlew installDebug
```

## 🚀 Usage

### Launch the App

1. Open the app on your Android device
2. Select a mode from the landing page:
   - **SLAM**: Pure visual tracking
   - **SLAM + DR**: Hybrid mode
   - **DR Only**: Pure sensor-based navigation

### Live View (SLAM/DR Mode)

- **Camera Feed**: Shows real-time camera view with AR visualization
- **Points Counter** (top-left, green): Displays the total number of actively tracked map points
- **Scale Slider** (Settings sidebar): Adjust the scale to calibrate real-world dimensions
- **End Button** (bottom-center): Stop recording and view the 2D map analysis

### DR-Only Mode

- **Black Screen**: No camera feed; shows pure sensor-based tracking
- **Sensor Data** (bottom-left, white): Displays raw linear acceleration and position
- **Points Path**: Still records DR position for map analysis

### 2D Map View (Post-Recording)

After pressing "End Recording":

- **Paths**:
  - **Blue**: SLAM trajectory
  - **Green**: Dead Reckoning trajectory
  - **Red Dots**: Detected obstacles (feature points)
  
- **Markers**:
  - **Cyan Circle**: Start point
  - **Magenta Circle**: End point
  
- **Interactions**:
  - **Pinch**: Zoom in/out
  - **Drag**: Pan the map
  
- **Information**:
  - **Drift**: Distance between final SLAM and DR positions (green text)
  - **FPS**: Average frames per second during recording (white text)
  - **Legend**: Bottom-left corner for reference

## 📊 Scale Parameter Explanation

The **Scale** setting is crucial for monocular SLAM because it's scale-ambiguous—the system doesn't inherently know if the camera moved 1 meter or 1 centimeter.

- **How it works**: 
  1. Walk a known distance (e.g., 10 meters)
  2. Check the recorded SLAM path length in the 2D map
  3. Adjust the slider to match reality
  
- **Example**:
  - If you walk 10 meters but the path shows 5 units, increase the scale to 2.0
  - Default is 1.0; ranges from 0.5 to 2.0 typically

## 🏗️ Project Structure

```
ORB_SLAM3_AR-for-Android/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── cpp/                       # C++ source
│   │   │   │   ├── native-lib.cpp         # JNI entry point
│   │   │   │   ├── Camera.cpp/h
│   │   │   │   ├── Frame.cpp/h
│   │   │   │   ├── Marker.cpp/h
│   │   │   │   ├── Plane.cpp/h
│   │   │   │   ├── Process.cpp/h
│   │   │   │   ├── Eigen/                 # Linear algebra library
│   │   │   │   ├── boost/                 # Boost libraries
│   │   │   │   ├── opencv/                # OpenCV for Android
│   │   │   │   ├── openssl/               # SSL/TLS library
│   │   │   │   └── ORB/                   # ORB-SLAM3 source
│   │   │   ├── java/
│   │   │   │   └── com/vslam/orbslam3/vslamactivity/
│   │   │   │       ├── VslamActivity.java       # Main activity
│   │   │   │       ├── HomeActivity.java        # Landing page
│   │   │   │       ├── Map2DView.java           # 2D map visualization
│   │   │   │       ├── MyRender.java            # OpenGL renderer
│   │   │   │       ├── DeadReckoning.java       # Sensor integration
│   │   │   │       └── ... (other supporting classes)
│   │   │   ├── assets/
│   │   │   │   └── SLAM/
│   │   │   │       ├── VOC/ORBvoc.bin           # ORB vocabulary
│   │   │   │       └── Calibration/PARAconfig.yaml
│   │   │   └── res/
│   │   │       ├── layout/
│   │   │       ├── drawable/
│   │   │       └── values/
│   │   └── ...
│   ├── CMakeLists.txt                     # CMake build configuration
│   └── build.gradle
├── opencvLibrary/                         # OpenCV Android module
├── gradle/
├── build.gradle
├── settings.gradle
├── gradlew & gradlew.bat
└── README.md

```

## 🔧 Configuration

### Calibration File

The SLAM system uses calibration parameters stored in:
```
app/src/main/assets/SLAM/Calibration/PARAconfig.yaml
```

Edit this file with your camera's intrinsic parameters:
```yaml
Camera.fx: 445.0  # Focal length X
Camera.fy: 445.0  # Focal length Y
Camera.cx: 319.5  # Principal point X
Camera.cy: 239.5  # Principal point Y
# ... more parameters
```

### Vocabulary File

The ORB-SLAM3 vocabulary (pre-computed bag-of-words) is stored in:
```
app/src/main/assets/SLAM/VOC/ORBvoc.bin
```

If using a different camera or dataset, generate a new vocabulary using the ORB-SLAM3 tools.

## 📱 Supported Devices

- Android 5.0 (API 21) and above
- Requires ARMv8 (64-bit) processor (arm64-v8a)
- Minimum 2GB RAM recommended
- Camera with adjustable focus

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails with "Eigen not found" | Verify Eigen is extracted to `app/src/main/cpp/Eigen/eigen-3.4.0/` |
| "libopencv_java4.so not found" | Download and place OpenCV native libraries in `app/src/main/jniLibs/` |
| App crashes on startup | Check that `ORBvoc.bin` and `PARAconfig.yaml` are in assets; use Android Profiler to debug |
| Scale slider doesn't affect view | Scale is applied during SLAM pose extraction; re-run recording with new scale |
| DR drift is very large | Verify sensors are calibrated; recalibrate accelerometer if needed |

## 📚 References

- [ORB-SLAM3 GitHub](https://github.com/UZ-SLAMLab/ORB_SLAM3)
- [ORB-SLAM3 Paper](https://arxiv.org/abs/2007.11898)
- [OpenCV Android](https://docs.opencv.org/4.12.0/d4/da1/tutorial_android_setup.html)
- [Android NDK Documentation](https://developer.android.com/ndk)

## 👥 Credits

- **Original ORB-SLAM3**: Developed by [UZ-SLAMLab](https://github.com/UZ-SLAMLab/)
- **Android Adaptation Inspiration**: [@muziyongshixin](https://github.com/muziyongshixin/ORB-SLAM2-based-AR-on-Android)
- **Related Work**: [SmartMapper](https://github.com/Physic69/SmartMapper) - Location tracking variant

## 📝 License

This project maintains the same license as ORB-SLAM3. Please refer to the LICENSE file for details.

## 📧 Support & Contact

For issues, questions, or suggestions:
- Open an GitHub issue
- Email: bonaventure@163.com (original author)

---

**Last Updated**: December 2025
**Status**: Active Development


Using this project, Another repo has been devised where Location tracking is partially being done instead of Earth, You can check [this](https://github.com/Physic69/SmartMapper) repo to see how the ORB_SLAM3_AR-for-Android is being used.

## Demo Videos
*(TODO)*

## Dependencies, Installation & Usage

1. **Dependencies**
    - Due to the project is based on ORB-SLAM3, OpenCV4Android is needed.
    - Other third-party dependencies like DBow2, g2o, Eigen, boost, openssl, and opencv are included in the project(I have uploaded them all except Eigen source files, boost header files, Sophus, and OpenCV4Android).
    - Recommended IDE: Android Studio 2023.1.1 or higher.
    - You may need to edit some configurations in the `CMakeLists.txt` file at `app/CMakeLists.txt`.

2. **Download Eigen, boost, Sophus and OpenCV4Android**

   **1) Download Eigen 3.4.0**

   Crack its source files `[Eigen and unsupported]` into the following directory:

   ```
   */app/src/main/cpp/Eigen/eigen-3.4.0/
   ```

   **2) Download boost 1.72.0**

   Crack its header files `[boost]` into the following directory:

   ```
   */app/src/main/cpp/boost/boost-1_72_0/
   ```

   **2.1) Fix boost compatibility issue**

   In the file `boost/container_hash/hash.hpp`, around lines 129-130, find this code:

   ```
   template <typename T>
   struct hash_base : std::unary_function<T, std::size_t> {};
   ```

   Replace it with:

   ```
   template <typename T>
   #if defined(__cplusplus) && __cplusplus >= 201703L
       // C++17 and later - std::unary_function was removed
       struct hash_base {
           typedef T argument_type;
           typedef std::size_t result_type;
       };
   #else
       // C++14 and earlier - use std::unary_function
       struct hash_base : std::unary_function<T, std::size_t> {};
   #endif
   ```

   **3) Download OpenCV 4.12.0 Android SDK**

   **3.1) Extract the SDK, go within the `sdk` folder, and copy all its contents directly into:

   ```
   */opencvLibrary/
   ```
   
   **3.2) Copy include files**

   From `opencv-4.12.0-android-sdk/sdk/native/jni/include/` to:

   ```
   */app/src/main/cpp/opencv/opencv-4.12.0/include/
   ```
   *(Basically copy everything except videoio, photo and gapi)*

   **3.3) Copy native libraries**

   **(NOTE: ALREADY ADDED Except for x86 and x86_64)**

   From `opencv-4.12.0-android-sdk/sdk/native/libs/` to:

   ```
   */app/src/main/jniLibs/
   ```
   *(Copy each `libopencv_java4.so` and paste it within their respective directories)*

   **4) Download Sophus 1.24.6**

   Crack its files `[sophus]` into the following directory:

   ```
   */app/src/main/cpp/ORB/Thirdparty/Sophus/
   ```

### 3. Additional Notes
- You may also need to calibrate your phone's camera for better performance. (More details of camera calibration can be found on google.)
- Due to the diversity of Android system version, you may also need to change some configurarions in the ***AndroidManifest.xml*** to make sure that the app have the authority to use the camera and file system.

## Framework & Results
The system is consisted of two parts(https://github.com/Abonaventure/ORB_SLAM3_AR-for-Android), the ORB-SLAM3 part which is used to get the camera's pose matrix. The other part is the OpenGL Rendering module, which use the pose matrix to render the 3D object(the earth in this project).

The ORB-SLAM3 system requires lots of computing resources and depend on Calibration the camera, so this APP can not initilize very quikly(the screen will show red "SLAM NOT INITIALIZED").It's better to choose a rich texture scene to initilize the SLAM(the screen will show green "SLAM ON").

The ORB-SLAM3 system requires significant computing resources and depend on Calibration the camera, so this APP may not initilize very quikly(the screen will show red "SLAM NOT INITIALIZED").It's better to choose a rich texture scene to initilize the SLAM(the screen will show green "SLAM ON").
