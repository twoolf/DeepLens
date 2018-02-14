(ns server.polyfill-test
  (:require
   [cljs.test :refer-macros [deftest is testing run-tests]]
   [polyfill.compat :as compat]))

(deftest test-nodelist
  (is js/NodeList))
