Class {
	#name : #GtLlmInstructionSection,
	#superclass : #GtLlmInstructionPiece,
	#instVars : [
		'title',
		'body',
		'headerLevel',
		'autoHeaderLevel'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmInstructionSection class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLlmInstructionSection >> body [
	^ body
]

{ #category : #accessing }
GtLlmInstructionSection >> body: anObject [
	body := anObject asInstructionPiece parent: self
]

{ #category : #accessing }
GtLlmInstructionSection >> children [
	^ {body}
]

{ #category : #accessing }
GtLlmInstructionSection >> computeHeaderLevelsAutomatically [
	autoHeaderLevel := true
]

{ #category : #accessing }
GtLlmInstructionSection >> doNotComputeHeaderLevelsAutomatically [
	autoHeaderLevel := false
]

{ #category : #accessing }
GtLlmInstructionSection >> gtDisplayOn: aStream [
	aStream
		nextPutAll: self title
]

{ #category : #accessing }
GtLlmInstructionSection >> headerLevel [
	autoHeaderLevel
		ifTrue: [ ^ (self allParents
				select: [ :aParent | aParent isKindOf: GtLlmInstructionSection ]) size + 1 ].
	^ headerLevel
]

{ #category : #accessing }
GtLlmInstructionSection >> headerLevel: anObject [
	self
		assert: autoHeaderLevel not
		description: 'Cannot set header level because it is automatically generated. Use #doNotComputeHeaderLevelsAutomatically to disable.'.
	self assert: anObject > 0.

	headerLevel := anObject
]

{ #category : #accessing }
GtLlmInstructionSection >> initialize [
	super initialize.
	
	headerLevel := 1.
	autoHeaderLevel := true.
]

{ #category : #accessing }
GtLlmInstructionSection >> instructionString [
	^ ('#' repeat: self headerLevel) , ' ' , self title
		, String cr , self body instructionString
]

{ #category : #accessing }
GtLlmInstructionSection >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self title;
		nextPut: $)
]

{ #category : #accessing }
GtLlmInstructionSection >> title [
	^ title
]

{ #category : #accessing }
GtLlmInstructionSection >> title: anObject [
	title := anObject
]
