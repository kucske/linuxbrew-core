class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2020/sqlite-src-3320200.zip"
  version "3.32.2"
  sha256 "e027dd65738eb03fa87d79075a0ec2db2d2c7ad8ebca9ad2a0e96e6612d210cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b48cfd2b1f7e1450a00eec56ea893a015b49574e502c4cef1ceefbc133cdf14" => :catalina
    sha256 "d624c2bbee9a75970dd80c7316f46653876b0032596b0a6e9013bc939098e1c3" => :mojave
    sha256 "37efa4b900a25b20852f92dfa35661cda98d38ddc7d7937e9bbf18c1abce2bc9" => :high_sierra
    sha256 "d91300cf5458c3981d140ffd1a42235b859d46e1c205376ec11614385757b758" => :x86_64_linux
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlite = OS.mac? ? "/usr/bin/sqlite3" : Formula["sqlite"].bin/"sqlite3"
    sqlpath.write "create table test (name text);"
    system "#{sqlite} #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
