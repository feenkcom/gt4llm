Class {
	#name : #GtLMethodIsNotExampleDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'method'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - accessing' }
GtLMethodIsNotExampleDomainObject >> errorMessage [
	^ self messageText
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #'llm views' }
GtLMethodIsNotExampleDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #'api - accessing' }
GtLMethodIsNotExampleDomainObject >> messageText [
	"Return an error message"

	^ 'Method is not an example: {1}' format: {self method name}
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> method [
	^ method
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> method: anObject [
	method := anObject
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> methodName [
	^ self method name
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> methodNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Method name';
			accessor: #methodName;
			beRequired
]

{ #category : #'api - serializing' }
GtLMethodIsNotExampleDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self.
]

{ #category : #testing }
GtLMethodIsNotExampleDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
