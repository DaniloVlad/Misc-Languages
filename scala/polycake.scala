// Copyright (C) 2011-2012 the original author or authors.
// See the LICENCE.txt file distributed with this work for additional
// information regarding copyright ownership.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//import necessary function
import scala.math.{pow, sqrt}
import scala.io.StdIn.{readLine, readInt}

class Perimeter(var verts: Int, var horiz: Int) {
  //declare private class variables
  private var upperPerim: Double = 0
  private var lowerPerim: Double = 0
  //declare public array
  var AllPoints: Array[Point] = new Array[Point](verts)
  //lots of maths
  def processPerim: Unit = {
    //declare required variables
    var index: Int = 0
    var next: Int = 0
    var temp: Array[Point] = new Array[Point](2)
    var count: Int = 0
    for(index <- 0 until AllPoints.length) {
      //get next index circularly
      next = ((index + 1)%verts)
      //probably not necessary
      val p1: Point = AllPoints(index)
      val p2: Point = AllPoints(next)
      //initial checks and sum
      if(p1.y < horiz && p2.y < horiz) {
        lowerPerim += length(p1, p2)
      }
      else if(p1.y > horiz && p2.y > horiz) {
        upperPerim += length(p1, p2)
      }
      else {
        //the line y=horiz intersects line segment
        val newPoint: Point = intersects(p1, p2, horiz)
        //add new point to temp array and increment
        temp(count) = newPoint
        count += 1
        if(p1.y < horiz) {
          upperPerim += length(p2, newPoint)
          lowerPerim += length(p1, newPoint)
        }
        else {
          upperPerim += length(p1, newPoint)
          lowerPerim += length(p2, newPoint)
        }
      }
    }
    if(count == 2) {
      //account for point into perimeter
      val intersection:Double = length(temp(0), temp(1))
      lowerPerim += intersection
      upperPerim += intersection
    }
  }

  //create point at intersection
  def intersects(p1: Point, p2: Point, y: Int):  Point = {
    val t: Double = (y-p1.y)/(p2.y-p1.y)
    val x: Double = p1.x + t*(p2.x-p1.x)
    var newPoint: Point = new Point(x, y)
    //return point, gotta love scala
    newPoint
  }

  //get length of line segment
  def length(p1: Point, p2: Point): Double = { sqrt(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2)) }

  override def toString: String = {
    //reorganize output
    if(upperPerim > lowerPerim) {
      f"$lowerPerim%.3f $upperPerim%.3f"
    }
    else {
      f"$upperPerim%.3f $lowerPerim%.3f"
    }
  }
}

class Point(var xc: Double, var yc: Double) {
  //Class for creating point objects
  private var _x = xc
  private var _y = yc
  //accessors to coordinates
  def x: Double = _x
  def y: Double = _y
  //override with custom tostring
  override def toString: String = {
    s"Point (x,y): (" + _x + "," +_y + ")"
  }
}

object Polycake {
  //main object for execution
  def main(args: Array[String]) {
    val TestCases: Int = readInt();
    var x = 0
    for(x <- 0 until TestCases) {
      val Initial = readLine.split(" ")
      //convert to int
      val verts = Initial(0).toInt
      val yline = Initial(1).toInt
      //create Perimete object
      val CreatePerim = new Perimeter(verts, yline)
      //get all the Points
      for(y <- 0 until verts) {
        val PointNew = readLine.split(" ")
        val xc = PointNew(0).toInt
        val yc = PointNew(1).toInt
        //Create Point object
        val p = new Point(xc, yc)
        //push point to array
        CreatePerim.AllPoints(y) = p
      }
      //process perimeter
      CreatePerim.processPerim
      //print object
      println(CreatePerim)
    }

  }
}
