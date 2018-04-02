#!/usr/bin/env xcrun swift

import Foundation

struct Block {
}

struct Transaction {
}

class Blockchain {
	var chain: [Block] = []
	var currentTransactions: [Transaction] = []

	func newBlock() {
	}

	func newTransaction() {
	}

	func hash(block: Block) {
	}

	func lastBlock() {
	}
}

print("hello, world!")

/* End Of File */
