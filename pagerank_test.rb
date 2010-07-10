#!/usr/bin/env ruby -w
require 'pagerank'
require 'test/unit'

class PageRankTests < Test::Unit::TestCase

  def ha
    0.5
  end # ha

  def th
    @th ||= 1.0/3
  end # th
    
  def test_001_example1
    a = Matrix[
      [  0,  0,  0,  0,  0,  0, th,  0],
      [ ha,  0, ha, th,  0,  0,  0,  0],
      [ ha,  0,  0,  0,  0,  0,  0,  0],
      [  0,  1,  0,  0,  0,  0,  0,  0],
      [  0,  0, ha, th,  0,  0, th,  0],
      [  0,  0,  0, th, th,  0,  0, ha],
      [  0,  0,  0,  0, th,  0,  0, ha],
      [  0,  0,  0,  0, th,  1, th,  0]]
      
    res = Vector[0.0600, 0.0675, 0.0300, 0.0675, 0.0975, 0.2025, 0.1800, 0.2950]
    
    assert res.good_enough?(a.page_rank(1))
  end
  
  def test_002_circle
    circle = Matrix[
      [0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0],
      [0, 1, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 1, 0]]
    
    res = Vector[0.2, 0.2, 0.2, 0.2, 0.2]
    assert res.good_enough?(circle.page_rank)
  end
  
  def test_003_dangling_node
    #Matrix with dangling node 1 -> 2
    dangling = Matrix[ [0, 0], [1, 0] ]
    res = Vector[1.0/3, 2.0/3]
    
    assert res.good_enough?(dangling.page_rank(1))
  end
  
  def test_004_reducible_matrix
    #Dangling "square" - A set of nodes without outgoing links
    reducible = Matrix[
      [  0, 0,  0,  0,  0,  0,  0,  0],
      [ ha, 0, ha, th,  0,  0,  0,  0],
      [ ha, 0,  0,  0,  0,  0,  0,  0],
      [  0, 1,  0,  0,  0,  0,  0,  0],
      [  0, 0, ha, th,  0,  0, ha,  0],
      [  0, 0,  0, th, th,  0,  0, ha],
      [  0, 0,  0,  0, th,  0,  0, ha],
      [  0, 0,  0,  0, th,  1, ha,  0]]
    
    res1 = Vector[0, 0, 0, 0, 0.12, 0.24, 0.24, 0.4]
    assert res1.good_enough?(reducible.page_rank(1))
  end
end
