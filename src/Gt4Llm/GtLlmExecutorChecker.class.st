Class {
	#name : #GtLlmExecutorChecker,
	#superclass : #GtLlmChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmExecutorChecker class >> checkName [
	^ self language , ' Execution Checker'
]

{ #category : #accessing }
GtLlmExecutorChecker class >> forLanguage: aString [
	^ self allSubclasses
		detect: [ :aClass | aClass isForLanguage: aString ]
		ifOne: #new
		ifNone: [ self error: 'No executor for language ' , aString , ' found' ]
]

{ #category : #accessing }
GtLlmExecutorChecker class >> isForLanguage: aString [
	^ self language asLowercase = aString asLowercase
]

{ #category : #accessing }
GtLlmExecutorChecker class >> language [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmExecutorChecker >> check: aString [
	[ ^ GtLlmCheckerSuccess new
		checker: self;
		content: (self execute: aString) ]
		on: self errorToCatch
		do: [ :anError | ^ self handleError: anError ]
]

{ #category : #accessing }
GtLlmExecutorChecker >> errorToCatch [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmExecutorChecker >> execute: aString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmExecutorChecker >> handleError: anError [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmExecutorChecker >> isExecutor [
	^ true
]
