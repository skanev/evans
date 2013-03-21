(use '[clojure.test :exclude (is)])
(require '[clojure.string :as str])
(require '[clojure.stacktrace :as st])

(def original-report clojure.test/report)
(def ^:dynamic results nil)

(def events-map
  {:pass :passed
   :fail :failed
   :error :failed})

(defmacro with-timeout [& body]
  `(let [f# (future ~@body)]
     (when (= (deref f# 1000 :not-finished) :not-finished)
       (future-cancel f#)
       (throw (RuntimeException. "Execution timed out")))
     @f#))

(defmacro is [check name]
  `(clojure.test/is (with-timeout ~check) ~name))

(defn accumulating-report
  [{event-type :type test-name :message :as event}]
  (original-report event)
  (when (and results (events-map event-type))
    (swap! results update-in [(events-map event-type)] #(conj % (or test-name "<Unnamed>")))))

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
  (println log))

(System/exit 0) ; We call this, because there might be futures that are still running
