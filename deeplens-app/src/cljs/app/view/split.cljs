(ns app.view.split
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
   [app.dashboard.core :as dashboard]))

(defn view [session]
  [:div
    [:div {:style {:width "30%"
                   :float "left"}}
      [:div.phone
        [:div.phone-screen
          [mobile/view session]]]]
    [:div {:style {:width "60%"
                   :height "100vh"
                   :border-left "thin solid gray"
                   :float "right"}}
      [dashboard/view session]]])
