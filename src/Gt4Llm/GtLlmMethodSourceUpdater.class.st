Class {
	#name : #GtLlmMethodSourceUpdater,
	#superclass : #Object,
	#instVars : [
		'methodSource'
	],
	#category : #'Gt4Llm-Support'
}

{ #category : #refactoring }
GtLlmMethodSourceUpdater >> addRefactoring [
	^ RBAddMethodRefactoring
		addMethod: methodSource methodSource
		toClass: methodSource methodClass
		inProtocols: {'generated - gpt'}
]

{ #category : #actions }
GtLlmMethodSourceUpdater >> addToSystem [
	<return: #GtLlmMethodSourceUpdaterResponse>
	| aTemplate |
	self addRefactoring execute.
	aTemplate := 'Added to the system: {methodClass} >> #{methodSelector}'.
	^ self newResponseWithMessageText: aTemplate
]

{ #category : #accessing }
GtLlmMethodSourceUpdater >> methodSource [
	<return: #GtLlmMethodSource>
	^ methodSource
]

{ #category : #accessing }
GtLlmMethodSourceUpdater >> methodSource: anObject [
	methodSource := anObject
]

{ #category : #private }
GtLlmMethodSourceUpdater >> newResponseWithMessageText: aMessageTemplate [
	| aMessage |
	aMessage := aMessageTemplate
			format: (Dictionary new
					at: #methodClass put: methodSource methodClassName;
					at: #methodSelector put: methodSource methodSelector;
					yourself).
	^ GtLlmMethodSourceUpdaterResponse new
		methodSource: methodSource;
		messageText: aMessage
]

{ #category : #actions }
GtLlmMethodSourceUpdater >> removeFromSystem [
	<return: #GtLlmMethodSourceUpdaterResponse>
	| aMessage |
	self removeRefactoring execute.
	aMessage := 'Removed from the system: {methodClass} >> #{methodSelector}'.
	^ self newResponseWithMessageText: aMessage
]

{ #category : #refactoring }
GtLlmMethodSourceUpdater >> removeRefactoring [
	^ GtLlmRemoveMethodRefactoring
		removeMethods: {methodSource methodSelector}
		from: methodSource methodClass
]

{ #category : #actions }
GtLlmMethodSourceUpdater >> replaceInSystem [
	<return: #GtLlmMethodSourceUpdaterResponse>
	| aMessage |
	self removeRefactoring execute.
	self addRefactoring execute.
	aMessage := 'Updated in the system: {methodClass} >> #{methodSelector}'.
	^ self newResponseWithMessageText: aMessage
]

{ #category : #actions }
GtLlmMethodSourceUpdater >> update [
	<return: #GtLlmMethodSourceUpdaterResponse>
	^ methodSource compiledMethod
		ifNil: [ self addToSystem ]
		ifNotNil: [ self replaceInSystem ]
]
