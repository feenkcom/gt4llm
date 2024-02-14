Class {
	#name : #GtLlmParserChecker,
	#superclass : #GtLlmChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmParserChecker class >> checkName [
	^ self language , ' Parser Checker'
]

{ #category : #accessing }
GtLlmParserChecker class >> forLanguage: aString [
	^ self allSubclasses
		detect: [ :aClass | aClass hasAbstractMethods not and: [ aClass isForLanguage: aString ] ]
		ifOne: #new
		ifNone: [ self error: 'No parser for language ' , aString , ' found' ]
]

{ #category : #accessing }
GtLlmParserChecker class >> isForLanguage: aString [
	^ self language asLowercase = aString asLowercase
]

{ #category : #accessing }
GtLlmParserChecker class >> language [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmParserChecker >> check: aString [
	^ self parse: aString
]

{ #category : #accessing }
GtLlmParserChecker >> isParser [
	^ true
]

{ #category : #accessing }
GtLlmParserChecker >> parse: aString [
	^ self subclassResponsibility
]
