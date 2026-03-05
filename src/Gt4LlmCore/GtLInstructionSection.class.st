Class {
	#name : #GtLInstructionSection,
	#superclass : #GtLInstructionPiece,
	#instVars : [
		'title',
		'body',
		'headerLevel',
		'autoHeaderLevel'
	],
	#category : #'Gt4LlmCore-Instructions'
}

{ #category : #accessing }
GtLInstructionSection >> body [
	^ body
]

{ #category : #accessing }
GtLInstructionSection >> body: anObject [
	body := anObject asGtLInstructionPiece parent: self
]

{ #category : #accessing }
GtLInstructionSection >> children [
	^ {body}
]

{ #category : #accessing }
GtLInstructionSection >> computeHeaderLevelsAutomatically [
	autoHeaderLevel := true
]

{ #category : #accessing }
GtLInstructionSection >> doNotComputeHeaderLevelsAutomatically [
	autoHeaderLevel := false
]

{ #category : #accessing }
GtLInstructionSection >> gtDisplayOn: aStream [
	aStream
		nextPutAll: self title
]

{ #category : #accessing }
GtLInstructionSection >> headerLevel [
	autoHeaderLevel
		ifTrue: [ ^ (self allParents
				select: [ :aParent | aParent isKindOf: GtLInstructionSection ]) size + 1 ].
	^ headerLevel
]

{ #category : #accessing }
GtLInstructionSection >> headerLevel: anObject [
	self
		assert: autoHeaderLevel not
		description: 'Cannot set header level because it is automatically generated. Use #doNotComputeHeaderLevelsAutomatically to disable.'.
	self assert: anObject > 0.

	headerLevel := anObject
]

{ #category : #accessing }
GtLInstructionSection >> initialize [
	super initialize.
	
	headerLevel := 1.
	autoHeaderLevel := true.
]

{ #category : #accessing }
GtLInstructionSection >> instructionString [
	^ ('#' repeat: self headerLevel) , ' ' , self title
		, String lf , self body instructionString
]

{ #category : #accessing }
GtLInstructionSection >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self title;
		nextPut: $)
]

{ #category : #accessing }
GtLInstructionSection >> title [
	^ title
]

{ #category : #accessing }
GtLInstructionSection >> title: anObject [
	title := anObject
]
