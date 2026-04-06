Class {
	#name : #GtLMissingRequiredPropertiesDomainObject,
	#superclass : #GtLJSONSchemaValidationErrorDomainObject,
	#instVars : [
		'missingPropertyNames'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingRequiredPropertiesDomainObject >> missingPropertyNames [
	^ missingPropertyNames
]

{ #category : #accessing }
GtLMissingRequiredPropertiesDomainObject >> missingPropertyNames: aCollection [
	missingPropertyNames := aCollection
]

{ #category : #magritte }
GtLMissingRequiredPropertiesDomainObject >> missingPropertyNamesDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Missing property names';
		accessor: #missingPropertyNames;
		beRequired
]
