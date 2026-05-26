Class {
	#name : #GtLObjectValueResult,
	#superclass : #Object,
	#instVars : [
		'object',
		'objectValue',
		'playgroundPageReference'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLObjectValueResult class >> forObject: anObject [
	| result |
	result := self new
			object: anObject;
			objectValue: (GtLSerializedObjectValue fromObject: anObject).
	anObject gtPlaygroundPageStrategy
		playgroundPageInDatabase: LeDatabasesRegistry defaultLogicalDatabase
				playgroundDB
		forObject: anObject
		ifPresent: [ :p | result playgroundPageReference: (GtLLepiterPageReference new page: p) ]
		ifAbsent: [ nil ].
	^ result
]

{ #category : #testing }
GtLObjectValueResult >> isErrorDomainObject [
	"Return true if the domain object represents some kind of failure or exception,
	instead of an expected domain object."

	^ false
]

{ #category : #'llm views' }
GtLObjectValueResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject
			title: 'Object generic details';
			object: [ self ]
]

{ #category : #'llm views' }
GtLObjectValueResult >> llmSpecificObjectViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			title: 'Object specific details';
			dataKey: 'objectDetails';
			object: [ self object ]
]

{ #category : #accessing }
GtLObjectValueResult >> object [
	^ object
]

{ #category : #accessing }
GtLObjectValueResult >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLObjectValueResult >> objectValue [
	^ objectValue
]

{ #category : #accessing }
GtLObjectValueResult >> objectValue: aSerializedObjectValue [
	objectValue := aSerializedObjectValue
]

{ #category : #descriptions }
GtLObjectValueResult >> objectValueDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Object value';
		accessor: #objectValue;
		classes: { GtLSerializedObjectValue };
		beRequired
]

{ #category : #accessing }
GtLObjectValueResult >> playgroundPageReference [
	^ playgroundPageReference
]

{ #category : #'instance creation' }
GtLObjectValueResult >> playgroundPageReference: aPageReference [
	playgroundPageReference := aPageReference
]

{ #category : #descriptions }
GtLObjectValueResult >> playgroundPageReferenceDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #playgroundPageReference;
		comment: 'The reference to the playground Lepiter page with snippets specific to the object';
		classes: { GtLLepiterPageReference};
		beOptional
]

{ #category : #printing }
GtLObjectValueResult >> printOn: aStream [
	self object printOn: aStream
]
