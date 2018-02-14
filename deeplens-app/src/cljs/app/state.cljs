(ns app.state
  (:require
   [camel-snake-kebab.core
    :refer [->kebab-case-keyword]]
   [camel-snake-kebab.extras
    :refer [transform-keys]]))

(defn transform-kebab-keys [m]
  (transform-keys ->kebab-case-keyword m))

(def state
  {:brand "DermLens"
   :modes [{:id "split" :title "Split"}
           {:id "mobile" :title "Mobile"}
           {:id "dashboard" :title "Dashboard"}]
   :mode "mobile"
   :stage nil
   :mobile {:stage nil
            :symptom/itching false
            :symptom/swelling true
            :symptom/burning false
            :symptom/fatigue 60
            :symptom/severity "20%"}
   :panes [{:id "about" :title "About"}
           {:id "main" :title "Main"}
           {:id "info" :title "Info"}]
   :pane "info"})
