class Filein
    def initialize()
        @file = IO.readlines("game.in")
        @testCase = @file.slice!(0).chop.to_i
    end
    def gettestcase()
        return @testCase
    end
    def getlines()
        return @file
    end
end

class Case
    def initialize(lines)
        @answer = 0.0 
        @numgeartypes = lines[0].chop.to_i
        @numtries = lines[-1].chop.to_i
        @gearcounts = Array.new
        @gearprobs = Array.new
        @curprob = Array.new(@numtries+1, 0.0)
        @nextprob = Array.new(@numtries+1, 0.0)
        for curgeartype in 1..@numgeartypes
                #split gear desc and do proper encoding
                line = lines[curgeartype].split(" ")
                @gearcounts.push(line[0].to_i)
                @gearprobs.push(line[1].to_f)
        end
    end 
        
    def print_prob()
        for x in 0..@numtries
            @answer += @curprob[x]
        end
        puts "#{ '%.3f' % @answer}"
    end

    def setcur(value, index)
        @curprob[index] += value
    end

    def setnext(value, index)
        @nextprob[index] += value
    end
    
    def getcur(index)
        return @curprob[index]
    end
    def overnext()
        for x in 0..@numtries
            @nextprob[x] = 0.0
        end
    end
    def getnext(i)
        return @nextprob[i]
    end
    def getgearp(i)
        return @gearprobs[i]
    end
    def getgearc(index)
        return @gearcounts[index]
    end
    def getnumgeartypes()
        return @numgeartypes
    end
    def gettries()
        return @numtries
    end
    def swap()
        swp = @curprob
        @curprob = @nextprob
        @nextprob = swp
    end
end
class Game
    def initialize()
        @ini = Filein.new
        @load = @ini.getlines()
        @totalCases = @ini.gettestcase()
    end
    def run()
        i = 0
        for x in 0..@totalCases-1
            #Set number of gear types
            #Set up arrays
            range = @load[0].chop.to_i + 2 
            cases = Case.new(@load.slice!(i, range))
            cases.setcur(1.0, 0)
            for curgeartype in 0..cases.getnumgeartypes()-1
                for curgear in 0..cases.getgearc(curgeartype)-1
                    for curtry in 0..cases.gettries()-1
                        cases.setcur(cases.getcur(curtry)*(1.0 - cases.getgearp(curgeartype)), curtry+1)
                    end

                    cases.overnext()
                    for curtry in 0..cases.gettries()-1
                        cases.setnext(cases.getcur(curtry)*cases.getgearp(curgeartype), curtry+1)
                    end
                   
                    cases.swap()
                end
             end
            cases.print_prob()
            
        end
    end
end
test = Game.new
test.run()
