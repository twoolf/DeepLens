(ns util.stepper
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

;; material-ui stepper abstraction
;; incomplete

(defn step [{:keys [label final step-index]} content]
  [ui/step
   [ui/step-label label]
   [ui/step-content {}
    content]
   [ui/step-content {:style {:margin-top "1em"}}
    [:div {:style {:display (if final "none")}}
      [ui/flat-button {:label "Next"
                       :on-click #(swap! step-index inc)}]]]])

(defn stepper [{:as session}]
  (let [step-index (atom 0)
        slider-value (atom 0)]
    (fn [{:keys []
          :as session}]
      [ui/stepper {:active-step @step-index
                   :orientation "vertical"}
       (step {:label "Name" :step-index step-index}
             [ui/text-field
              {:hint-text "Type in your name"}])
       (step {:label "Group Size"  :step-index step-index}
             [ui/slider
              {:value @slider-value
               :on-change (fn [e val]
                            (rf/dispatch [:family-size val]))
               :min 1
               :max 9
               :step 1}])
       (step {:label "Get Supplies"
              :final true
              :step-index step-index}
             [ui/raised-button
              {:label "Submit Request"
               :on-click #(rf/dispatch [:arrive/go-pickup])}])])))
