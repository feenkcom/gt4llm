Class {
	#name : #GtChromaDbClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'clientBuilder',
		'history'
	],
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #initialization }
GtChromaDbClient class >> defaultBaseUrl [

	^ 'http://localhost:18086' asZnUrl
]

{ #category : #private }
GtChromaDbClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	
	^ history addRequest: aClient request response: aClient response
]

{ #category : #api }
GtChromaDbClient >> addIds: idCollection documents: documentCollection embeddings: embeddingsCollection metadatas: metadataCollection to: aGtChromaDbCollection [
	| entity |

	entity := {
		'ids' -> idCollection.
		'documents' -> documentCollection.
		'embeddings' -> embeddingsCollection.
		'metadatas' -> metadataCollection.
		} asDictionary.
	^ self
		post: GtChromaDbAddCollectionRecordsEndpoint new
		parameters: {
			'tenant' -> aGtChromaDbCollection tenant.
			'database' -> aGtChromaDbCollection databaseName.
			'collectionId' -> aGtChromaDbCollection id.
			} asDictionary
		entity: entity.
]

{ #category : #accessing }
GtChromaDbClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtChromaDbClient >> baseUrl: anObject [
	baseUrl := anObject
]

{ #category : #private }
GtChromaDbClient >> checkForErrors: aResponse [

	aResponse isDictionary ifFalse: [ ^ aResponse ].
	aResponse at: 'error' ifPresent: [ :errorDetails |
		GtLOllamaError signal: errorDetails ].
	^ aResponse
]

{ #category : #api }
GtChromaDbClient >> collectionNamed: collectionName database: aGtChromaDbDatabase [
	^ self
		get: GtChromaDbGetCollectionEndpoint new
		parameters: {
			'tenant' -> aGtChromaDbDatabase tenant.
			'database' -> aGtChromaDbDatabase name.
			'collectionId' -> collectionName.
			} asDictionary
]

{ #category : #api }
GtChromaDbClient >> collectionsInDatabase: aGtChromaDatabase [

	^ self
		get: GtChromaDbGetCollectionsEndpoint new
		parameters: {
			'tenant' -> aGtChromaDatabase tenant.
			'database' -> aGtChromaDatabase name.
			} asDictionary.
]

{ #category : #api }
GtChromaDbClient >> databaseNamed: databaseName tenant: tenantName [
	^ self
		get: GtChromaDbGetDatabaseEndpoint new
		parameters: {
			'tenant' -> tenantName.
			'database' -> databaseName.
			} asDictionary
]

{ #category : #api }
GtChromaDbClient >> databasesForTenant: tenantName [


]

{ #category : #api }
GtChromaDbClient >> ensureCollectionNamed: collectionName database: aGtChromaDbDatabase [
	| entity |

	entity := {
		'configuration' -> nil.
		'get_or_create' -> true.
		'name' -> collectionName.
		'schema' -> nil.
		'metadata' -> nil.
		} asDictionary.
	^ self 
		post: GtChromaDbCreateCollectionEndpoint new
		parameters: {
			'tenant' -> aGtChromaDbDatabase tenant.
			'database' -> aGtChromaDbDatabase name.
			} asDictionary
		entity: entity.
]

{ #category : #api }
GtChromaDbClient >> get: aGtChromaDbEndpoint [

	^ self get: aGtChromaDbEndpoint parameters: #()
]

{ #category : #api }
GtChromaDbClient >> get: aGtChromaDbEndpoint parameters: parametersDictionary [

	^ self
		get: aGtChromaDbEndpoint
		parameters: parametersDictionary
		query: Dictionary new.
]

{ #category : #api }
GtChromaDbClient >> get: aGtChromaDbEndpoint parameters: parameterDictionary query: queryDictionary [
	| znUrl aClient result requestResponse |
	
	znUrl := self baseUrl / 
		(aGtChromaDbEndpoint path format: parameterDictionary).
	queryDictionary keysAndValuesDo: [ :key :value |
		znUrl queryAt: key add: value ].
	aClient := self initializeClient beOneShot.
	aClient url: znUrl.
	result := aClient get.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ aGtChromaDbEndpoint 
		resultFrom: requestResponse 
		parameters: parameterDictionary
		query: queryDictionary.
]

{ #category : #api }
GtChromaDbClient >> identity [

	^ self get: GtChromaDbGetIdentityEndpoint new
]

{ #category : #initialization }
GtChromaDbClient >> initialize [
	super initialize.
	clientBuilder := GtChromaDbZincBuilder new.
	history := GtLRequestHistory new.
	self baseUrl: self class defaultBaseUrl.
]

{ #category : #initialization }
GtChromaDbClient >> initializeClient [

	^ clientBuilder create
]

{ #category : #api }
GtChromaDbClient >> post: aGtChromaDbEndpoint parameters: parameterDictionary entity: anEntity [
	<return: #GtLRequestResponse>
	| znUrl znClient result requestResponse |

	znUrl := self baseUrl / 
		(aGtChromaDbEndpoint path format: parameterDictionary).
	znClient := self initializeClient.
	znClient url: znUrl.
	znClient contents: anEntity.
	result := znClient post.
	requestResponse := self addHistoryRequestResponse: znClient.
	requestResponse result: result.
	self checkForErrors: result.
	^ aGtChromaDbEndpoint 
		resultFrom: requestResponse 
		parameters: parameterDictionary
		entity: anEntity.
]

{ #category : #api }
GtChromaDbClient >> post: anEndpoint withEntity: anEntity [
	<return: #GtLRequestResponse>
	
	^ self
		post: anEndpoint
		parameters: Dictionary new
		entity: anEntity
]

{ #category : #api }
GtChromaDbClient >> queryEmbeddings: embeddingsCollection maxResults: anInteger include: includeAttributes in: aGtChromaDbCollection [
	| entity |
	
	entity := {
		'include' -> includeAttributes.
		'n_results' -> anInteger.
		'query_embeddings' -> embeddingsCollection.
		} asDictionary.
	^ self
		post: GtChromaDbQueryCollectionEndpoint new
		parameters: {
			'tenant' -> aGtChromaDbCollection tenant.
			'database' -> aGtChromaDbCollection databaseName.
			'collectionId' -> aGtChromaDbCollection id.
			} asDictionary
		entity: entity.
]

{ #category : #api }
GtChromaDbClient >> sizeOfCollection: aGtChromaDbCollection [
	^ self
		get: GtChromaDbGetCollectionCountEndpoint new
		parameters: {
			'tenant' -> aGtChromaDbCollection tenant.
			'database' -> aGtChromaDbCollection databaseName.
			'collectionId' -> aGtChromaDbCollection id.
			} asDictionary
]
