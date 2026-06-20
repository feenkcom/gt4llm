"
Represents a function call backed by raw JSON data. The arguments field is stored as a JSON-encoded string and is deserialized on access.
"
Class {
	#name : #GtLFunctionCallEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLFunctionCallEntity >> arguments [
	^ NeoJSONObject fromString: (self rawData at: 'arguments')
]

{ #category : #accessing }
GtLFunctionCallEntity >> name [
	^ self rawData at: 'name'
]
