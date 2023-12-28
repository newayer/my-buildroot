################################################################################
#
# opencv4
#
################################################################################

OPENCV_MOBILE_VERSION = 4.8.1
OPENCV_MOBILE_SITE = https://github.com/nihui/opencv-mobile/releases/download/v23
OPENCV_MOBILE_SOURCE=opencv-mobile-$(OPENCV_MOBILE_VERSION).zip
OPENCV_MOBILE_INSTALL_STAGING = YES
OPENCV_MOBILE_LICENSE = Apache-2.0
OPENCV_MOBILE_LICENSE_FILES = LICENSE
OPENCV_MOBILE_CPE_ID_VENDOR = opencv
OPENCV_MOBILE_CPE_ID_PRODUCT = opencv
OPENCV_MOBILE_SUPPORTS_IN_SOURCE_BUILD = NO

OPENCV_MOBILE_CXXFLAGS = $(TARGET_CXXFLAGS)

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
OPENCV_MOBILE_CXXFLAGS += -latomic
endif

# Fix c++11 build with missing std::exception_ptr
ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_64735),y)
OPENCV_MOBILE_CXXFLAGS += -DCV__EXCEPTION_PTR=0
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
OPENCV_MOBILE_CXXFLAGS += -O0
endif

OPENCV_MOBILE_CXXFLAGS += -fno-rtti -fexceptions

# OpenCV component options
OPENCV_MOBILE_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="$(OPENCV_MOBILE_CXXFLAGS)" \
	-DBUILD_DOCS=OFF \
	-DBUILD_PERF_TESTS=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_WITH_DEBUG_INFO=OFF \
	-DDOWNLOAD_EXTERNAL_TEST_DATA=OFF

OPENCV_MOBILE_CONF_OPTS += \
	-DBUILD_opencv_world=OFF \
	-DOPENCV_DISABLE_FILESYSTEM_SUPPORT=ON \
	-DWITH_OPENMP=OFF \
	-DOPENCV_DISABLE_THREAD_SUPPORT=ON

# OpenCV link options
OPENCV_MOBILE_CONF_OPTS += \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF \
	-DCMAKE_USE_RELATIVE_PATHS=OFF

# OpenCV module selection
# * Modules on:
#   - core: if not set, opencv does not build anything
#   - hal: core's dependency
# * Modules off:
#   - android*: android stuff
#   - apps: programs for training classifiers
#   - java: java bindings
#   - viz: missing VTK dependency
#   - world: all-in-one module
#
OPENCV_MOBILE_CONF_OPTS += -DBUILD_ZLIB=OFF \
							-DBUILD_TIFF=OFF \
							-DBUILD_OPENJPEG=OFF \
							-DBUILD_JASPER=OFF \
							-DBUILD_JPEG=OFF \
							-DBUILD_PNG=OFF \
							-DBUILD_OPENEXR=OFF \
							-DBUILD_WEBP=OFF \
							-DBUILD_TBB=OFF \
							-DBUILD_IPP_IW=OFF \
							-DBUILD_ITT=OFF \
							-DWITH_AVFOUNDATION=OFF \
							-DWITH_CAP_IOS=OFF \
							-DWITH_CAROTENE=OFF \
							-DWITH_CPUFEATURES=OFF \
							-DWITH_EIGEN=OFF \
							-DWITH_FFMPEG=OFF \
							-DWITH_GSTREAMER=OFF \
							-DWITH_GTK=OFF \
							-DWITH_IPP=OFF \
							-DWITH_HALIDE=OFF \
							-DWITH_VULKAN=OFF \
							-DWITH_INF_ENGINE=OFF \
							-DWITH_NGRAPH=OFF \
							-DWITH_JASPER=OFF \
							-DWITH_OPENJPEG=OFF \
							-DWITH_JPEG=OFF \
							-DWITH_WEBP=OFF \
							-DWITH_OPENEXR=OFF \
							-DWITH_PNG=OFF \
							-DWITH_TIFF=OFF \
							-DWITH_OPENVX=OFF \
							-DWITH_GDCM=OFF \
							-DWITH_TBB=OFF \
							-DWITH_HPX=OFF \
							-DWITH_OPENMP=ON \
							-DWITH_PTHREADS_PF=OFF \
							-DWITH_V4L=OFF \
							-DWITH_CLP=OFF \
							-DWITH_OPENCL=OFF \
							-DWITH_OPENCL_SVM=OFF \
							-DWITH_VA=OFF \
							-DWITH_VA_INTEL=OFF \
							-DWITH_ITT=OFF \
							-DWITH_PROTOBUF=OFF \
							-DWITH_IMGCODEC_HDR=OFF \
							-DWITH_IMGCODEC_SUNRASTER=OFF \
							-DWITH_IMGCODEC_PXM=OFF \
							-DWITH_IMGCODEC_PFM=OFF \
							-DWITH_QUIRC=OFF \
							-DWITH_ANDROID_MEDIANDK=OFF \
							-DWITH_TENGINE=OFF \
							-DWITH_ONNX=OFF \
							-DWITH_TIMVX=OFF \
							-DWITH_OBSENSOR=OFF \
							-DWITH_CANN=OFF \
							-DWITH_FLATBUFFERS=OFF \
							-DBUILD_SHARED_LIBS=OFF \
							-DBUILD_opencv_apps=OFF \
							-DBUILD_ANDROID_PROJECTS=OFF \
							-DBUILD_ANDROID_EXAMPLES=OFF \
							-DBUILD_DOCS=OFF \
							-DBUILD_EXAMPLES=OFF \
							-DBUILD_PACKAGE=OFF \
							-DBUILD_PERF_TESTS=OFF \
							-DBUILD_TESTS=OFF \
							-DBUILD_WITH_STATIC_CRT=OFF \
							-DBUILD_FAT_JAVA_LIB=OFF \
							-DBUILD_ANDROID_SERVICE=OFF \
							-DBUILD_JAVA=OFF \
							-DBUILD_OBJC=OFF \
							-DENABLE_PRECOMPILED_HEADERS=OFF \
							-DENABLE_FAST_MATH=ON \
							-DCV_TRACE=OFF \
							-DBUILD_opencv_java=OFF \
							-DBUILD_opencv_gapi=OFF \
							-DBUILD_opencv_objc=OFF \
							-DBUILD_opencv_js=OFF \
							-DBUILD_opencv_ts=OFF \
							-DBUILD_opencv_python2=OFF \
							-DBUILD_opencv_python3=OFF \
							-DBUILD_opencv_dnn=OFF \
							-DBUILD_opencv_imgcodecs=OFF \
							-DBUILD_opencv_videoio=OFF \
							-DBUILD_opencv_calib3d=OFF \
							-DBUILD_opencv_flann=OFF \
							-DBUILD_opencv_objdetect=OFF \
							-DBUILD_opencv_stitching=OFF \
							-DBUILD_opencv_ml=OFF

define OPENCV_MOBILE_EXTRACT_CMDS
	$(UNZIP) -d $(BUILD_DIR) $(OPENCV_MOBILE_DL_DIR)/$(OPENCV_MOBILE_SOURCE)
endef

$(eval $(cmake-package))
