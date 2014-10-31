# -*- coding: utf-8 -*-

class MineSwiper

  SIZE = 10
  MINE = 10
  

  def initialize

    @board = Array.new(SIZE+1){Array.new(SIZE+1,0)}
    @board_flag = Array.new(SIZE+1){Array.new(SIZE+1,0)}

  end

  def showBoard
    print "  "
    for i in 1..SIZE - 1
      print " #{i}"
    end
    print ("\n")

    for i in 1..SIZE - 1
      print "#{i} "
      for j in 1..SIZE - 1

        if @board_flag[j][i] == 1
          case @board[j][i]
          when 0
            print(" □")
          when -1
           print(" *")
          when 1..8
            print(" #{@board[j][i]}")
          end
        else
          print(" ■")
        end

      end
      print ("\n")
    end

  end

  def checkAround

    for i in 1..SIZE - 1
      for j in 1..SIZE - 1

        count = 0
        
        if @board[j][i] == -1
          next
        else
          for k in -1..1
            for l in -1..1
              if @board[l+j][k+i] == -1
                count += 1
              end

            end
          end
          
          @board[j][i] = count

        end
        
      end
    end

  end

  def putMine(x,y)

    @board.each{|b_num|
      b_num.each{|b_n|
        if b_n == -1
          return
        end
      }
    }

    n = 0
    while(n < MINE)
      i = rand(SIZE-1) + 1
      j = rand(SIZE-1) + 1
      flag = 0
      for k in -1..1
        for l in -1..1
          if (i == x+k) && (j == y+l)
            flag = 1
          end
        end
      end
      if flag == 1
        redo
      end

      if @board[j][i] == -1
        redo
      end

      @board[j][i] = -1
      n += 1

    end

    checkAround

  end

  def openBoard(x,y)
    
    if x < 1 || x > SIZE - 1 || y < 1 || y > SIZE - 1
      return
    end

    putMine(x,y)
    if @board[x][y] == 0

      for i in -1..1
        for j in -1..1

          if @board_flag[j+x][i+y] == 1
            next
          end

          case @board[j+x][i+y]
          when 0
            @board_flag[j+x][i+y] = 1
            openBoard(j+x,i+y)
          when 1..8
            @board_flag[j+x][i+y] = 1
          end
          
        end
      end

    else
      @board_flag[x][y] = 1
      return
    end

    return
    
  end

  def chooseNumber

    while 1
      p "Choose number (xy)[1 to 9]"
      # number check
      num = gets.chop
      if num[1] == nil
        p "Entry (xy)"
        redo
      end
      nx = num[0].to_i
      ny = num[1].to_i
      
      if !(nx > 0 && ny > 0 && nx < SIZE && ny < SIZE)
        redo
      end
      
      self.openBoard(nx,ny)
      if self.gameOver(nx,ny)
        return true
      end

      break
      
    end
    
    return false

  end

  def gameOver(x,y)

    count = 0

    for i in 1..SIZE - 1
      for j in 1..SIZE - 1
        if @board_flag[j][i] == 0
          count += 1
        end
      end
    end

    if count == MINE
      self.showBoard
      p "Clear!"
      return true
    end
    if @board[x][y] == -1
      @board_flag[x][y] = 1
      self.showBoard
      p "FAILED.."
      return true
    end

    return false

  end

end


go = MineSwiper.new

while 1
  go.showBoard
  if go.chooseNumber
    break
  end
end
