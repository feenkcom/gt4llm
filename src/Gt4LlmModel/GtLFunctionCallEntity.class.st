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
GtLFunctionCallEntity >> callId [

	^ self rawData at: 'call_id'
]

{ #category : #accessing }
GtLFunctionCallEntity >> description [
	^ self rawData at: 'description'
]

{ #category : #accessing }
GtLFunctionCallEntity >> name [
	^ self rawData at: 'name'
]

{ #category : #accessing }
GtLFunctionCallEntity >> parameters [
	^ self rawData at: 'parameters'
]
