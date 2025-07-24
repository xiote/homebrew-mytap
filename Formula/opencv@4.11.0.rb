class OpencvAT4110 < Formula
  desc        "Open source computer vision library"
  homepage    "https://opencv.org/"
  url         "https://github.com/opencv/opencv/archive/4.11.0.tar.gz"
  sha256      "9a7c11f924eff5f8d8070e297b322ee68b9227e003fd600d4b8122198091665f"   # 정확한 SHA256 입력
  license     "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  # 나머지 의존성 생략

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.11.0/modules
      -DCMAKE_OSX_ARCHITECTURES=arm64
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "-j#{`sysctl -n hw.physicalcpu`}"
      system "make", "install"
    end
  end
end
