"
Result of a successful method removal operation.
"
Class {
	#name : #GtLMethodRemovalResult,
	#superclass : #GtLMethodChangeResult,
	#instVars : [
		'removedMethod',
		'status'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLMethodRemovalResult >> currentMethodSourceCode [
	^self existsInImage
		ifTrue: [ 
			self removedMethod  compiledMethod sourceCode ] 
		ifFalse: ['']
]

{ #category : #testing }
GtLMethodRemovalResult >> existsInImage [
	^ self removedMethod notNil and: [
			self removedMethod existsInImage ]
]

{ #category : #views }
GtLMethodRemovalResult >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{'Method' -> (self removedMethod ifNotNil: [ :m | m methodReference methodSignature ]).
			 'Status' -> self status.
			 'Source code' -> (self removedMethod ifNotNil: [:each | each sourceCode])} ];
		column: 'Property' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #views }
GtLMethodRemovalResult >> gtViewChangeIcon [
	^ self class removalIcon
]

{ #category : #testing }
GtLMethodRemovalResult >> isMethodRemovalResult [
	^ true
]

{ #category : #'llm views' }
GtLMethodRemovalResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLMethodRemovalResult >> newStateMethodSourceCode [
	^ ''
]

{ #category : #accessing }
GtLMethodRemovalResult >> oldStateMethodSourceCode [
	^ self removedMethod
			ifNil: [ '' ]
			ifNotNil: [ :aMethod | aMethod sourceCode ]
]

{ #category : #printing }
GtLMethodRemovalResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self removedMethod ifNotNil: [ :m |
			aStream nextPutAll: m methodReference methodSignature ].
		aStream nextPutAll: ' — '.
		self status ifNotNil: [ :s | aStream nextPutAll: s ] ]
]

{ #category : #accessing }
GtLMethodRemovalResult >> removedMethod [
	^ removedMethod
]

{ #category : #accessing }
GtLMethodRemovalResult >> removedMethod: aGtLMethodWithSource [
	removedMethod := aGtLMethodWithSource
]

{ #category : #accessing }
GtLMethodRemovalResult >> status [
	^ status
]

{ #category : #accessing }
GtLMethodRemovalResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLMethodRemovalResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLMethodRemovalResult >> targetMethod [

	^ self removedMethod 
]

{ #category : #accessing }
GtLMethodRemovalResult >> targetMethodSourceCode [

	^ self targetMethod sourceCode 
]
