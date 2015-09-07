module Main where


import Database.HDBC
import Database.HDBC.Sqlite3

main :: IO ()
main = do
	conn <- connectSqlite3 "Movies.db"
	programState
	disconnect conn
	
programState :: IO ()
programState = do
	line <- getLine
	putStrLn line