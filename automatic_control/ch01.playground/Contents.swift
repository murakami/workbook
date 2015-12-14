//: Playground - noun: a place where people can play

import Cocoa
import Foundation

class Buffer {
    var queued: Int
    var wip: Int
    var max_wip: Int
    var max_flow: Int
    
    init(max_wip: Int, max_flow: Int) {
        self.queued = 0 /* work-in-progress ("ready pool") */
        self.wip = 0
        self.max_wip = max_wip
        self.max_flow  = max_flow   /* avg outflow is max_flow/2 */
    }
    
    func work(u: Double) -> Int {
        /* Add to ready pool */
        var uu: Int = max(0, Int(round(u)))
        uu = min(uu, self.max_wip )
        self.wip += uu
        
        /* Transfer from ready pool to queue */
        var r: Int = Int(arc4random_uniform(UInt32(self.wip + 1)))
        self.wip -= r
        self.queued += r
        
        /* Release from queue to downstream process */
        r = Int(arc4random_uniform(UInt32(self.max_flow + 1)))
        r = min(r, self.queued)
        self.queued -= r
        
        return self.queued
    }
}

class Controller {
    var kp: Int
    var ki: Int
    var i: Int
    
    
    init(kp: Int, ki: Int) {
        self.kp = kp
        self.ki = ki
        self.i = 0 /* Cumulative error ("integral") */
    }
    
    func work(e: Double) -> Int {
        self.i += e
        return self.kp * e + self.ki * self.i
    }
}

func open_loop(p: Buffer) {
    open_loop(p, tm: 5000)
}

func open_loop(p: Buffer, tm: Int) {
    func target(t: Int) -> Double {
        return 5.0 /* 5.1 */
    }
    
    for t in 0..<tm {
        let u: Double = target(t)
        let y: Int = p.work(u)
        
        print t, u, 0, u, y
    }
}




# ============================================================

def open_loop( p, tm=5000 ):
    def target( t ):
        return 5.0  # 5.1

    for t in range( tm ):
        u = target(t)
        y = p.work( u )

        print t, u, 0, u, y

def closed_loop( c, p, tm=5000 ):
    def setpoint( t ):
        if t < 100: return 0
        if t < 300: return 50
        return 10

    y = 0
        for t in range( tm ):
        r = setpoint(t)
        e = r - y
        u = c.work(e)
        y = p.work(u)

        print t, r, e, u, y

# ============================================================

c = Controller( 1.25, 0.01 )
p = Buffer( 50, 10 )

# open_loop( p, 1000 )
closed_loop( c, p, 1000 )

