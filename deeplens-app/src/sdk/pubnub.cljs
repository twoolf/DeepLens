(ns sdk.pubnub
  (:require
   [util.lib :as lib]
   [util.env :as env
    :refer [env]]))

;; Dependencies: [cljsjs/pubnub "4.1.1-0"]

(defonce PubNub
  (if (lib/node?)
    (js/require "pubnub")
    js/PubNub))

(defn new-pubnub [config]
  (new PubNub (clj->js config)))

(def config {:publishKey   (or (env "PUBNUB_PUBLISH_KEY")
                               "pub-c-9fa72b4b-080d-4483-8f26-c10f390749ed")
             :subscribeKey (or (env "PUBNUB_SUBSCRIBE_KEY")
                               "sub-c-51fe3994-092b-11e8-be21-ca57643e6300")})

(def pubnub (new-pubnub config))

#_
(list pubnub)

(def twitter-config
  {:subscribeKey "sub-c-78806dd4-42a6-11e4-aed8-02ee2ddab7fe"})

(def twitter-pubnub (new-pubnub twitter-config))

(defn add-listener [pubnub args]
  (.addListener pubnub (clj->js args)))

(defn subscribe
  ([args]
   (subscribe pubnub args))
  ([pubnub {:keys [channels] :as args}]
   (.subscribe pubnub (clj->js args))))

(defn publish
  ([msg]
   (publish pubnub msg))
  ([pubnub msg]
   (.publish pubnub (clj->js msg))))
