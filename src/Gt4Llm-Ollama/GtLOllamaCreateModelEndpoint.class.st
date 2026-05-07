Class {
	#name : #GtLOllamaCreateModelEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4Llm-Ollama-Endpoints'
}

{ #category : #'as yet unclassified' }
GtLOllamaCreateModelEndpoint >> commandClass [

	^ GtLOllamaCreateModelCommand
]

{ #category : #'encoding - decoding' }
GtLOllamaCreateModelEndpoint >> entityFromContext: aGtLContext [
	| entity |

	entity := {
			'model' -> aGtLContext name.
			'from' -> aGtLContext from.
			'stream' -> false.
		} asDictionary.
	aGtLContext template ifNotNil: [ :aString |
		entity at: 'template' put: aString ].
	aGtLContext license ifNotNil: [ :aString |
		entity at: 'license' put: aString ].
	aGtLContext system ifNotNil: [ :aString |
		entity at: 'system' put: aString ].
	aGtLContext parameters ifNotEmpty: [ :aDictionary |
		entity at: 'parameters' put: aDictionary ].
	aGtLContext messages ifNotEmpty: [ :anArray |
		entity at: 'messages' put: anArray asArray ].
	aGtLContext quantize ifNotNil: [ :aString |
		entity at: 'quantize' put: aString ].
	^ entity
]

{ #category : #accessing }
GtLOllamaCreateModelEndpoint >> path [

	^ '/api/create'
]

{ #category : #api }
GtLOllamaCreateModelEndpoint >> resultFrom: aRequestResponse context: aGtLContext [
	| rawData |
	
	rawData := NeoJSONReader fromString: aRequestResponse response contents.
	^ rawData at: 'status'
]
