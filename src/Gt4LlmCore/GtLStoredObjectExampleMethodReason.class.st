"
Reason represented by an example method reference.
"
Class {
	#name : #GtLStoredObjectExampleMethodReason,
	#superclass : #GtLStoredObjectToolBasedReason,
	#instVars : [
		'tool'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLStoredObjectExampleMethodReason class >> methodReference: aString [
	^ self new methodReference: aString; yourself
]

{ #category : #printing }
GtLStoredObjectExampleMethodReason >> asReasonString [
	^ self methodReference
]

{ #category : #accessing }
GtLStoredObjectExampleMethodReason >> methodReference [
	| targetClass methodName classSideValue compiledMethod |
	self toolCall ifNil: [ ^ '' ].
	(targetClass := (self toolCall arguments at: 'className' ifAbsent: [ ^ '' ]) asClassIfAbsent: [ ^ '' ]) ifNil: [ ^ '' ].
	methodName := self toolCall arguments at: 'methodName' ifAbsent: [ ^ '' ].
	classSideValue := self toolCall arguments at: 'classSide' ifAbsent: [ false ].
	(#(true 'true' 't' 'yes' 'y') includes: classSideValue)
		ifTrue: [ targetClass := targetClass classSide ].
	compiledMethod := targetClass compiledMethodAt: methodName asSymbol ifAbsent: [ ^ '' ].
	^ compiledMethod gtDisplayString
]

{ #category : #accessing }
GtLStoredObjectExampleMethodReason >> methodReference: aString [
	methodReference := aString
]
