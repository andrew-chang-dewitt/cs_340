% Lecture 01 - Intro to Haskell
% CS 340, Spring 2025

> module Lec_01 where

Operators
=========

Basic arithmetic

> arithmetic = do 
>   putStrLn ( ( "2 + 15 => " ++ show ( 
>     2 + 15  -- => 17 
>     )))
>   putStrLn ( ( "17 - 2 => " ++ show ( 
>     17 - 2 -- => 15
>     )))
>   putStrLn ( ( "15 * 2 => " ++ show ( 
>     15 * 2 -- => 30
>     )))
>   putStrLn ( ( "30 / 3 => " ++ show ( 
>     30 / 3 -- => 10.0 -- NOTE: this may take ints, but always outputs a float
>     )))

Technically, these are functions. Specifically, _infix_ functions. They can be called as _prefix_ functions instead, like this:

>   putStrLn ( ( "(+) 2 15 => " ++ show ( 
>     (+) 2 15 -- => 17
>     )))
>   putStrLn ( ( "(-) 17 2 => " ++ show ( 
>     (-) 17 2 -- => 15
>     )))
>   putStrLn ( ( "(*) 15 2 => " ++ show ( 
>     (*) 15 2 -- => 30
>     )))
>   putStrLn ( ( "(/) 30 3 => " ++ show ( 
>     (/) 30 3 -- => 10
>     )))

Defining functions looks like assignment (because it is):

> repeatStr str = str ++ str

In `repeatStr` we defined a function that accepts an argument called `str`, and returns that argument concatenated to itself.
Then we can call it like this:

> -- for reasons discussed later, we'll wrap this call of our fn in another function
> callRepeat = do
>   repeatStr "hello world! "

Functions can take args, like we saw above. Interestingly, they can also _imply_ args in what is called a **partially-applied function**:

> pwOfTwo = (^2)

As you'll see when executed, this function takes an implied argument & raises it to the power of two.

> callTwoPwOfTwo = pwOfTwo 2 -- => 4
> callThreePwOfTwo = pwOfTwo 3 -- => 9

Notice the assignment expressions above--`callTwoPwOfTwo` & `callThreePwOfTwo` are top-level variables that evaluate to the assigned expressions.
These variables can be interacted with later, like this:

> threePwOfTwoPwOfTwo = pwOfTwo callThreePwOfTwo -- => (3^2)^2 => 81








> -- main to call all the code defined above
> main = do
>   arithmetic
>   putStrLn callRepeat
>   putStrLn (show callTwoPwOfTwo)
>   putStrLn (show callThreePwOfTwo)
>   putStrLn (show threePwOfTwoPwOfTwo)
> -- _Here's a couple blank lines to output at the end of this file, just to pad things nicely_.
>   putStrLn "\n"
