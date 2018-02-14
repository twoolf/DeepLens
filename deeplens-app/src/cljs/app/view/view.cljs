(ns app.view.view
  (:require-macros
   [kioo.reagent
    :refer [defsnippet deftemplate snippet]])
  (:require
   [kioo.reagent
    :refer [html-content content append after set-attr do->
            substitute listen unwrap]]
   [reagent.core :as reagent
    :refer [atom]]
   [app.mobile.core :as mobile]
   [app.dashboard.core :as dashboard]
   [app.view.split :as split]))

(defn loading-view [{:keys [modes] :as session}]
  [:div {:style {:margin-top "5em" :padding "3em"}}
   #_
   [:div {:style {:margin-top "5em" :padding "3em"}}
    [:div.progress
     [:div.progress-bar.progress-bar-animated
      {:role "progress-bar"
       :aria-valuenow "100"
       :aria-valuemin "0"
       :aria-valuemax "100"
       :style {:width "100%"}}]]]
   (into [:ul.list-group]
         (for [{:keys [id title] :as item} (if modes @modes)]
           [:a.list-group-item {:href (str "/#" id)}
            title]))])

(defn view [{:keys [mode] :as session}]
  (case (if mode @mode)
    ("mobile")
    [mobile/view session]
    ("dashboard")
    [dashboard/view session]
    ("split")
    [split/view session]
    (nil)
    [loading-view session]))
