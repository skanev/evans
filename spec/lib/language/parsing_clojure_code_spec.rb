require 'spec_helper'

describe "Parsing Clojure code", clojure: true do
  it "returns false for invalid code" do
    Language::Clojure.should_not be_parsing <<CODE
(defn abs [x] (if (pos? x) x (- x)
CODE
  end

  it "returns true for valid code" do
    Language::Clojure.should be_parsing <<CODE
(defn abs [x] (if (pos? x) x (- x)))
CODE
  end

  it "returns true for no code" do
    Language::Clojure.should be_parsing ""
  end
end
