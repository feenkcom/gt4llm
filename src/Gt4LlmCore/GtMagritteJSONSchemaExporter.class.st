Class {
	#name : #GtMagritteJSONSchemaExporter,
	#superclass : #Object,
	#instVars : [
		'modelClass'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtMagritteJSONSchemaExporter class >> forModelClass: aModelClass [
	^ self new 
		modelClass: aModelClass
]

{ #category : #exporting }
GtMagritteJSONSchemaExporter >> exportSchema [
	^ self exportSchemaForClass: modelClass
]

{ #category : #exporting }
GtMagritteJSONSchemaExporter >> exportSchemaAsJsonString [
	^ NeoJSONWriter toStringPretty: self exportSchema json
]

{ #category : #exporting }
GtMagritteJSONSchemaExporter >> exportSchemaData [
	^ self exportSchemaDataForClass: modelClass
]

{ #category : #exporting }
GtMagritteJSONSchemaExporter >> exportSchemaDataForClass: aClass [
	| magritteDescription schemaCreationVisitor |
	
	magritteDescription := aClass new
		magritteDescription.
	
	schemaCreationVisitor := GtMagriteJSONSchemaCreationVisitor new.
	magritteDescription acceptMagritte: schemaCreationVisitor.
	^ schemaCreationVisitor currentSchema
]

{ #category : #exporting }
GtMagritteJSONSchemaExporter >> exportSchemaForClass: aClass [
	^ NeoJSONSchema new 
			json: (self exportSchemaDataForClass: aClass).
]

{ #category : #accessing }
GtMagritteJSONSchemaExporter >> modelClass [
	^ modelClass
]

{ #category : #accessing }
GtMagritteJSONSchemaExporter >> modelClass: aClass [
	modelClass := aClass
]
