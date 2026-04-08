Class {
	#name : #GtLMissingArgumentDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'arguments',
		'missingArgument',
		'errorMessage'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingArgumentDomainObject >> arguments [
	<return: #Dictionary>
	^ arguments
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> arguments: aDictionary [
	"Set provided arguments with argument names and values."

	arguments := aDictionary
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> defaultErrorMessage [
	^missingArgument 
		ifNil: [''] 
		ifNotNil: [ 'Missing argument called {1}' format: {missingArgument} ]
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> errorMessage [
	^ errorMessage ifNil: [ self defaultErrorMessage ]
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> errorMessage: anObject [
	^ errorMessage := anObject
]

{ #category : #descriptions }
GtLMissingArgumentDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #'llm views' }
GtLMissingArgumentDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> messageText [
	"Return an error message"

	^ self errorMessage
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> missingArgument [
	<return: #String>
	^ missingArgument
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> missingArgument: aString [
	missingArgument := aString.
]

{ #category : #descriptions }
GtLMissingArgumentDomainObject >> missingArgumentDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Missing argument';
			accessor: #missingArgument;
			beRequired
]
