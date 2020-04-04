--read 2 ints from stdin
readInts :: IO [Integer]
readInts = fmap (map read.words) getLine

-- generate primes using eratos sieve
genPrimes :: Integer -> [Integer]
genPrimes m = 2 : sieve [3,5..m]
    where
    sieve (p:xs)
        | p*p > m = p : xs
        | otherwise    = p : sieve [x | x <- xs, rem x p > 0]
    sieve [] = []

-- handle cases function
handleCase :: [Integer] -> IO()
handleCase [a,b] = do
  let lastValueA = a
  let lastValueB = b
  let r = genPrimes lastValueA
  let evenCount = div lastValueB 2
  -- i attempted an algo for the best case however it seems off
  if lastValueA > 2 then do
    let oddCount = div lastValueB 3
    let primesTotal= toInteger (length r)
    let sum1 = evenCount+oddCount
    if lastValueA >= 4
      then do
        -- handle s1-(range - primes)
        let sum2 =  sum1 - (lastValueA-4- (primesTotal-3))
        if sum2 < lastValueA then do
          let sum3 = sum1 + primesTotal
          print sum3
          else print sum2
        else do
          -- if value is less than 4 remove every 6th
          let e6 = div lastValueB 6
          let sum2 = sum1 - e6
          print sum2
  else print evenCount
-- Handle catchall case
handleCase _= return ()

getcases :: Integer -> IO()
getcases 0 = return ()
getcases x = do
  cases1 <- readInts
  let [a,b] = cases1
  if b <= a
    then do
      -- handle 1 off case immediately
      print (b-1)
      getcases (x-1)
    else do
      -- send to handle cases
      handleCase [a,b]
      -- call getcases again
      getcases (x-1)

-- Main only does input output
main :: IO()
main = do
    -- start the program off
    cases <- getLine
    let x = read cases :: Integer
    getcases x
