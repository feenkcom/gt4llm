Class {
	#name : #GtLlmMessageMethod,
	#superclass : #Object,
	#instVars : [
		'methodClass',
		'methodBody'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmMessageMethod >> addToSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doRefactoring for: self
]

{ #category : #accessing }
GtLlmMessageMethod >> checkName [
	^ 'Smalltalk Message Addition Checker'
]

{ #category : #accessing }
GtLlmMessageMethod >> coder [
	^ (GtPharoMethodCoder forNewMethod: self methodClass)
		sourceCode: (GtCoderExplicitStringSource new source: self methodBody)
]

{ #category : #accessing }
GtLlmMessageMethod >> doRefactoring [
	[ | refactoring |
	refactoring := RBAddMethodRefactoring
			addMethod: methodBody
			toClass: methodClass
			inProtocols: {'generated - gpt'}.
	refactoring execute ]
		on: Error
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: anError messageText ].
	^ GtLlmCheckerSuccess new
		checker: self;
		content: self methodClass >> self methodSelector
]

{ #category : #accessing }
GtLlmMessageMethod >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self coder ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmMessageMethod >> isExecutor [
	^ true
]

{ #category : #accessing }
GtLlmMessageMethod >> isParser [
	^ true
]

{ #category : #accessing }
GtLlmMessageMethod >> methodBody [
	^ methodBody
]

{ #category : #accessing }
GtLlmMessageMethod >> methodBody: anObject [
	methodBody := anObject
]

{ #category : #accessing }
GtLlmMessageMethod >> methodClass [
	^ methodClass
]

{ #category : #accessing }
GtLlmMessageMethod >> methodClass: anObject [
	methodClass := anObject
]

{ #category : #accessing }
GtLlmMessageMethod >> methodExists [
	^ methodClass includesSelector: self methodSelector
]

{ #category : #accessing }
GtLlmMessageMethod >> methodSelector [
	^ (''
		join: ((' ' split: methodBody lines first)
				withIndexSelect: [ :anElement :anIndex | anIndex \\ 2 = 1 ])) asSymbol
]
