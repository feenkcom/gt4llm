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
		'database',
		'dbMetadataFile',
		'dbMetadata'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #private }
LeChromaDb class >> defaultEmbeddingModelName [

	^ 'qwen3-embedding:8b'
]

{ #category : #accessing }
LeChromaDb class >> lastUpdateTimeKey [

	^ 'lastUpdateTime'
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

{ #category : #accessing }
LeChromaDb >> dbMetadata [

	^ dbMetadata ifNil: [ dbMetadata := Dictionary new ].
]

{ #category : #accessing }
LeChromaDb >> dbMetadataFile [
	"The dbMetadataFile holds metadata about the db as a whole
	(as opposed to record level metadata in the metadatas)."

	^ dbMetadataFile
]

{ #category : #accessing }
LeChromaDb >> dbMetadataFile: aFileReference [

	dbMetadataFile := aFileReference
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

{ #category : #accessing }
LeChromaDb >> lastUpdateTime [

	^ self dbMetadata at: self class lastUpdateTimeKey
]

{ #category : #actions }
LeChromaDb >> load [

	dbMetadataFile readStreamDo: [ :stream |
		dbMetadata := STON fromStream: stream ]
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
LeChromaDb >> records [

	^ client
		post: GtChromaDbGetRecordsEndpoint new
		parameters: {
			'tenant' -> collection tenant.
			'database' -> collection databaseName.
			'collectionId' -> collection id.
			} asDictionary
		entity: {
			'include' -> { 'metadatas' }.
			} asDictionary.
]

{ #category : #api }
LeChromaDb >> removeKey: aGtVectorDbLepiterKey [
	"Remove records that have metadata page matching the supplied key"
	| metadata records entity count ids |

	"Fist retrieve all the records with matching page name"
	metadata := {
		'title' -> aGtVectorDbLepiterKey lepiterPageName.
		} asDictionary.
	entity := {
		'include' -> { 'metadatas'. }.
		'where' -> metadata.
		} asDictionary.
	records := client 
		post: GtChromaDbGetRecordsEndpoint new
		parameters: {
			'tenant' -> collection tenant.
			'database' -> collection databaseName.
			'collectionId' -> collection id.
			} asDictionary
		entity: entity.

	records ifEmpty: [ ^ self ].

	"ChromaDb only seems to allow a single metadata attribute on search,
	which is the page name.  Ensure the lepiter db is correct for all records."
	self assert: (records allSatisfy: [ :each | (each metadata at: 'db') = aGtVectorDbLepiterKey lepiterDbName ]).

	ids := records collect: #id.
	"Remove the list of ids"
	entity := {
		'include' -> { 'metadatas'. }.
		'ids' -> ids.
		} asDictionary.
	count := client 
		post: GtChromaDbDeleteRecordsEndpoint new
		parameters: {
			'tenant' -> collection tenant.
			'database' -> collection databaseName.
			'collectionId' -> collection id.
			} asDictionary
		entity: entity.
	
	self assert: count = ids size.

	^ aGtVectorDbLepiterKey
]

{ #category : #actions }
LeChromaDb >> save [
	"Save the receiver's metadata"

	self updateMetadataTime.
	dbMetadataFile writeStreamDo: [ :stream |
		STON
			put: self dbMetadata
			onStreamPretty: stream ].
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

{ #category : #private }
LeChromaDb >> updateMetadataTime [

	self dbMetadata
		at: self class lastUpdateTimeKey
		put: DateAndTime now.
]
