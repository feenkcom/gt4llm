Class {
	#name : #GtMagritteJSONDataExporter,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtMagritteJSONDataExporter class >> forObject: aModelClass [
	^ self new 
		object: aModelClass
]

{ #category : #exporting }
GtMagritteJSONDataExporter >> exportDataForObject: anObject [
	| magritteDescription visitor |
	
	magritteDescription := anObject magritteDescription.
	
	visitor := GtMagriteJSONDataCreationVisitor new
	currentObject: anObject.
	magritteDescription acceptMagritte: visitor.
	^ visitor jsonResult
]

{ #category : #exporting }
GtMagritteJSONDataExporter >> exportObject [
	^ self exportDataForObject: object
]

{ #category : #exporting }
GtMagritteJSONDataExporter >> exportObjectAsJsonString [
	^ NeoJSONWriter toStringPretty: self exportObject
]

{ #category : #accessing }
GtMagritteJSONDataExporter >> object [
	^ object
]

{ #category : #accessing }
GtMagritteJSONDataExporter >> object: anObject [
	object := anObject
]
