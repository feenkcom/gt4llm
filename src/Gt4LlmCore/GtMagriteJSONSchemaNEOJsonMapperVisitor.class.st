Class {
	#name : #GtMagriteJSONSchemaNEOJsonMapperVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'neoJsonMapper'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtMagriteJSONSchemaNEOJsonMapperVisitor class >> forNeoJsonMapper: aNeoJsonMapper [ 
	^ self new  
		neoJsonMapper: aNeoJsonMapper 
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> addExtraMappingsForDescriptors: targetDescriptions [ 
	| itemName  |
	itemName := String streamContents: [ :s | 
			(targetDescriptions collect: [ :each | 
						(each properties at: 'originalClass' ) name ] )
					asStringOn: s 
					 	delimiter: 'Or' ].
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
						self error: 'Writer should not be used!' ] ] 
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> addMappingForArrayOfEntitiesFor: aDescription [ 
	| itemName |
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
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> addMappingsForClasses: aCollectionOfClasses [
	| targetDescriptions |
	
	targetDescriptions := aCollectionOfClasses
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

	aCollectionOfClasses size > 1  
		ifTrue: [ 
			self addExtraMappingsForDescriptors: targetDescriptions ].
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> addMappingWithExplicitContainersFor: aDescription [ 
	| itemName |
	
	self 
		assert:  aDescription classes size > 1  
		description: 'Explicit container only works with multiple classes'.

	itemName := aDescription classes size > 1 
		ifTrue: [ 'EntityFromContainerOfType', (String streamContents: [ :s | 
			(aDescription classes collect: [ :each | each name ] )
					asStringOn: s 
					 	delimiter: 'Or' ]) ]
		ifFalse: [ Error signal: 'Not Supported' ] .
		
	neoJsonMapper
		for: aDescription gtJsonSchemaTypeName
		customDo: [ :mapping | 
			mapping
				listOfElementSchema: itemName.
			mapping
				writer: [ :jsonWriter :object | 
					self error: 'Writer should not be used!' ] ].

	neoJsonMapper
		for: itemName
		customDo: [ :mapping | 
			mapping reader: [ :jsonReader | 
				| result |
				result := OrderedCollection new.
				jsonReader parseMapKeysDo: [ :key | 
					| value |
					aDescription classes 
						detect: [ :aDomainClass | 
							aDomainClass jsonSchemaLabel = key ]
						ifFound: [ :aDomainClass |
							value := jsonReader nextAs: aDomainClass. ]
						ifNone: [ Error signal: 'Schema not found: ', key ].
					result add: value ].
					self 
						assert: result size = 1 
						description: 'Only '.
						
					result first ].
			mapping writer: [ :jsonWriter :map | 
				self error: 'to be implemented' ] ].
]

{ #category : #accessing }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> neoJsonMapper: aNeoJsonMapper [ 
	neoJsonMapper := aNeoJsonMapper 
]

{ #category : #'visiting-description' }
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

{ #category : #'visiting-description' }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> visitToManyRelationDescription: aDescription [

	(aDescription shouldUseExplicitContainerForChildren)
		ifTrue: [
			self addMappingWithExplicitContainersFor: aDescription ]
		ifFalse: [
			self addMappingForArrayOfEntitiesFor: aDescription].
	
	self addMappingsForClasses: aDescription classes.
]

{ #category : #visiting }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> visitToManyScalarRelationDescription: aDescription [
	neoJsonMapper
		for: aDescription gtJsonSchemaTypeName
		customDo: [ :mapping |
			mapping listOfType: Array ]
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaNEOJsonMapperVisitor >> visitToOneRelationDescription: aDescription [
	
	self addMappingsForClasses: aDescription classes.
]
