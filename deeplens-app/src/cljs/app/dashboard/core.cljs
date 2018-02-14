(ns app.dashboard.core
  (:require
   [goog.string :as gstring]
   [reagent.core :as reagent
     :refer [atom]]
   [re-frame.core :as rf]
   [taoensso.timbre :as timbre]
   [cljsjs.material-ui]
   [cljs-react-material-ui.core :as material
     :refer [get-mui-theme color]]
   [cljs-react-material-ui.reagent :as ui]
   [cljs-react-material-ui.icons :as ic]
   [app.dashboard.toolbar :as toolbar
    :refer [toolbar]]
   [app.dashboard.pane
    :refer [pane]]
   [app.dashboard.about :as about]
   [app.dashboard.info :as info]
   [app.dashboard.main :as main]))

(defmethod pane ["about"] [session]
  [about/view session])

(defmethod pane ["main"] [session]
  [main/view session])

(defmethod pane ["info"] [session]
  [info/view session])

(defn notification [{:keys [stage] :as session}]
  (timbre/debug "NOTIFICATION=" session)
  (let [stage (if stage @stage)]
    [:div.alert.alert-info
     {:role "alert"
      :style {:display (if-not (= stage "payed")
                         "none")}}
     "The patient has paid for the visit with WELL tokens"]))

(defn panel [session]
  (timbre/debug "PANEL="
                (if (:pane session) @(:pane session))
                session)
  [pane session])

(defn view [session]
 (let [selected (rf/subscribe [:pane])]
   (fn [{:keys [stage providers] :as session}]
     (let [session (assoc session :pane selected)]
       (timbre/debug "SESSION=" session)
       [ui/mui-theme-provider
        {:mui-theme (get-mui-theme
                     {:palette
                      {:primary1-color "#9DCFE1"
                       :primary2-color (color :deep-blue700)
                       :primary3-color (color :deep-blue200)
                       :alternate-text-color (color :white) ;; used for appbar text
                       :primary-text-color (color :light-black)}})}
        [:div {}
         [toolbar session]
         [notification session]
         [panel session]]]))))
