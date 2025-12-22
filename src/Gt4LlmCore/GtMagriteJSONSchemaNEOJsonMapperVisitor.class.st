Class {
	#name : #GtMagriteJSONSchemaNEOJsonMapperVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'neoJsonMapper'
	],
	#category : #'Gt4LlmCore-Core'
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
	| itemName targetDescriptions |

	itemName := aDescription classes size > 1 
		ifTrue: [ String streamContents: [ :s | 
			(aDescription classes collect: [ :each | each name ] )
					asStringOn: s 
					 	delimiter: 'Or' ] ]
		ifFalse: [ aDescription classes first ] .
						 
	neoJsonMapper
		for: aDescription gtJsonSchemaTypeName
		customDo: [ :mapping | 
			mapping
				listOfElementSchema: itemName.
			mapping
				writer: [ :jsonWriter :object | 
					self error: 'Writer should not be used!' ] ].
					
	targetDescriptions := aDescription classes
		collect: [ :aModelClass | 
			| magritteDescription |
			magritteDescription := aModelClass new 
				magritteDescription.
			magritteDescription properties
				at: 'originalClass'
				put: aModelClass.
			magritteDescription ].
	
	targetDescriptions do: [ :magritteDescription |
			magritteDescription acceptMagritte: self ].
			
	aDescription classes size > 1 ifTrue: [
		neoJsonMapper
			for: itemName
			customDo: [ :mapping | 
				mapping
					reader: [ :jsonReader | 
						| aResult propertyNames |
						propertyNames := jsonReader peekPropertyNames asSet .
						aResult := targetDescriptions 
							detect: [ :each | propertyNames = (each children 
								collect: [ :aProperty |
									aProperty accessor readSelector ]) asSet  ]
							ifFound: [ :each | 
								jsonReader nextAs: each gtJsonSchemaTypeName]
							ifNone: [  jsonReader parseValue].
						aResult ].
				mapping
					writer: [ :jsonWriter :object | 
						self error: 'Writer should not be used!' ] ] ].
		

]
