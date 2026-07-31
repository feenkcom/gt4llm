Class {
	#name : #GtLNoCompactionStrategy,
	#superclass : #GtLCompactionStrategy,
	#category : #'Gt4LlmCore-Compaction'
}

{ #category : #'api - compaction' }
GtLNoCompactionStrategy >> executeCompaction [
]

{ #category : #testing }
GtLNoCompactionStrategy >> isNoCompaction [

	^ true
]

{ #category : #'api - compaction' }
GtLNoCompactionStrategy >> requestCompactionIfNeeded [
]
