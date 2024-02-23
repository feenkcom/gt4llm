Class {
	#name : #GtLlmMethodSource,
	#superclass : #Object,
	#instVars : [
		'methodClass',
		'methodSource',
		'methodClassName'
	],
	#category : #'Gt4Llm-Support'
}

{ #category : #'instace creation' }
GtLlmMethodSource class >> forSource: aString [
	^ self new forSource: aString
]

{ #category : #accessing }
GtLlmMethodSource >> coder [
	^ GtPharoMethodCoder forClass: self methodClass source: self methodSource
]

{ #category : #accessing }
GtLlmMethodSource >> compiledMethod [
	| aClass aSelector |
	aClass := self methodClass ifNil: [ ^ nil ].
	aSelector := self methodSelector ifNil: [ ^ nil ].
	^ aClass 
		compiledMethodAt: aSelector 
		ifAbsent: [ nil ]
]

{ #category : #'initialization ' }
GtLlmMethodSource >> forSource: aString [
	| aClassName allLines aMethodSource aClass |
	allLines := aString trimBoth lines.
	aClassName := allLines first trimBoth.
	aMethodSource := Character lf join: allLines allButFirst.
	aClass := self class environment at: aClassName asSymbol ifAbsent: [ nil ].
	self methodClassName: aClassName.
	self methodSource: aMethodSource.
	self methodClass: aClass.
]

{ #category : #'gt - extensions' }
GtLlmMethodSource >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self coder ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmMethodSource >> hasPragmaNamed: aPragma [
	^ self methodAst hasPragmaNamed: aPragma
]

{ #category : #accessing }
GtLlmMethodSource >> methodAst [
	| anAst |
	anAst := RBParser parseFaultyMethod: methodSource.
	anAst isFaulty ifTrue: [ ^ nil ].
	^ anAst
]

{ #category : #accessing }
GtLlmMethodSource >> methodClass [
	^ methodClass
]

{ #category : #accessing }
GtLlmMethodSource >> methodClass: anObject [
	methodClass := anObject
]

{ #category : #accessing }
GtLlmMethodSource >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLlmMethodSource >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #testing }
GtLlmMethodSource >> methodExists [
	^ self compiledMethod isNotNil
]

{ #category : #accessing }
GtLlmMethodSource >> methodSelector [
	^ self methodAst ifNotNil: #selector
]

{ #category : #accessing }
GtLlmMethodSource >> methodSource [
	^ methodSource
]

{ #category : #accessing }
GtLlmMethodSource >> methodSource: anObject [
	methodSource := anObject
]
