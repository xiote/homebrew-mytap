class OpencvAT4110 < Formula
  desc      "Open source computer vision library"
  homepage  "https://opencv.org/"
  # 4.11.0 공식 소스 tarball
  url       "https://github.com/opencv/opencv/archive/4.11.0.tar.gz"
  # SHA-256 값은 upstream tarball 기준 (Termux 빌드 스크립트에서 확인)   [oai_citation:1‡GitHub](https://raw.githubusercontent.com/termux/termux-packages/67838d71d5/x11-packages/opencv/build.sh)
  sha256    "9a7c11f924eff5f8d8070e297b322ee68b9227e003fd600d4b8122198091665f"
  license   "Apache-2.0"

  # ---------- 필수 의존성 ----------
  depends_on "cmake"      => :build   # 빌드 도구
  depends_on "pkg-config" => :build   # 패키지 메타
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "openblas"
  # …(현재 opencv.rb 의존성을 그대로 복사해도 됨)

  # ---------- 설치 ----------
  def install
    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DBUILD_JAVA=OFF     # 불필요한 랩퍼 비활성화
      -DBUILD_TESTS=OFF
      -DBUILD_PERF_TESTS=OFF
    ]
    system "cmake", ".", *args
    system "make", "-j#{ENV.make_jobs}"
    system "make", "install"
  end

  # ---------- 간단 테스트 ----------
  test do
    (testpath/"version.cpp").write <<~EOS
      #include <opencv2/core/core.hpp>
      #include <iostream>
      int main() { std::cout << CV_VERSION; return 0; }
    EOS
    system ENV.cxx, "version.cpp", "-I#{include}/opencv4",
                    "-L#{lib}", "-lopencv_core", "-std=c++17", "-o", "ver"
    assert_match "4.11.0", shell_output("./ver")
  end
end
