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
	^ self subclasses
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
	^ self execute: aString
]

{ #category : #accessing }
GtLlmExecutorChecker >> execute: aString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmExecutorChecker >> isExecutor [
	^ true
]
