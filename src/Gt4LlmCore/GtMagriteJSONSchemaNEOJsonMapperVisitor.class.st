Class {
	#name : #GtMagriteJSONSchemaNEOJsonMapperVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'neoJsonMapper'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtMagriteJSONSchemaNEOJsonMapperVisitor class >> forNeoJsonMapper: aNeoJsonMapper [ 
	^ self new  
		neoJsonMapper: aNeoJsonMapper 
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> neoJsonMapper: aNeoJsonMapper [ 
	neoJsonMapper := aNeoJsonMapper 
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> visitPriorityContainer: aContainer [
	
	neoJsonMapper
		for: aContainer gtJsonSchemaTypeName
		do: [ :mapping | 
			aContainer children do: [ :aDescriptor |
				(mapping mapAccessor: aDescriptor accessor readSelector) 
					valueSchema: aDescriptor gtJsonSchemaTypeName  ] ].
			
	aContainer children
		do: [ :aDescription | 
			aDescription acceptMagritte: self ].
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> visitToManyRelationDescription: aDescription [
	
	neoJsonMapper
		for: aDescription gtJsonSchemaTypeName
		customDo: [ :mapping | 
			mapping
				listOfElementSchema: aDescription classes first.
			mapping
				writer: [ :jsonWriter :object | 
					self error: 'Writer should not be used!' ] ].
			
	aDescription classes
		do: [ :aModelClass | 
			| magritteDescription |
			magritteDescription := aModelClass new 
				magritteDescription.
			magritteDescription properties
				at: 'originalClass'
				put: aModelClass.
	
			magritteDescription acceptMagritte: self ].
]
