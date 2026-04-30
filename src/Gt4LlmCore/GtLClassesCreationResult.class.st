Class {
	#name : #GtLClassesCreationResult,
	#superclass : #Object,
	#instVars : [
		'classes'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassesCreationResult >> classCreationResults [
	^ self classes
]

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

{ #category : #'gt-extensions' }
GtLClassesCreationResult >> gtClassesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Classes';
		priority: 1;
		items: [ self classes ];
		column: 'Class'
			text: [ :each | 
				each isErrorDomainObject
					ifTrue: [ each printString ]
					ifFalse: [ each currentClassName ] ];
		column: 'Package' text: [ :each | each packageName ]
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

{ #category : #accessing }
GtLClassesCreationResult >> successfulClassCreationResults [
	^ self classCreationResults reject: [ :aClassCreationResult |
			aClassCreationResult isErrorDomainObject ]
]
