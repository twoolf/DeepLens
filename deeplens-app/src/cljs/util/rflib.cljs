(ns util.rflib
  "Extensions for re-frame"
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [<! chan close! alts! timeout put!]]
   [re-frame.core :as rf]))

(defn dispatch-message
  "Dispatch re-frame message from channel"
  ([ch]
   (go
    (when-let [msg (<! ch)]
      (rf/dispatch msg))))
  ([k ch]
   (go
    (when-let [msg (<! ch)]
      (rf/dispatch [k msg])))))


(defn reg-property
  "Register re-frame dispatch and subscribe handlers for a property.
  Note that properties support access paths."
  ([name]
   (rf/reg-event-db name
                    (fn [db [_ & arg]]
                      (let [path (cons name (butlast arg))
                            value (last arg)]
                        (assoc-in db path value))))
   (rf/reg-sub name
               (fn [db [_ & path]]
                 (get-in db (vec (cons name path)))))
   name))

#_
(reg-property :prop)
#_
(def prop (rf/subscribe [:prop]))
#_
(list @prop)
#_
(rf/dispatch [:prop :a :b 3])

#_
(def prop1 (rf/subscribe [:prop :a]))
#_
(list @prop1)
