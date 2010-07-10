desc "Run tests"
task :test do
  test_files = File.join(File.dirname(__FILE__), "*_test.rb")
  system "ruby #{test_files}"
end

task :default => :test
