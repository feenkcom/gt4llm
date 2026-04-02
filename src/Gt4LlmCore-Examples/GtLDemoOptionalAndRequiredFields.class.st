Class {
	#name : #GtLDemoOptionalAndRequiredFields,
	#superclass : #Object,
	#instVars : [
		'optionalField',
		'requiedFiel',
		'defaultField'
	],
	#category : 'Gt4LlmCore-Examples-Magritte'
}

{ #category : #'magritte-description' }
GtLDemoOptionalAndRequiredFields >> defaultFieldDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #defaultField
]

{ #category : #'magritte-description' }
GtLDemoOptionalAndRequiredFields >> optionalFieldDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #optionalField;
		  beOptional
]

{ #category : #'magritte-description' }
GtLDemoOptionalAndRequiredFields >> requiredFielDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #requiredFiel;
		  beRequired
]
