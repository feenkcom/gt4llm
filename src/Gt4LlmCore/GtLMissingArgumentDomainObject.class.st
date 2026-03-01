Class {
	#name : #GtLMissingArgumentDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'arguments',
		'missingArgument',
		'receiverName'
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

{ #category : #'api - testing' }
GtLMissingArgumentDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLMissingArgumentDomainObject >> messageText [
	"Return an error message"

	^ '{1} is missing argument called {2}'
		format: {self receiverName.
				self missingArgument}
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> missingArgument [
	<return: #String>
	^ missingArgument
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> missingArgument: aString [
	"Set a missing argument name."

	missingArgument := aString
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> receiverName [
	<return: #String>
	^ receiverName
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> receiverName: aString [
	"Set a receiver name that was missing the argument."

	receiverName := aString
]

{ #category : #'api - serializing' }
GtLMissingArgumentDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #missingArgument put: self missingArgument;
		at: #receiver put: self receiverName;
		yourself
]
