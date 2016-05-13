module Main where
import Eel

--Use the foreign function interface to call external functions
--The type signature matches the type of putchar, but with Eel types
--We could be extra crazy and do this oursevles, but baby steps
putchar :: V Int32 -> M( V Int32 )
putchar = ffi "putchar"

main :: IO ()
--Capture argc and argv (for main), but ignore em
main = mainM "hello-a.ll" $ \( _argc, _argv ) -> do
    --Putchar returns a value, we may be able to break some things here
    --by faking the return value, but honor system
    ret <- putchar $ lit 65
    --All good main functions need to return 0
    return $ lit 0
