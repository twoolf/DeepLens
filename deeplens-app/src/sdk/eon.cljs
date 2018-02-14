(ns sdk.eon
  (:require
   [sdk.pubnub :as pubnub
    :refer [pubnub]]
   [reagent.core :as reagent
    :refer [atom]]))

;; assumes //pubnub.github.io/eon/v/eon/1.0.0/eon.css

(def script {:src "//pubnub.github.io/eon/v/eon/1.0.0/eon.js"})

(defn eon []
  (if (exists? js/eon)
    js/eon))

#_
(eon)

(defn enable-chart
  ([eon config]
   {:pre [(some? eon)]}
   (.chart eon (clj->js config))))

(defn chart
  ([config]
   [chart {:style {:width "100%"
                   :min-height "15em"}}
          config])
  ([attr config]
   {:pre [(:id config)]}
   (reagent/create-class
    {:component-did-mount #(enable-chart (eon) config)
     :reagent-render (fn [attr config]
                       [:div (assoc attr :id (:id config))])})))

(defn gauge-chart [{:keys [id channel pubnub]}]
      [chart {:channels [channel]
              :id id
              :pubnub pubnub
              :generate {:bindto (str "#" id)
                         :gauge {:min 0 :max 100}
                         :color {:pattern ["#FF0000" "#F6C600" "#60B044"]}
                         :threshold {:values [20 40 60]}
                         :data {:labels true
                                :type "gauge"}}}])

(defn donut-chart [{:keys [id channel pubnub]}]
      [chart {:channels [channel]
              :id id
              :pubnub pubnub
              :generate {:bindto (str "#" id)
                         :data {:labels true
                                :type "donut"}}}])

(defn coinchart [{:keys [channel pubnub id low hi spread]}]
      [chart {:channels [channel]
              :id id
              :history true ; true leads to error unless pubnub has enabled history!
              :flow true
              :limit 15
              :pubnub pubnub
              :generate {:bindto (str "#" id)
                         :data {:labels false :type "line"}
                         :axis {:y {:padding {:top (or hi (if (and low spread)
                                                            (* low spread)
                                                            :topPadding))
                                              :bottom (or low :bottomPadding)}
                                    :tick {:fit true}}
                                :x {:type "timeseries"
                                    :tick {:format "%M:%S" #_"%H:%M:%S"
                                           :fit true}}}}}])
