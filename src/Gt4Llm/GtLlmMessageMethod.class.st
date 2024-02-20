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
GtLlmMessageMethod >> addRefactoring [
	^ RBAddMethodRefactoring
		addMethod: methodBody
		toClass: methodClass
		inProtocols: {'generated - gpt'}
]

{ #category : #accessing }
GtLlmMessageMethod >> addToSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doAddRefactoring for: self
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
GtLlmMessageMethod >> doAddRefactoring [
	^ self
		doRefactoring: [ | refactoring |
			refactoring := self addRefactoring.
			refactoring execute ]
]

{ #category : #accessing }
GtLlmMessageMethod >> doRefactoring: aBlock [
	aBlock
		on: Error
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: anError messageText ].
	^ GtLlmCheckerSuccess new
		checker: self;
		content: (self methodClass
				compiledMethodAt: self methodSelector
				ifAbsent: [ 'Removed method from system: ' , self methodClass asString , '>>'
						, self methodSelector ])
]

{ #category : #accessing }
GtLlmMessageMethod >> doRemoveRefactoring [
	^ self
		doRefactoring: [ | refactoring |
			refactoring := self removeRefactoring.
			refactoring execute ]
]

{ #category : #accessing }
GtLlmMessageMethod >> doReplaceRefactoring [
	^ self
		doRefactoring: [ | refactoring |
			refactoring := self removeRefactoring.
			refactoring execute.
			refactoring := self addRefactoring.
			refactoring execute ]
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

{ #category : #accessing }
GtLlmMessageMethod >> removeFromSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doRemoveRefactoring for: self
]

{ #category : #accessing }
GtLlmMessageMethod >> removeRefactoring [
	^ RBRemoveMethodRefactoring
		removeMethods: {self methodSelector}
		from: methodClass
]

{ #category : #accessing }
GtLlmMessageMethod >> replaceInSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doReplaceRefactoring for: self
]
