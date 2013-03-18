(use 'clojure.test)
(require '[clojure.string :as str])
(require '[clojure.stacktrace :as st])

(def original-report clojure.test/report)
(def ^:dynamic results nil)

(def events-map
  {:pass :passed
   :fail :failed
   :error :failed})

(defn accumulating-report
  [{event-type :type test-name :message :as event}]
  (original-report event)
  (when (and results (events-map event-type))
    (swap! results update-in [(events-map event-type)] #(conj % test-name))))

(def empty-results {:passed [] :failed []})

(defn run-tests-for-evans []
  (let [test-stream (java.io.StringWriter.)]
    (binding [*test-out* test-stream
              *out* test-stream
              *err* test-stream
              results (atom empty-results)
              report accumulating-report]
      (try
        (load-file "solution.clj")
        (load-file "test.clj")
        (run-tests)
        (assoc @results :log (str test-stream))
        (catch Exception e
          (st/print-stack-trace e)
          (assoc empty-results :log (str test-stream)))))))

(let [{:keys [passed failed log]} (run-tests-for-evans)]
  (print "Passed: ")
  (->> passed (str/join ";") println)
  (print "Failed: ")
  (->> failed (str/join ";") println)
  (print log))
