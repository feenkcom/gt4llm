Class {
	#name : #GtLTransformationsSchema,
	#superclass : #Object,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #views }
GtLTransformationsSchema >> gtSchemaFor: aView [
	<gtView>
	<gtLlmView>
	^(aView forward)
		title: 'Schema';
		priority: 1;
		object: [self schema asGtJson];
		view: #gtJsonObjectFor:context:
]

{ #category : #'llm views' }
GtLTransformationsSchema >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView jsonData
		object: [:aDictionary | aDictionary at: 'transformationsSchema' put: self schema]
]

{ #category : #accessing }
GtLTransformationsSchema >> schema [
	^schema
]

{ #category : #accessing }
GtLTransformationsSchema >> schema: aDictionary [
	schema := aDictionary
]
