Class {
	#name : #GtMagriteJSONSchemaCreationVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'currentSchema'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtMagriteJSONSchemaCreationVisitor >> currentSchema [
	"we have this state because magritte does not return the value of the accepting a visitor"
	^ currentSchema
]

{ #category : #accessing }
GtMagriteJSONSchemaCreationVisitor >> extractAnyOfSchemaForClasses: aCollectioOfClasses [ 
	| individualSchema |
	
 	individualSchema :=	aCollectioOfClasses 
 		collect: [ :aClass |
 			self extractSingleSchemaForClass: aClass ]
 		as: NeoJSONArray.
 		
 	^ NeoJSONObject  new 
		at: 'anyOf' put: individualSchema;
		yourself.
]

{ #category : #accessing }
GtMagriteJSONSchemaCreationVisitor >> extractSchemaForClasses: aCollectioOfClasses [
	^ (aCollectioOfClasses size = 1)
		ifTrue: [ self extractSingleSchemaForClass: aCollectioOfClasses anyOne ] 
		ifFalse: [ self extractAnyOfSchemaForClasses: aCollectioOfClasses ]
]

{ #category : #accessing }
GtMagriteJSONSchemaCreationVisitor >> extractSchemaWithExplicitContainersForClasses: aCollectioOfClasses [ 
	| individualSchema |
	
 	individualSchema :=	aCollectioOfClasses 
 		collect: [ :aClass |
			| singleSchema containerSchema propertiesSchema |
			singleSchema := self extractSingleSchemaForClass: aClass.
 			
			containerSchema := NeoJSONObject new
				at: 'type' put: 'object';
			yourself.
			propertiesSchema := NeoJSONObject new.
			propertiesSchema at: aClass jsonSchemaLabel put: singleSchema.
			
			containerSchema 
				at: 'properties' put: propertiesSchema;
				at: 'required'put: (NeoJSONArray withAll: {aClass jsonSchemaLabel});
				at: 'additionalProperties' put: false.
			containerSchema ]
 		as: NeoJSONArray.
 				
 	^ NeoJSONObject  new 
		at: 'anyOf' put: individualSchema;
		yourself.
]

{ #category : #accessing }
GtMagriteJSONSchemaCreationVisitor >> extractSingleSchemaForClass: aClass [
	| itemsDescription |
	itemsDescription := aClass new 
			magritteDescription.
	itemsDescription acceptMagritte:  self.
	^ self currentSchema
]

{ #category : #visiting }
GtMagriteJSONSchemaCreationVisitor >> visitBooleanDescription: aBooleanDescription [
	| schema |
	schema := NeoJSONObject new
		at: 'type' put: 'boolean';
		yourself.
	aBooleanDescription hasComment ifTrue: [
		schema at: 'description' put: aBooleanDescription comment ].
	^ currentSchema := schema
]

{ #category : #visiting }
GtMagriteJSONSchemaCreationVisitor >> visitNumberDescription: aBooleanDescription [
	| schema |
	schema := NeoJSONObject new
		at: 'type' put: 'number';
		yourself.
	aBooleanDescription hasComment ifTrue: [
		schema at: 'description' put: aBooleanDescription comment ].
	^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitPriorityContainer: aContainer [
	| schema propertiesSchema |
	schema := NeoJSONObject new
			at: 'type' put: 'object';
			yourself.
	propertiesSchema := NeoJSONObject new.
	aContainer hasComment ifTrue: [
		schema at: 'description' put: aContainer comment	].

	(aContainer children
		sorted: [ :aDescription | aDescription accessor readSelector] ascending)
		do: [ :aDescription | 
			aDescription acceptMagritte: self.
			propertiesSchema
				at: aDescription accessor readSelector
				put: self currentSchema ].
			
	schema at: 'properties' put: propertiesSchema.
	schema
		at: 'required'
			put: (aContainer children
					collect: [ :aDescription | aDescription accessor readSelector ]
					as: NeoJSONArray) sorted;
		at: 'additionalProperties' put: false.

	^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitStringDescription: aStringDescription [
	| schema |
	
	schema := NeoJSONObject  new 
			at: 'type' put: 'string';
			yourself.
			
	(aStringDescription hasProperty: 'enum') ifTrue: [
		schema 
			at: 'enum' 
			put: (aStringDescription propertyAt: 'enum') asArray ].
			
	aStringDescription hasComment ifTrue: [
		schema at: 'description' put: aStringDescription comment	].
			
	^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitToManyRelationDescription: aDescription [
	| schema itemSchema  |
	
	itemSchema :=  (aDescription shouldUseExplicitContainerForChildren)
		ifTrue: [
			self extractSchemaWithExplicitContainersForClasses: aDescription classes ]
		ifFalse: [
			self extractSchemaForClasses: aDescription classes ].
	
	schema := NeoJSONObject  new 
		at: 'type' put: 'array';
		at: 'items' put: itemSchema;
		yourself.
						
		^ currentSchema := schema
]

{ #category : #visiting }
GtMagriteJSONSchemaCreationVisitor >> visitToManyScalarRelationDescription: aDescription [
	| schema |
	schema := NeoJSONObject new
		at: 'type' put: 'array';
		at: 'items' put: (NeoJSONObject new
			at: 'type' put: 'string';
			yourself);
		yourself.
	^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitToOneRelationDescription: aDescription [ 
	^ currentSchema := self 
			extractSchemaForClasses: aDescription classes.
]
