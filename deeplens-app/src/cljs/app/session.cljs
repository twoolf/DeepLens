(ns app.session
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [<!]]
   [reagent.core :as reagent]
   [re-frame.core :as rf
    :refer [reg-sub]]
   #_[re-frame.http-fx]
   [util.rflib :as rflib
    :refer [reg-property]]
   [app.mq :as mq]
   [taoensso.timbre :as timbre]
   [cljs-http.client :as http]))

(def interceptors [#_(when ^boolean js/goog.DEBUG debug)
                   rf/trim-v])

(defn state [initial]
  (->> initial
       (map #(vector (first %)(reagent/atom (second %))))
       (into {})))

(defn subscriptions [ks]
  (into {} (map #(vector % (rf/subscribe [%])) ks)))

(defn initialize [initial]

  (rf/reg-event-db
   :initialize
   (fn [db _] initial))

  (rf/reg-event-db
   :update
   (fn [db [_ path f]]
     (update-in db path f)))

  (rf/reg-event-db
   :assign
   (fn [db [_ path value]]
     (timbre/debug "Assign:" path value)
     (assoc-in db path value)))

  (reg-property :brand)
  (reg-property :mode)
  (reg-property :stage)
  (reg-property :pane)
  (reg-property :mobile)

  (rf/reg-sub :panes :panes)
  (rf/reg-sub :modes :modes)

  (rf/dispatch-sync [:initialize]))
