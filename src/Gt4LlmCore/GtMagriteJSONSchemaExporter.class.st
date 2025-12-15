Class {
	#name : #GtMagriteJSONSchemaExporter,
	#superclass : #Object,
	#category : #Gt4LlmCore
}

{ #category : #exporting }
GtMagriteJSONSchemaExporter >> exportSchemaDataForClass: aClass [
	| magritteDescription schemaCreationVisitor |
	
	magritteDescription := aClass new 
		magritteDescription.
	
	schemaCreationVisitor := GtMagriteJSONSchemaCreationVisitor new.
	magritteDescription acceptMagritte: schemaCreationVisitor.
	^ schemaCreationVisitor currentSchema
]

{ #category : #exporting }
GtMagriteJSONSchemaExporter >> exportSchemaForClass: aClass [
	^ NeoJSONSchema new 
			json: (self exportSchemaDataForClass: aClass).
]
