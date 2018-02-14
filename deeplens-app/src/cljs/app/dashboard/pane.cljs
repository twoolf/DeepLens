(ns app.dashboard.pane
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
   [cljs-react-material-ui.icons :as ic]))

(defn pane-dispatcher [{:keys [pane] :as session}]
  (if pane [@pane]))

(defmulti pane pane-dispatcher)

(defmethod pane :default [{:keys [panes] :as session}]
  (let [current (pane-dispatcher session)]
    (timbre/warn "No pane dispatch for" current))
  [:div {:style {:padding-top "3em"
                 :margin-left "25%"
                 :width "50%"}}
   [:div.progress
    [:div.progress-bar.progress-bar-animated
     {:role "progress-bar"
      :aria-valuenow "100"
      :aria-valuemin "0"
      :aria-valuemax "100"
      :style {:width "100%"}}]]])
