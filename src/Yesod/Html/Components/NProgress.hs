{-# LANGUAGE OverloadedStrings #-}

module Yesod.Html.Components.NProgress where

import Data.Aeson(ToJSON(toJSON), object, (.=))
import Data.Text(Text)
import Yesod.Core(MonadWidget, whamlet)
import Yesod.Core.Widget(addScriptRemote, addStylesheetRemote)

jsFile :: Text
jsFile = "https://unpkg.com/nprogress@0.2.0/nprogress.js"

cssFile :: Text
cssFile = "https://unpkg.com/nprogress@0.2.0/nprogress.css"

data NProgressConfig = NProgressConfig { trickle :: Bool, trickleSpeed :: Int, showSpinner :: Bool }

instance ToJSON NProgressConfig where
    toJSON (NProgressConfig t ts ss) = object [
        "trickle" .= t,
        "trickleSpeed" .= ts,
        "showSpinner" .= ss
      ]

defaultNProgressConfig :: NProgressConfig
defaultNProgressConfig = NProgressConfig True 200 False

nProgressWidget :: MonadWidget m => m ()
nProgressWidget = addScriptRemote jsFile >> addStylesheetRemote cssFile
