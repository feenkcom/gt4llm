Class {
	#name : #LeChromaDb,
	#superclass : #Object,
	#instVars : [
		'client',
		'collection',
		'model',
		'tenant',
		'databaseName',
		'collectionName',
		'database'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #private }
LeChromaDb class >> defaultEmbeddingModelName [

	^ 'qwen3-embedding:8b'
]

{ #category : #api }
LeChromaDb >> addDocuments: documentCollection keys: keyCollection [
	"Generate the embeddings for aString and store the embedding / key pair in the database with the metadata as the key"

	client
		addIds: (keyCollection collectWithIndex: [ :key :index |
			self idFor: key index: index ])
		documents: documentCollection
		embeddings: (documentCollection collect: [ :document |
			self embeddingFor: document ])
		metadatas: (keyCollection collect: [ :key |
			self metadataFrom: key ])
		to: self collection.
]

{ #category : #'private - accessing' }
LeChromaDb >> collection [
	"Answer the receiver's collection, creating it if necessary"
	
	collection ifNotNil: [ ^ collection ].

	collectionName ifNil:
		[ self error: 'Receiver''s collectionName not specified' ].
	collection := client ensureCollectionNamed: collectionName
		database: self database.
	^ collection.
]

{ #category : #accessing }
LeChromaDb >> collectionName [
	^ collectionName
]

{ #category : #accessing }
LeChromaDb >> collectionName: anObject [
	collectionName := anObject
]

{ #category : #'private - accessing' }
LeChromaDb >> database [

	^ database ifNil:
		[ database := client 
			databaseNamed: self databaseName
			tenant: self tenant ]
]

{ #category : #accessing }
LeChromaDb >> databaseName [

	^ databaseName ifNil: [ databaseName := 'default_database' ].
]

{ #category : #accessing }
LeChromaDb >> databaseName: anObject [
	databaseName := anObject
]

{ #category : #private }
LeChromaDb >> embeddingFor: aString [
	| command newEmbeddings |
	
	command := self model newCreateEmbeddingsCommand.
	command context input: aString.
	newEmbeddings := command perform.
	^ newEmbeddings embeddings first
]

{ #category : #private }
LeChromaDb >> idFor: key index: index [

	^ key lepiterPage uidString, ':', index asString
]

{ #category : #initialization }
LeChromaDb >> initialize [

	super initialize.
	client := GtChromaDbClient new.
]

{ #category : #private }
LeChromaDb >> metadataFrom: key [

	^ {
		'db' -> key lepiterDbName.
		'title' -> key lepiterPageName.
		} asDictionary
]

{ #category : #private }
LeChromaDb >> model [

	^ model ifNil: [ model := GtLModelFactory new
			ollama_generate: self class defaultEmbeddingModelName ]
]

{ #category : #api }
LeChromaDb >> query: queryString maxMatches: anInteger [
	"Generates the embedding for the supplied string and return a collection of keyObjects sorted by embedding distance"
	<return: #GtLNearestEmbeddingGroup>
	| requestResponse metadatas distances documents |

	requestResponse := client
		queryEmbeddings: { self embeddingFor: queryString }
		maxResults: anInteger
		include: #('documents' 'metadatas' 'distances')
		in: self collection.
	metadatas := (requestResponse result at: 'metadatas') first.
	documents := (requestResponse result at: 'documents') first.
	distances := (requestResponse result at: 'distances') first.
	^ GtLNearestEmbeddingGroup new items: (Array streamContents: [ :stream |
		metadatas doWithIndex: [ :metadata :index | 
			| distance document |
			distance := distances at: index.
			document := documents at: index.
			stream nextPut: (GtLNearestEmbedding new
				distance: distance;
				document: document;
				embedding: (GtLVectorDbEmbedding new
					key: (GtVectorDbLepiterKey new
						lepiterDbName: (metadata at: 'db');
						lepiterPageName: (metadata at: 'title')))) ] ])
]

{ #category : #accessing }
LeChromaDb >> size [
	"Answer the number of records in the receiver's collection"

	^ client sizeOfCollection: self collection
]

{ #category : #accessing }
LeChromaDb >> tenant [
	^ tenant ifNil: [ tenant := 'default_tenant' ]
]

{ #category : #accessing }
LeChromaDb >> tenant: anObject [
	tenant := anObject
]
