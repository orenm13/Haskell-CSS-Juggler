#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz -i runhaskell -p "pkgs.haskell.packages.ghc802.ghcWithPackages (pkgs: with pkgs; [ aeson twitch hint clay websockets])"

{-# LANGUAGE PackageImports #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

import qualified "containers" Data.Map as M
import           "aeson"      Data.Aeson (encode)
import           "process"    System.Process
import           "mtl"        Control.Monad.State as CMS
import           "base"       Control.Monad (forever)
import           "base"       Control.Concurrent (forkIO)
import           "base"       Control.Monad.IO.Class (liftIO)
import qualified "bytestring" Data.ByteString.Lazy.Char8 as BL8 (unpack)
import           "text"       Data.Text (Text, pack, unpack)
import           "text"       Data.Text.Lazy (toStrict)
import           "filepath"   System.FilePath (takeBaseName)
import           "stm"        Control.Concurrent.STM (atomically)
import           "stm"        Control.Concurrent.STM.TBQueue (TBQueue, newTBQueueIO, readTBQueue, writeTBQueue)
import           "twitch"     Twitch
-- ^ https://hackage.haskell.org/package/twitch
import           "hint"       Language.Haskell.Interpreter
-- ^ https://hackage.haskell.org/package/hint-0.7.0/docs/Language-Haskell-Interpreter.html
import qualified "websockets" Network.WebSockets as WS
-- ^ https://jaspervdj.be/websockets/example/server.html


type JugglerMap = M.Map FilePath Text
type JugglerQueue = TBQueue JugglerMap

dynamicLoad :: FilePath -> IO (Either InterpreterError (IO Text))
dynamicLoad path = runInterpreter . load_ $ path
    where
        load_ :: FilePath -> Interpreter (IO Text)
        load_ path = do
            loadModules [path]
            setTopLevelModules [takeBaseName path]
            setImports ["Prelude"]
            interpret "main" (as :: IO Text)

watcher :: JugglerQueue
        -> JugglerMap
        -> IO ()
watcher queue cssMap = defaultMain $ do
    let myMap = M.empty
    "*.hs" |> \filepath -> do
        interpreterResult <- dynamicLoad filepath

        case interpreterResult of
            Left err -> do
                case err of
                    WontCompile errs -> do
                        forM_ errs $ \err -> do
                            putStrLn $ errMsg err
                    _ -> do
                        print err
                watcher queue cssMap

            Right getCss -> do
                css <- getCss
                print "----------------------------------------------------------------------------------------------------------------"
                putStrLn $ unpack css
                print "----------------------------------------------------------------------------------------------------------------"
                let changedMap = M.insert filepath css cssMap
                atomically $ writeTBQueue queue changedMap
                watcher queue changedMap


application :: JugglerQueue -> WS.ServerApp
application queue pending = do
    conn <- WS.acceptRequest pending
    WS.forkPingThread conn 30
    forever $ do
        map_ <- liftIO $ atomically $ readTBQueue queue
        WS.sendTextData conn . pack . BL8.unpack . encode $ map_


server :: JugglerQueue -> IO ()
server queue = do
    WS.runServer "127.0.0.1" 9160 $ application queue


main :: IO ()
main = do
    queue <- newTBQueueIO 4096
    forkIO $ server queue
    watcher queue M.empty
