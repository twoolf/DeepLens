(ns app.mobile.pane
  (:require
   [reagent.core :as reagent
    :refer [atom]]
   [re-frame.core :as rf]
   [cljsjs.material-ui]
   [cljs-react-material-ui.core :as material
    :refer [get-mui-theme color]]
   [cljs-react-material-ui.reagent :as ui]
   [cljs-react-material-ui.icons :as ic]
   [goog.string :as gstring]))

(defmulti pane (fn [{:keys [stage] :as session}]
                  (if stage [@stage])))

(defmethod pane :default [{:keys [mobile] :as session}]
  [ui/card {:style {:min-height "100vh"}}
   [ui/card-title
    {:title "Symptoms"
     :subtitle "Which symptoms do you experience?"}]
   [ui/card-text
    (if mobile
      [ui/chip
       [:div {:style {:font-size "larger"
                      :font-weight "bold"}}
        "Severity: "
        (:symptom/severity @mobile)]]
      [:div])]
   [ui/card-text
    [ui/checkbox
     {:label "Itching"
      :checked (:symptom/itching (if mobile @mobile))
      :on-check #(rf/dispatch [:mobile :symptom/itching %2])}]
    [ui/checkbox
     {:label "Swelling"
      :checked (:symptom/swelling (if mobile @mobile))
      :on-check #(rf/dispatch [:mobile :symptom/swelling %2])}]
    [ui/checkbox
     {:label "Burning"
      :checked (:symptom/burning (if mobile @mobile))
      :on-check #(rf/dispatch [:mobile :symptom/burning %2])}]]
   [ui/card-text
    [:div {:style {:margin-top "1em"}}
     "Fatigue:"]
    [ui/slider
     {:min 0
      :max 100
      :default-value (:symptom/fatigue (if mobile @mobile))}]]
   [ui/card-actions
    [ui/raised-button
     {:label "Report" :style {:margin-left "8em"}}]
    [:div {:style {:margin-bottom "10em"}}]]])
