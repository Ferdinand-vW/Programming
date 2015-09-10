module Main where

import Control.Monad (forever)
import Control.Concurrent
import qualified System.FSNotify as F
import Graphics.UI.WX

gridLabels :: [(String, Align, Int)]
gridLabels = [("Event", AlignCentre, 50),
              ("FileName", AlignCentre, 100),
              ("Size", AlignCentre, 100),
              ("Time", AlignCentre, 100),
              ("Directory", AlignCentre, 150)]

entries :: [[[Char]]]
entries = [["Added", "Test.hs", "100KB", "21:09", "Downloads"]]


main :: IO ()
main = start (program entries)

program :: [[[Char]]] -> IO ()
program lItems = do
    f <- frameFixed  [bgcolor := framecolor, text := "FileWatcher", clientSize := sz 500 300]
    
    menuPanel <- panel f [bgcolor := white, clientSize := sz 480 80, position := pt 10 10]
    remove  <- button menuPanel [text := "Remove", position := pt 100 50]
    add <- button menuPanel [text := "Add", position := pt 200 50]
    

    dirPanel <- panel f [bgcolor := red, clientSize := sz 480 20, position := pt 10 100]
    

    eventPanel <- panel f [bgcolor := white, clientSize := sz 480 150, position := pt 10 130]
    list <- listCtrl eventPanel [columns := gridLabels,
                                 items := lItems,
                                 clientSize := sz 480 150, position := pt 0 0]
    forkIO $ startListening (list, lItems) "."
    return ()

addEntry :: [[String]] -> [[String]]
addEntry entries = ["Removed", "Test.hs", "100KB", "21:21", "Downloads"] : entries

framecolor :: Color
framecolor = rgb 100 100 100

startListening :: (ListCtrl(),[[String]]) -> FilePath -> IO ()
startListening list fp =
    do
        events <- newChan
        F.withManager $ \mg -> do
            _ <- F.watchTreeChan mg fp (const True) events
            forever(printMessage events list)

printMessage :: Chan F.Event -> (ListCtrl(),[[String]]) -> IO ()
printMessage c (l, xs) = do
        ev <- readChan c
        set l [items := ["Event", getFilePath ev, "50KB", "time", "dir"] : xs] 


getFilePath :: F.Event -> String
getFilePath (F.Added fp _) = fp
getFilePath (F.Removed fp _) = fp
getFilePath (F.Modified fp _) = fp