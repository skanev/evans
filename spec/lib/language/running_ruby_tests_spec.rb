require 'spec_helper'

describe "Running Ruby tests", ruby: true do
  before :all do
    @test_case_code = <<END.strip
describe "Homework" do
  it("succeeds once")   { expect(true).to be true }
  it("succeeds thrice") { puts "Just to mess with you" }
  it("fails once")      { expect(true).to be false }
  it("succeeds twice")  { expect(Homework.answer).to eq 42 }
  it("fails twice")     { expect(1).to eq 2 }
  it("errors once")     { raise RuntimeError }
end
END
  end

  it "handles solutions that raise a runtime error" do
    solution = 'require "intertools"'
    results = Language::Ruby.run_tests(@test_case_code, solution)

    expect(results.passed_count).to eq 0
    expect(results.failed_count).to eq 0
  end

  it "does not depend on the CWD" do
      solution = <<-EOF
        module Homework
          def self.answer; 42; end
        end
      EOF

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        results = Language::Ruby.run_tests(@test_case_code, solution)

        expect(results.log).to include("6 examples, 3 failures")
      end
    end
  end

  describe "on successful run" do
    before(:all) do
      solution = <<~EOF
        module Homework
          def self.answer; 42; end
          puts "Another puts"
        end
      EOF
      @results = Language::Ruby.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      expect(@results.passed_count).to eq 3
    end

    it "calculates the number of failed tests" do
      expect(@results.failed_count).to eq 3
    end

    it "collects the execution log" do
      expect(@results.log).to include("6 examples, 3 failures")
    end
  end

  describe "timeouts" do
    let(:solution) do
      <<-RUBY
        module Homework
          def self.answer
            sleep 1.5
          end
        end
      RUBY
    end

    it "default to one second per example" do
      test_case = <<-RUBY
        describe "Homework" do
          it("timeouts") { Homework.answer }
        end
      RUBY

      results = Language::Ruby.run_tests(test_case, solution)
      expect(results.failed_count).to eq 1
      expect(results.passed_count).to eq 0
    end

    it "can be configured per example" do
      test_case = <<-RUBY
        describe "Homework" do
          it("timeouts", timeout: 2) { Homework.answer }
        end
      RUBY

      results = Language::Ruby.run_tests(test_case, solution)
      expect(results.failed_count).to eq 0
      expect(results.passed_count).to eq 1
    end
  end
end
