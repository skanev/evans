require 'spec_helper'

describe "Parsing Clojure code", clojure: true do
  it "returns false for invalid code" do
    Language::Clojure.parses?(<<-END).should be_false
(defn abs [x] (if (pos? x) x (- x)
END
  end

  it "returns true for valid code" do
    Language::Clojure.parses?(<<-END).should be_true
(defn abs [x] (if (pos? x) x (- x)))
END
  end

  it "returns true for no code" do
    Language::Clojure.parses?("").should be_true
  end
end
