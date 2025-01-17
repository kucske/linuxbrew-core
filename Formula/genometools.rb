class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.1.tar.gz"
  sha256 "528ca143a7f1d42af8614d60ea1e5518012913a23526d82e434f0dad2e2d863f"
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "ad70e641acbcb15ab36a397118153a9df2cdc35df17e3f85a8ed2654ee66d6f7" => :catalina
    sha256 "b0706d03817d379cd234ac98263d9c9db8bd746d2f58e080a1e596856be84c36" => :mojave
    sha256 "aaba0d92269fe7da4195d3cf9861692b2437cfe6e1dc3fc04a66ab04bfd4ee95" => :high_sierra
    sha256 "d66e94274aa7b85b99c0275fecc80f1c125a11a16ee2f6edf46e6438da76f60c" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@3.8"
  depends_on "linuxbrew/xorg/libpthread-stubs" => :build unless OS.mac?

  conflicts_with "libslax", :because => "both install `bin/gt`"

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system "python3", *Language::Python.setup_install_args(prefix)
      system "python3", "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system "#{bin}/gt", "-test"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import gt"
  end
end
