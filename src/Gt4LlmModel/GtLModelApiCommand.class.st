Class {
	#name : #GtLModelApiCommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelApiCommand >> model [
	^ model
]

{ #category : #accessing }
GtLModelApiCommand >> model: anObject [
	model := anObject
]
