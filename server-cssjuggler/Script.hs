{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Script where

import Prelude hiding (div)
import Data.Text             (Text)
import Data.Text.Lazy hiding (Text)
import Clay

main :: IO Text
main = return
     . toStrict
     . render
     $ stylesheet

stylesheet :: Css
stylesheet = do
    mdldata
    mdlLayout
    mdlButton
    body ? do
        fontSize (px 14)
    html ? do
        color ("#585858" :: Clay.Color)

mdlButton :: Css
mdlButton = ".mdl-button" ? do
    color ("#585858" :: Clay.Color)

mdlLayout :: Css
mdlLayout = ".mdl-layout__header-row" ? do
    background ("#5D5D80" :: Clay.Color)

mdldata :: Css
mdldata =  ".mdl-data-table" ? do
    td ? do
        "text-align" -: "left" --  !important"
    th ? do
        "text-align" -: "left" --  !important"

