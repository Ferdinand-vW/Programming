module Main where

import Control.Monad (forever)
import Control.Concurrent
import qualified System.FSNotify as F
import Graphics.UI.WX

main :: IO ()
main = start program

program :: IO ()
program = do
    f <- frame  [bgcolor := framecolor, text := "FileWatcher", clientSize := sz 500 300]
    menuPanel <- panel f [bgcolor := white, clientSize := sz 480 80, position := pt 10 10]
    remove  <- button menuPanel [text := "Remove", position := pt 100 50]
    add <- button menuPanel [text := "Add", position := pt 200 50]
    dirPanel <- panel f [bgcolor := red, clientSize := sz 480 20, position := pt 10 100]
    eventPanel <- panel f [bgcolor := white, clientSize := sz 480 150, position := pt 10 130]
    return ()


framecolor :: Color
framecolor = rgb 100 100 100

startListening :: FilePath -> IO (Chan F.Event)
startListening fp =
    do
        events <- newChan
        F.withManager $ \mg -> do
            _ <- F.watchTreeChan mg fp (const True) events
            return events

printMessage :: Chan F.Event -> IO ()
printMessage c = do
        msg <- readChan c
        print msg

