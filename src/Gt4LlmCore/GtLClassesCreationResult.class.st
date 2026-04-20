Class {
	#name : #GtLClassesCreationResult,
	#superclass : #Object,
	#instVars : [
		'classes'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassesCreationResult >> classes [
	^ classes ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassesCreationResult >> classes: aCollection [
	classes := aCollection
]

{ #category : #'magritte-description' }
GtLClassesCreationResult >> classesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #classes;
		classes: { 
			GtLClassModificationResult. 
			GtLJSONSchemaValidationErrorDomainObject. 
			GtLMissingDomainObject. 
			GtLCouldNotCreateClassDomainObject. 
			GtLUnexpectedDomainObject };
		beRequired
]

{ #category : #views }
GtLClassesCreationResult >> gtClassesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView list
		title: 'Classes';
		priority: 1;
		items: [ self classes ];
		itemText: [ :each | 
			each isErrorDomainObject
				ifTrue: [ each printString ]
				ifFalse: [ each currentClassName ] ]
]

{ #category : #'llm - views' }
GtLClassesCreationResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #printing }
GtLClassesCreationResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		print: self classes size;
		nextPutAll: ' classes)'
]
