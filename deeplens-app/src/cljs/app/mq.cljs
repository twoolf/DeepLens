(ns app.mq
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [<! chan put!]]
   [taoensso.timbre :as timbre]
   [re-frame.core :as rf]
   [mount.core :as mount
    :refer [defstate]]
   [cljsjs.paho]))

(def Paho js/Paho.MQTT.Client)

(defn client [{:keys [hostname port id options]}
              {:keys [on-connection-lost
                      on-message-arrived
                      on-connect]
               :or {on-connection-lost #(timbre/error %)
                    on-message-arrived #(timbre/debug %)
                    on-connect #(timbre/info "Connected")}}]
  (let [client (new Paho hostname port id)]
    (aset client "onConnectionLost"
          #(on-connection-lost (clj->js %)))
    (aset client "onMessageArrived"
          #(on-message-arrived (clj->js %)))
    (.connect client options #js{:onSuccess on-connect})))

(defn subscribe-chan [{:as endpoint}]
  (let [out (chan)]
    (client endpoint
            {:on-message-arrived #(put! out %)})
    out))

(defn dispatcher [tag endpoint]
  (client endpoint
          {:on-message-arrived #(rf/dispatch [tag %])}))
