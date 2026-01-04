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
GtMagriteJSONSchemaCreationVisitor >> extractSingleSchemaForClass: aClass [
	| itemsDescription |
	itemsDescription := aClass new 
			magritteDescription.
	itemsDescription acceptMagritte:  self.
	^ self currentSchema
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

	aContainer children
		do: [ :aDescription | 
			aDescription acceptMagritte: self.
			propertiesSchema
				at: aDescription accessor readSelector
				put: self currentSchema ].
			
	schema at: 'properties' put: propertiesSchema.
	schema
		at: 'required'
			put: (aContainer children
					collect: [ :aDescription | aDescription accessor readSelector ]);
		at: 'additionalProperties' put: false.

	^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitStringDescription: aStringDescription [
	| schema|
	schema := NeoJSONObject  new 
			at: 'type' put: 'string';
			yourself.
			
	aStringDescription hasComment ifTrue: [
		schema at: 'description' put: aStringDescription comment	].
			
	^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitToManyRelationDescription: aDescription [
	| schema itemSchema  |
	
	itemSchema := self 
		extractSchemaForClasses: aDescription classes.
	
	schema := NeoJSONObject  new 
		at: 'type' put: 'array';
		at: 'items' put: itemSchema;
		yourself.
						
		^ currentSchema := schema
]

{ #category : #'visiting-description' }
GtMagriteJSONSchemaCreationVisitor >> visitToOneRelationDescription: aDescription [ 
	^ currentSchema := self 
			extractSchemaForClasses: aDescription classes.
]
