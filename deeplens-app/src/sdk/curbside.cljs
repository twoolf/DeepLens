(ns sdk.curbside
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [chan <! >! put! close! timeout promise-chan]]
   [cljs-http.client :as http]
   [taoensso.timbre :as timbre]
   [util.chan :as chan]))

;; https://developer.curbside.com/docs/getting-started/quickstart-web-app/
;;
;; Suggested improvements:
;; create immutable object from curbside with settings instead of destructing

(def dependencies-script
  {:script "https://hosted.curbside.com/1.0/curbside.dependencies.js"})

(def sdk-script
  {:script "https://hosted.curbside.com/1.0/curbside.sdk.js"})

(defn curbside []
  (when-not (exists? js/Curbside)
    (timbre/warn "Curbside SDK not loaded"))
  js/Curbside)

(defn set-app-id [id]
  (.setAppId (curbside) id))

(defn set-usage-token [token]
  (.setUsageToken (curbside) token))

(defn set-tracking-id [id]
  (.setTrackingIdentifier (curbside) id))

(defn start-trip [{:keys [site-id track-token]}]
  (.startTripToSiteWithIdentifier (curbside)
                                  #{:siteID site-id :trackToken track-token}))

(defn cancel-trip [{:keys [site-id track-token]}]
  (.cancelTripToSiteWithIdentifier (curbside)
                                  #{:siteID site-id :trackToken track-token}))
