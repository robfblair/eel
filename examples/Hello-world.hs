module Main where
import Eel
import Data.Int

--Do this so the types are inferred
allocChar :: V Int32 -> M( V ( Ptr Char ) )
allocChar = alloca

--Wrap puts\
puts :: V( Ptr Char ) -> M( V Int32 )
puts = ffi "puts"

main :: IO ()
main = mainM "hello-world.ll" $ \(_argc, _argv) -> do
    let hello = "hello, world!" ++ ['\0']
    --Eel has no global memory so we need to specifically
    --ask for some memory on the stack to hold our string
    strPtr <- allocChar $ lit $ fromIntegral $ length $ hello
    --This part is all Brett here, the general idea is that
    --we need to store each character from out string into
    --our memory on the stack. We have getelemptr which takes
    --an initial pointer and an index into it and returns a pointer
    --to that element (it's array indexing basically). 
    --So we zip our hello world list with a zero indexed sequence.
    --Then we get the element ptr based on indices in the list and
    --store each character at each index. Use sequence_ to keep it looking
    --Haskelly
    sequence_ [ (getelementptr strPtr $ (lit (index::Int8))) >>= (store $ lit character) | (index, character) <- zip [0..] $ hello ]
    ret <- puts strPtr
    return $ lit 0
