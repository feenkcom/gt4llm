Class {
	#name : #GtLlmSmalltalkMethodExecutorChecker,
	#superclass : #GtLlmExecutorChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorChecker class >> language [
	^ 'Smalltalk method'
]

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> addRefactoring [
	^ RBAddMethodRefactoring
		addMethod: self methodBody
		toClass: self methodClass
		inProtocols: {'generated - gpt'}
]

{ #category : #actions }
GtLlmSmalltalkMethodExecutorChecker >> addToSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doAddRefactoring for: self
]

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> doAddRefactoring [
	^ self
		doRefactoring: [ | refactoring |
			refactoring := self addRefactoring.
			refactoring execute ]
]

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> doRefactoring: aBlock [
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

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> doRemoveRefactoring [
	^ self
		doRefactoring: [ | refactoring |
			refactoring := self removeRefactoring.
			refactoring execute ]
]

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> doReplaceRefactoring [
	^ self
		doRefactoring: [ | refactoring |
			refactoring := self removeRefactoring.
			refactoring execute.
			refactoring := self addRefactoring.
			refactoring execute ]
]

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorChecker >> errorToCatch [
	^ Error
]

{ #category : #execution }
GtLlmSmalltalkMethodExecutorChecker >> execute: aString [
	^ self addToSystem
]

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorChecker >> handlError: anError [
	^ GtLlmCheckerError new
		checker: self;
		content: anError;
		contentString: (self createStackString: anError)
]

{ #category : #actions }
GtLlmSmalltalkMethodExecutorChecker >> removeFromSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doRemoveRefactoring for: self
]

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> removeRefactoring [
	^ RBRemoveMethodRefactoring
		removeMethods: {self methodSelector}
		from: self methodClass
]

{ #category : #actions }
GtLlmSmalltalkMethodExecutorChecker >> replaceInSystem [
	^ GtLlmCheckRunResult new
		checkers: (GtLlmCheckerGroup withAll: {self});
		addResult: self doReplaceRefactoring for: self
]
