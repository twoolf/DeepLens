(ns app.core
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [<! chan close! alts! timeout put!]]
   [goog.dom :as dom]
   [reagent.core :as reagent
    :refer [atom]]
   [re-frame.core :as rf]
   [taoensso.timbre :as timbre]
   [mount.core :as mount
    :refer [defstate]]
   [util.rflib :as rflib]
   [app.mq :as mq]
   [app.state :as state]
   [app.session :as session]
   [app.view.page
    :refer [page html5]]
   [app.view.view
    :refer [view]]))

(defn scripts [initial]
  [{:src "/js/out/app.js"}
   (str "main_cljs_fn("
        (pr-str (pr-str initial))
        ")")])

(defn static-page []
  (go-loop []
    (let [initial state/state
          state (session/state initial)]
      (-> state
          (page :scripts (scripts initial)
                :title (if (:brand state) @(:brand state) "HackBench")
                :forkme false)
          (html5)))))

(defstate reporting
  :start #(timbre/info "Starting")
  :stop #(timbre/info "Stopping"))

(def mq-endpoint {:hostname "a3u3tjptc1o2rk.iot.us-east-1.amazonaws.com"
                  #_ "ws://aws.com/things/deeplens_42887581-fe54-4769-ad18-07ba429747ff/infer"
                  :port "443"
                  :id "us-east-1:94124864-7a94-4976-8ec8-02443779e9f8"
                  :options {:useSSL true
                            :timeout 3
                            :mqttVersion 4
                            :onFailure #(timbre/error "MQTT Failed:" %)}})

(defn dispatch-mq [msg]
  (rf/dispatch [:mobile :severity (pr-str msg)]))

(defstate message-queue
  :start #(do
            (timbre/debug "Connect to AWS MQTT")
            (mq/client mq-endpoint
                     {:on-message-arrived dispatch-mq}))
  :stop #(timbre/info "Stop MQTT" message-queue))

(defn activate [initial]
  (timbre/debug "Activate App with initial settings " initial)
  #_
  (-> (cljs.reader/read-string initial)
      (session/initialize))
  (session/initialize state/state)
  (let [el (dom/getElement "canvas")
        state (session/subscriptions
               (map first state/state))]
    (reagent/render [#(view state)] el))
  (mount/start))
