Class {
	#name : #GtLOllamaCreateEmbeddingsEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4Llm-Ollama-Endpoints'
}

{ #category : #'as yet unclassified' }
GtLOllamaCreateEmbeddingsEndpoint >> commandClass [

	^ GtLOllamaCreateEmbeddingsCommand
]

{ #category : #'encoding - decoding' }
GtLOllamaCreateEmbeddingsEndpoint >> entityFromContext: aGtLContext [
	| entity |

	entity := {
			'model' -> aGtLContext model name.
			'input' -> aGtLContext input.
		} asDictionary.
	aGtLContext truncate ifNotNil: [ :aBoolean |
		entity at: 'truncate' put: aBoolean ].
	aGtLContext dimensions ifNotNil: [ :anInteger |
		entity at: 'dimensions' put: anInteger ].
	aGtLContext keepAlive ifNotNil: [ :aString |
		entity at: 'keep_alive' put: aString ].
	aGtLContext options ifNotNil: [ :aDictionary |
		entity at: 'options' put: aDictionary ].
	^ entity
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsEndpoint >> path [

	^ '/api/embed'
]

{ #category : #api }
GtLOllamaCreateEmbeddingsEndpoint >> resultFrom: aRequestResponse context: aGtLContext [
	| rawData |
	
	rawData := NeoJSONReader fromString: aRequestResponse response contents.
	^ GtLModelEmbeddings new
		model: aGtLContext model;
		input: aGtLContext input;
		rawData: rawData;
		embeddings: ((rawData at: 'embeddings') collect: #asFloatArray).
]
