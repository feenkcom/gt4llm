"
A simple in-memory vector database that stores document embeddings associated with arbitrary keys and supports nearest-neighbor queries.
"
Class {
	#name : #GtSimpleInMemoryVectorDatabase,
	#superclass : #Object,
	#instVars : [
		'model',
		'distanceMetric',
		'embeddingsByKey',
		'embeddings'
	],
	#category : #'Gt4Llm-VectorDb-Model'
}

{ #category : #initialization }
GtSimpleInMemoryVectorDatabase class >> defaultDistanceMetric [
	^ GtLlmCosineDistanceMetric new
]

{ #category : #accessing }
GtSimpleInMemoryVectorDatabase class >> defaultEmbeddingModelName [

	^ 'qwen3-embedding:8b'
]

{ #category : #api }
GtSimpleInMemoryVectorDatabase >> addDocument: aString key: keyObject [
	"Generate the embeddings for aString and store the embedding / key pair in a dictionary with the embedding as the dictionaries key"
	| embedding |
	embedding := self embeddingFor: aString key: keyObject.
	embeddings add: embedding.
	^ keyObject
]

{ #category : #accessing }
GtSimpleInMemoryVectorDatabase >> distanceMetric [
	^ distanceMetric
]

{ #category : #private }
GtSimpleInMemoryVectorDatabase >> embeddingFor: aString [
	| command newEmbeddings |
	command := model newCreateEmbeddingsCommand.
	command context input: aString.
	newEmbeddings := command perform.
	^ GtLVectorDbEmbedding new
		embedding: newEmbeddings embeddings first;
		yourself
]

{ #category : #api }
GtSimpleInMemoryVectorDatabase >> embeddingFor: aString key: keyObject [
	"Generate the embedding for the supplied aString and key"
	| embedding |
	embedding := self embeddingFor: aString.
	embedding key: keyObject.
	^ embedding
]

{ #category : #'private - accessing' }
GtSimpleInMemoryVectorDatabase >> embeddings [

	^ embeddings
]

{ #category : #initialization }
GtSimpleInMemoryVectorDatabase >> initialize [
	super initialize.
	model := GtLModelFactory new
			ollama_generate: self class defaultEmbeddingModelName.
	distanceMetric := self class defaultDistanceMetric.
	embeddings := OrderedCollection new
]

{ #category : #accessing }
GtSimpleInMemoryVectorDatabase >> model [
	^ model
]

{ #category : #api }
GtSimpleInMemoryVectorDatabase >> query: queryString maxMatches: anInteger [
	"Generates the embedding for the supplied string and return a collection of keyObjects sorted by embedding distance"
	| queryEmbedding nearestEmbeddings sorted |
	queryEmbedding := self embeddingFor: queryString.
	nearestEmbeddings := GtLlmEmbeddingsUtilities
		distancesFromEmbeddings: embeddings
		to: queryEmbedding
		usingMetric: distanceMetric.
	sorted := nearestEmbeddings sorted: [ :a :b | a distance < b distance ].
	^ sorted first: (anInteger min: sorted size)
]

{ #category : #accessing }
GtSimpleInMemoryVectorDatabase >> removeEmbedding: anEmbedding [

	embeddings remove: anEmbedding.
]

{ #category : #saving }
GtSimpleInMemoryVectorDatabase >> stonTo: aFileReference [
	| fileReference |
	
	fileReference := aFileReference asFileReference.
	fileReference ensureDelete.
	fileReference writeStreamDo: [ :stream |
		STON put: self onStream: stream ].
]
