module Paths_fsnotify (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,2,1] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Ferdinand\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Ferdinand\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.10.2\\fsnotify-0.2.1-Afb1C6kBtPnB078YuUZH97"
datadir    = "C:\\Users\\Ferdinand\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.10.2\\fsnotify-0.2.1"
libexecdir = "C:\\Users\\Ferdinand\\AppData\\Roaming\\cabal\\fsnotify-0.2.1-Afb1C6kBtPnB078YuUZH97"
sysconfdir = "C:\\Users\\Ferdinand\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "fsnotify_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "fsnotify_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "fsnotify_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "fsnotify_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "fsnotify_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
