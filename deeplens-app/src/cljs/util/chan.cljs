(ns util.chan
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [<! chan close! alts! timeout put!]]
   [taoensso.timbre :as timbre]))

(defn echo [ch]
  (go
   (when-let [msg (<! ch)]
     (timbre/info msg))))
