
file = IO.readlines("game.in")
puts "Number of test cases: " + file[0] 
i=1
for x in 1..file[0].chop.to_i
    #Set number of gear types
    numGearTypes = file[i].chop.to_i
    #Set up arrays
    gearCounts = Array.new
    gearProbs = Array.new

    for curGearType in 1..numGearTypes
        #split gear desc and do proper encoding
        line = file[i+curGearType].split(" ")
        curCount = line[0].to_i
        curProb = line[1].to_f

        #push to arrays
        gearCounts.push(curCount)
        gearProbs.push(curProb)
    end
    numTries = file[i+numGearTypes+1].chop.to_i

    curProb = Array.new(numTries+1, 0.0)
    nextProb = Array.new(numTries+1, 0.0)
    curProb[0] = 1.0

    for curGearType in 0..numGearTypes-1
        for curGear in 0..gearCounts[curGearType]-1
            for curTry in 0..numTries-1
                curProb[curTry+1] += curProb[curTry]*(1.0 - gearProbs[curGearType])
            end

            for curTry in 0..numTries
                nextProb[curTry] = 0.0
            end
            for curTry in 0..numTries-1
               nextProb[curTry+1] += curProb[curTry]*gearProbs[curGearType]
            end
           
            swp = curProb
            curProb = nextProb
            nextProb = swp 
        end
     end
    answer = 0.0
    for curTry in 0..numTries
        answer += curProb[curTry]
    end
    i += numGearTypes+2
    puts "#{ '%.3f' % answer}"
end
