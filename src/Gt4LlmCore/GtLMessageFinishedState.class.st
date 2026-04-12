Class {
	#name : #GtLMessageFinishedState,
	#superclass : #GtLMessageState,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #testing }
GtLMessageFinishedState >> isFinished [
	^ true
]

{ #category : #'api - accessing' }
GtLMessageFinishedState >> messageExecutionStateLabel [
	^ 'finished'
]
