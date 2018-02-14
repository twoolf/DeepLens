(ns app.routes
  (:require
   [cljs.core.async :as async
    :refer [<!]]
   [goog.dom :as dom]
   [goog.events :as events]
   [goog.history.EventType :as EventType]
   [taoensso.timbre :as timbre]
   [re-frame.core :as rf]
   [secretary.core :as secretary
    :refer-macros [defroute]]
   [app.session :as session])
  (:import
   [goog History]))

(secretary/set-config! :prefix "#")

(def history
  (memoize #(History.)))

(defn navigate! [token & {:keys [stealth]}]
  (if stealth
    (secretary/dispatch! token)
    (.setToken (history) token)))

(defn hook-browser-navigation! []
  (doto (history)
    (events/listen EventType/NAVIGATE
                   (fn [event]
                     (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defroute "/" []
  nil)

(defroute "/split" []
  (rf/dispatch [:mode "split"]))

(defroute "/dashboard" []
  (rf/dispatch [:mode "dashboard"]))

(defroute "/mobile" []
  (rf/dispatch [:mode "mobile"]))
