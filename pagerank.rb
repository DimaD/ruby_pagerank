#!/usr/bin/env ruby -w
#
# $Revision: 0.1 $
#
# This is a simple implementtion of the old google pagerank algorithm. 
# The code is based on the article "How Google Finds Your Needle in the Web's Haystack" by David Austin.
# You may find it here http://www.ams.org/featurecolumn/archive/pagerank.html
#
# Author:: Dmitriy Dzema (mailto:dmitriy-at-dzema.name)

require 'matrix'

class Vector
  def good_enough?(j)
    (self - j).r < 0.00001
  end
  
end

class Matrix
  def self.square(size, el=1)
    a = Array.new(size, Array.new(size, el))
    self.columns(a)
  end
  
  #To calculate PageRanks of the pages we need to find eigenvector with eigenvalue 1 of the matrix
  # G = alpha*S + (1-alpha)1/n * II,
  #where S is a hyperlnik matrix and II is a square matrix filled with 1,
  #alpha is a probability with which a surfer is guided by a hyperlink matrix S.
  #The convergence of a method is dependent on alpha: alpha -> 1 => method will be very slow
  def page_rank(alpha=0.85)
    n = column_size
    matrix = alpha * remove_danglings + Matrix.square(n, (1.0 - alpha)/n)
    matrix.find_eigenvector
  end
  
  #Produce eigenvector with the largest eigenvalue, using very simple power method.
  #See http://en.wikipedia.org/wiki/Power_method for details
  def find_eigenvector
    apr = gen_approximation
    begin
      old_apr = apr
      apr = self * apr
    end while (!old_apr.good_enough?(apr))
    apr
  end
  
  def gen_approximation
    ret = Array.new(column_size, 0)
    ret[0] = 1
    Vector.elements(ret)
  end
  
  #Remove dangling nodes from the the matrix. Node is called dangling, if it don't have outcome links.
  #Such node takes all the importance from the nodes, which linked to it, so we assume that surfer goes
  #from the dangling node to another node randomly with probability 1/n, where n is a number of pages in the net.
  def remove_danglings
    r = column_size
    v = 1.0/r
    flag = false
    matrix = false

    for col in 0..(r - 1)
      #Dangling node found. Replace it's column with probability 1/n
      if column(col).r == 0.0
        flag = true
        matrix ||= self.to_a
        for row in 0..(r - 1)
          matrix[row][col] = v
        end
      end
    end

    flag ? Matrix.rows(matrix) : self
  end
end
