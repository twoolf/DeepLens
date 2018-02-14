(ns util.lib
  (:require-macros
   [cljs.core.async.macros :refer [go go-loop]])
  (:require
   [cljs.core.async :refer [<!]]))

#_
(defn echo [ch]
  (go-loop []
    (when-let [item (<! ch)]
      (println item)
      (recur))))

(defn node? []
  (exists? goog/nodeGlobalRequire))
