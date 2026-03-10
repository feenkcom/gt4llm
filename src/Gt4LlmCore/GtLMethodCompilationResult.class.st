"
Result of a successful method compilation operation.
"
Class {
	#name : #GtLMethodCompilationResult,
	#superclass : #Object,
	#instVars : [
		'oldMethod',
		'newMethod',
		'status'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLMethodCompilationResult >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{'Method' -> (self newMethod ifNotNil: [ :m | m methodReference methodSignature ]).
			 'Status' -> self status.
			 'Old source' -> (self oldMethod ifNotNil: #sourceCode).
			 'New source' -> (self newMethod ifNotNil: #sourceCode)} ];
		column: 'Property' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #views }
GtLMethodCompilationResult >> gtDiffFor: aView [
	<gtView>
	(self oldMethod isNil or: [ self newMethod isNil ]) 
		ifTrue: [ ^ aView empty ].
		
	^ aView explicit
		title: 'Diff';
		priority: 5;
		stencil: [
			| oldSource newSource |
			oldSource := self oldMethod sourceCode ifNil: [ '' ].
			newSource := self newMethod sourceCode ifNil: [ '' ].
			GtDiffElementWithLabelStencil new
				fromLabelText: 'Old';
				toLabelText: 'New';
				change: (GtDiffBuilder
					computeDifferencesFrom: oldSource
					to: newSource
					using: GtSmaCCDiffSplitter forPharo);
				asElement ]
]

{ #category : #accessing }
GtLMethodCompilationResult >> newMethod [
	^ newMethod
]

{ #category : #accessing }
GtLMethodCompilationResult >> newMethod: aGtLMethodWithSource [
	newMethod := aGtLMethodWithSource
]

{ #category : #accessing }
GtLMethodCompilationResult >> oldMethod [
	^ oldMethod
]

{ #category : #accessing }
GtLMethodCompilationResult >> oldMethod: aGtLMethodWithSource [
	oldMethod := aGtLMethodWithSource
]

{ #category : #printing }
GtLMethodCompilationResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self newMethod ifNotNil: [ :m |
			aStream nextPutAll: m methodReference methodSignature ].
		aStream nextPutAll: ' — '.
		self status ifNotNil: [ :s | aStream nextPutAll: s ] ]
]

{ #category : #accessing }
GtLMethodCompilationResult >> status [
	^ status
]

{ #category : #accessing }
GtLMethodCompilationResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLMethodCompilationResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]
