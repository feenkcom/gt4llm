"
I am an abstract change of a single variable of a class, extracted from a class-level {{gtClass:GtLSummarizerCodeChange}} that I keep as classChange.
"
Class {
	#name : #GtLVariableChangeResult,
	#superclass : #GtLCodeChangeResult,
	#instVars : [
		'variableName',
		'variableType',
		'classChange'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLVariableChangeResult class >> named: aVariableName type: aVariableType from: aClassChange [
	^ self new
		variableName: aVariableName;
		variableType: aVariableType;
		classChange: aClassChange;
		yourself
]

{ #category : #'accessing - delegated' }
GtLVariableChangeResult >> asDiffElement [
	^ self classChange asDiffElement
]

{ #category : #converting }
GtLVariableChangeResult >> asSummarizerCodeChange [
	^ GtLSummarizerCodeChange new
		label: self changeKindLabel , ' ' , self variableType label asLowercase;
		toolCall: self classChange toolCall;
		changeResult: self;
		yourself
]

{ #category : #accessing }
GtLVariableChangeResult >> changeKindLabel [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLVariableChangeResult >> classChange [
	^ classChange
]

{ #category : #accessing }
GtLVariableChangeResult >> classChange: aSummarizerCodeChange [
	classChange := aSummarizerCodeChange
]

{ #category : #'gt - extensions' }
GtLVariableChangeResult >> gtViewChangeDescriptionElement [
	^ GtLLabeledChangeDescriptionElement new
		updateForString: (self variableType descriptionFor: self variableName)
]

{ #category : #printing }
GtLVariableChangeResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream nextPutAll: (self variableType descriptionFor: self variableName) ]
]

{ #category : #accessing }
GtLVariableChangeResult >> targetClassName [
	^ self classChange changeResult targetClassName
]

{ #category : #accessing }
GtLVariableChangeResult >> variableName [
	^ variableName
]

{ #category : #accessing }
GtLVariableChangeResult >> variableName: aString [
	variableName := aString
]

{ #category : #accessing }
GtLVariableChangeResult >> variableType [
	^ variableType
]

{ #category : #accessing }
GtLVariableChangeResult >> variableType: aVariableType [
	variableType := aVariableType
]
