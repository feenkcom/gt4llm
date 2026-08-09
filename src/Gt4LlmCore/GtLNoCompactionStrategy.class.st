"
GtLNoCompactionStrategy means that no automatic compaction is performed, however prompt compaction messages may still be sent and will be handled correctly.
"
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
