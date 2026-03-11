Class {
	#name : #GtMagritteStringStreamDataExporter,
	#superclass : #Object,
	#instVars : [
		'object',
		'stringStream'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #exporting }
GtMagritteStringStreamDataExporter >> export [
	| magritteDescription visitor |
	magritteDescription := object magritteDescription.

	visitor := GtMagriteStringStreamDataCreationVisitor new
			currentObject: object;
			stringStream: self stringStream.
	magritteDescription acceptMagritte: visitor.
]

{ #category : #accessing }
GtMagritteStringStreamDataExporter >> object [
	^ object
]

{ #category : #accessing }
GtMagritteStringStreamDataExporter >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtMagritteStringStreamDataExporter >> stringStream [
	^ stringStream
]

{ #category : #accessing }
GtMagritteStringStreamDataExporter >> stringStream: anObject [
	stringStream := anObject
]
