Class {
	#name : #GtLTransformationsSchema,
	#superclass : #Object,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLTransformationsSchema >> descriptionOfTransformationSchema: aDictionary [
	^((aDictionary at: 'properties')
		at: (self nameOfTransformationSchema: aDictionary)) at: 'description'
			ifAbsent: ['']
]

{ #category : #views }
GtLTransformationsSchema >> gtJsonFor: aView [
	<gtView>
	<gtLlmView>
	^(aView textEditor)
		title: 'Schema JSON';
		priority: 2;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		text: [NeoJSONWriter toStringPretty: self schema];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the schema'
			action: [:aButton | aButton phlow spawnObject: self ]
]

{ #category : #views }
GtLTransformationsSchema >> gtSchemaFor: aView [
	<gtView>
	<gtLlmView>
	^(aView forward)
		title: 'Schema data';
		priority: 2;
		object: [self schema asGtJson];
		view: #gtJsonObjectFor:context:
]

{ #category : #views }
GtLTransformationsSchema >> gtTransformationsFor: aView [
	<gtView>
	<gtLlmView>
	^(aView columnedList)
		title: 'Transformations';
		priority: 1;
		items: [self transformationSchemas];
		column: 'Name'
			text: [:each | self nameOfTransformationSchema: each]
			width: 180;
		column: 'Description'
			text: [:each | self descriptionOfTransformationSchema: each];
		send: [:each | each asGtJson]
]

{ #category : #'llm views' }
GtLTransformationsSchema >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView jsonData
		object: [:aDictionary | aDictionary at: 'transformationsSchema' put: self schema]
]

{ #category : #accessing }
GtLTransformationsSchema >> nameOfTransformationSchema: aDictionary [
	^(aDictionary at: 'required') first
]

{ #category : #accessing }
GtLTransformationsSchema >> schema [
	^schema
]

{ #category : #accessing }
GtLTransformationsSchema >> schema: aDictionary [
	schema := aDictionary
]

{ #category : #accessing }
GtLTransformationsSchema >> transformationSchemas [
	^(((self schema at: 'properties') at: 'transformations') at: 'items')
		at: 'anyOf'
]
